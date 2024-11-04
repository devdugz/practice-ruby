# item1 = { item_name: "Sony", item_model: "FX3", item_price: 3500 }
# item2 = { item_name: "Red", item_model: "Komodo", item_price: 4995 }
# item3 = { item_name: "Black Magic", item_model: "Pocket 6k", item_price: 2999 }
# puts "#{item1[:item_name]} #{item1[:item_model]} #{item1[:item_price]}"
# puts "#{item2[:item_name]} #{item2[:item_model]} #{item2[:item_price]}"
# puts "#{item3[:item_name]} #{item3[:item_model]} #{item3[:item_price]}"

# class Storeitem
#   attr_reader :item_name, :item_model
#   attr_writer :item_price

#   def initialize(input_item_name, input_item_model, input_item_price)
#     @item_name = input_item_name
#     @item_model = input_item_model
#     @item_price = input_item_price
#   end

#   def print_info
#     puts "#{@item_name} #{@item_model} costs #{@item_price}."
#   end
# end

# item1 = Storeitem.new("Sony", "FX3", 3500)
# item2 = Storeitem.new("Red", "Komodo", 4995)
# item3 = Storeitem.new("Black Magic", "Pocket 6k", 2999)

# item1.print_info

require "sqlite3"
require "tty-table"

db = SQLite3::Database.open "store.db"
db.execute "CREATE TABLE IF NOT EXISTS store (ID INTEGER PRIMARY KEY, item_name TEXT, item_model TEXT, item_price INTEGER, active INTEGER)"

while true
  system "clear"
  results = db.query "SELECT * FROM store"
  header = ["ID", "item_name", "item_model", "item_price", "active"]
  rows = results.to_a
  table = TTY::Table.new header, rows
  puts "STORE ITEMS (#{rows.length} total)"
  puts table.render(:unicode)
  puts
  print "[C]reate [R]ead [U]pdate [D]elete, [Q]uit: "
  input_choice = gets.chomp.downcase
  if input_choice == "c"
    print "Item name: "
    input_item_name = gets.chomp
    print "Item model: "
    input_item_model = gets.chomp
    print "Item price: "
    input_item_price = gets.chomp
    db.execute "INSERT INTO store (item_name, item_model, item_price, active) VALUES (?, ?, ?, ?)", [input_item_name, input_item_model, input_item_price, 1]
  elsif input_choice == "r"
    print "Store item ID: "
    input_id = gets.chomp.to_i
    results = db.query "SELECT * FROM store WHERE id = ?", input_id
    first_result = results.next
    puts "ID: #{first_result[0]}"
    puts "Item name: #{first_result[1]}"
    puts "Item model: #{first_result[2]}"
    puts "Item price: #{first_result[3]}"
    puts "Active: #{first_result[4]}"
    puts
    print "Press enter to continue"
    gets.chomp
  elsif input_choice == "u"
    print "Store item ID: "
    input_id = gets.chomp.to_i
    print "Update active status (true or false): "
    input_active = gets.chomp
    if input_active == "true"
      input_active = 1
    else
      input_active = 0
    end
    db.execute "UPDATE store SET active = ? WHERE id = ?", [input_active, input_id]
  elsif input_choice == "d"
    puts "Delete store item"
    print "Enter store item ID: "
    input_id = gets.chomp.to_i
    db.execute "DELETE FROM store WHERE id = ?", input_id
  elsif input_choice == "q"
    system "clear"
    puts "Goodbye!"
    return
  else
    puts "Invalid choice"
    print "Press enter to continue"
    gets.chomp
  end
end
