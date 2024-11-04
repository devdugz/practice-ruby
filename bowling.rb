puts "How many pins did you knock down? "
result = gets.chomp.to_i
if result > 10
  puts "Error: too many pins"
elsif result >= 0
  puts "Great Job, your score is now #{result} "
end
