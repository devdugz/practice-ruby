item1 = { item_name: "Sony", item_model: "FX3", item_price: 3500 }
item2 = { item_name: "Red", item_model: "Komodo", item_price: 4995 }
item3 = { item_name: "Black Magic", item_model: "Pocket 6k", item_price: 2999 }
puts "#{item1[:item_name]} #{item1[:item_model]} #{item1[:item_price]}"
puts "#{item2[:item_name]} #{item2[:item_model]} #{item2[:item_price]}"
puts "#{item3[:item_name]} #{item3[:item_model]} #{item3[:item_price]}"

class Storeitem
  attr_reader :item_name, :item_model
  attr_writer :item_price

  def initialize(input_item_name, input_item_model, input_item_price)
    @item_name = input_item_name
    @item_model = input_item_model
    @item_price = input_item_price
  end

  def print_info
    puts "#{@item_name} #{@item_model} costs #{@item_price}."
  end
end

item1 = Storeitem.new("Sony", "FX3", 3500)
item2 = Storeitem.new("Red", "Komodo", 4995)
item3 = Storeitem.new("Black Magic", "Pocket 6k", 2999)

item1.print_info
