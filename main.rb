require 'net/http'
require 'rexml/document'
require_relative 'lib/forecast'

CITIES = {
  37 => 'Москва',
  69 => 'Санкт-Петербург',
  99 => 'Новосибирск',
  59 => 'Пермь',
  115 => 'Орел',
  121 => 'Чита',
  141 => 'Братск',
  199 => 'Краснодар'
}.invert.freeze

city_names = CITIES.keys

puts 'Погоду для какого города Вы хотите узнать?'
city_names.each_with_index { |name, index| puts "#{index + 1}: #{name}" }
city_index = gets.to_i
unless city_index.between?(1, city_names.size)
  city_index = gets.to_i
  puts "Введите число от 1 до #{city_names.size}"
end

city_id = CITIES[city_names[city_index - 1]]

url = "https://xml.meteoservice.ru/export/gismeteo/point/#{city_id}.xml"

response = Net::HTTP.get_response(URI.parse(url))
doc = REXML::Document.new(response.body)

city_name = URI.decode_www_form_component(doc.root.elements['REPORT/TOWN'].attributes['sname'])

forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a

puts city_name
puts

forecast_nodes.each do |node|
  puts Forecast.from_xml(node)
  puts
end
