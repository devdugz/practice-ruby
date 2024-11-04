require "http"

system "clear"
puts "Welcome to the weather app"

puts "What city would you like the weather too?"
city = gets.chomp

puts "Would you like [F]ahrenheit or [C]elsius?"
unit_choice = gets.chomp.downcase
system "clear"

unit = if unit_choice == "c"
    "metric"
  else
    "imperial"
  end

response = HTTP.get ("https://api.openweathermap.org/data/2.5/weather?q=#{city}&units=#{unit}&appid=#{ENV["OPEN_WEATHER_API_KEY"]}")
data = response.parse

if data["cod"] == 200
  temperature = data["main"]["temp"]
  wind = data["wind"]["speed"]
  high = data["main"]["temp_max"]
  low = data["main"]["temp_min"]
  humidity = data["main"]["humidity"]
  description = data["weather"][0]["description"]

  puts "The tempature in #{city} is #{data["main"]["temp"]} degrees"
  puts "Here's a current weather description: #{data["weather"][0]["description"]}"
  puts "The wind speed is #{data["wind"]["speed"]} MPH"
  puts "The high is #{data["main"]["temp_max"]} and the low is #{data["main"]["temp_min"]}"
  puts "The humidity is #{data["main"]["humidity"]}"
else
  puts "Error: #{data["message"]}. Please check the city name and try again."
end
