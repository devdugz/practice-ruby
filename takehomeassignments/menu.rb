require "csv"

def find_combinations(prices, target)
  menu_items = prices.keys

  1.upto(menu_items.length) do |i|
    menu_items.combination(i).each do |combo|
      total = combo.sum { |item| prices[item] }
      if (total - target).abs < 0.01
        return combo
      end
    end
  end
  nil
end

# Read raw CSV without headers
filename = ARGV[0] || "prices.csv"
raw_data = CSV.read(filename)

# Get target price from first row second column
target_price = raw_data[0][1].gsub(/[$,]/, "").to_f

# Create prices hash (skip first row)
prices = {}
raw_data[1..-1].each do |row|
  item_name = row[0]
  price = row[1].gsub(/[$,]/, "").to_f
  prices[item_name] = price
end

solution = find_combinations(prices, target_price)

if solution
  puts "\nFound combination for $#{target_price}:"
  solution.each do |item|
    puts "- #{item}: $#{prices[item]}"
  end
  puts "Total: $#{solution.sum { |item| prices[item] }}"
else
  puts "No combination found for $#{target_price}"
end
