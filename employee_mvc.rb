require "sqlite3"
require "tty-table"

class Employee
  @@db = SQLite3::Database.open "employee.db"
  @@db.execute "CREATE TABLE IF NOT EXISTS employees(id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, salary INTEGER, active INTEGER)"

  attr_reader :id, :first_name, :last_name, :active, :salary
  attr_writer :active

  def initialize(input_options)
    @id = input_options[:id]
    @first_name = input_options[:first_name]
    @last_name = input_options[:last_name]
    @salary = input_options[:salary]
    @active = input_options[:active]
  end

  def self.create(options)
    @@db.execute "INSERT INTO employees (first_name, last_name, salary, active) VALUES (?, ?, ?, ?)",
      [options[:first_name], options[:last_name], options[:salary], options[:active]]
  end

  def self.all
    results = @@db.query "SELECT * FROM employees"
    results.map do |row|
      Employee.new(id: row[0], first_name: row[1], last_name: row[2], salary: row[3], active: row[4])
    end
  end

  def self.find_by(options)
    results = @@db.query "SELECT * FROM employees WHERE id = ?", options[:id]
    first_result = results.next
    Employee.new(id: first_result[0], first_name: first_result[1], last_name: first_result[2], salary: first_result[3], active: first_result[4])
  end

  def update(options)
    if options[:active] == "true"
      active = 1
    else
      active = 0
    end
    @@db.execute "UPDATE employees SET active = ? WHERE id = ?", [active, self.id]
  end

  def destroy
    @@db.execute "DELETE FROM employees WHERE id = ?", self.id
  end
end

class View
  def self.display_employees(employees)
    header = ["id", "first_name", "last_name", "salary", "active"]
    rows = employees.map { |employee| [employee.id, employee.first_name, employee.last_name, employee.salary, employee.active] }
    table = TTY::Table.new header, rows
    puts "EMPLOYEES (#{rows.length} total)"
    puts table.render(:unicode)
    puts
  end

  def self.display_employee(employee)
    puts "Id: #{employee.id}"
    puts "First name: #{employee.first_name}"
    puts "Last name: #{employee.last_name}"
    puts "Salary: #{employee.salary}"
    puts "Active: #{employee.active}"
    puts
    print "Press enter to continue"
    gets.chomp
  end

  def self.display_exit_screen
    system "clear"
    puts "Goodbye!"
  end

  def self.display_error_screen
    puts "Invalid choice"
    print "Press enter to continue"
    gets.chomp
  end

  def self.get_menu_option
    print "[C]reate [R]ead [U]pdate [D]elete [Q]uit: "
    gets.chomp.downcase
  end

  def self.get_create_options
    print "First name: "
    input_first_name = gets.chomp
    print "Last name: "
    input_last_name = gets.chomp
    print "Salary: "
    input_salary = gets.chomp.to_i
    { first_name: input_first_name, last_name: input_last_name, salary: input_salary, active: 1 }
  end

  def self.get_read_options
    print "Employee id: "
    input_id = gets.chomp.to_i
    { id: input_id }
  end

  def self.get_update_options
    print "Employee id: "
    input_id = gets.chomp.to_i
    print "Update active status (true or false): "
    input_active = gets.chomp
    { id: input_id, active: input_active }
  end

  def self.get_destroy_options
    puts "Delete employee"
    print "Enter employee id: "
    input_id = gets.chomp.to_i
    { id: input_id }
  end
end

class Controller
  def self.run
    while true
      system "clear"
      employees = Employee.all
      View.display_employees(employees)
      input_choice = View.get_menu_option
      if input_choice == "c"
        input_options = View.get_create_options
        Employee.create(input_options)
      elsif input_choice == "r"
        input_options = View.get_read_options
        employee = Employee.find_by(input_options)
        View.display_employee(employee)
      elsif input_choice == "u"
        input_options = View.get_update_options
        employee = Employee.find_by(id: input_options[:id])
        employee.update(input_options)
      elsif input_choice == "d"
        input_options = View.get_destroy_options
        employee = Employee.find_by(input_options)
        employee.destroy
      elsif input_choice == "q"
        View.display_exit_screen
        return
      else
        View.display_error_screen
      end
    end
  end
end

Controller.run
