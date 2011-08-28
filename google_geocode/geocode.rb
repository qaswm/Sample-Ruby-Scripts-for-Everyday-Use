require 'rubygems'
require 'fileutils'
require 'faster_csv'
require 'net/http'
require 'uri'

unless ARGV.length == 2
  puts "Please provide the input and output file names.\n"
  puts "Usage: ruby geocode.rb InputFile.csv OutputFile.csv\n"
  exit
end

# get the input & output filenames from the command line
input_file = ARGV[0]
output_file = ARGV[1]

geocoder = "http://maps.google.com/maps/geo?q="
output = "&output=csv"
# add your own google api key here.
apikey = "&key=[Add Key Here]"
FasterCSV.open("#{output_file}", "w", :force_quotes => true) { |csv|
  FasterCSV.foreach("#{input_file}", :quote_char => '"', :col_sep =>',', :row_sep =>:auto) { |row|
    address = [row[0], row[1], row[2], "USA"].join(", ")
    request = geocoder + address + output + apikey
    url = URI.escape(request)
    resp = Net::HTTP.get_response(URI.parse(url))
    fields = resp.body.split(',')
    csv << ["#{row[0]}", "#{row[1]}", "#{row[2]}", "#{fields[2]}", "#{fields[3]}"]
  }
}
