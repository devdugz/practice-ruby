require "http"

response = HTTP.get ("https://data.sfgov.org/resource/jjew-r69b.json")

data = response.parse

puts "The first truck's data is #{data[0]}"
