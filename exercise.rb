require 'net/ftp'
require 'net/http'
require 'json'
require 'nokogiri'
require 'nori'
require 'uri'

#Must receive all these as arguments, as to not expose any sensitive information on the code
SALSIFY_FTP_HOST, SALSIFY_FTP_USER, SALSIFY_FTP_PASSWORD, SALSIFY_API_ADDRESS, SALSIFY_API_KEY = ARGV

#Retrieve products.xml
def getXml(ftp)
  xmlfile = ftp.gettextfile('products.xml', nil)

  puts "XML File retrieved from FTP server"

  xmlfile
end

#Convert XML to Json
def convertXML(xmlfile)
  #Parse xml
  xml = Nokogiri::XML(xmlfile)

  #Convert xml to hash
  parser = Nori.new
  hash = parser.parse(xml.to_s)

  #Convert hash to json
  json = hash.to_json

  #Parse json
  data = JSON.parse(json)

  puts "XML File converted to JSON"

  data
end

#Calls Salsify API to update the products
def updateProducts(data)
  #Retrieve each individual product
  products = data['products']['product']
  products.each do |product|
    finalproduct = cleanProducts(product)

    #Retrieve product identifier
    sku = finalproduct["SKU"]

    #Build uri
    uri = URI.parse(SALSIFY_API_ADDRESS + sku)

    #Create request
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Put.new(uri.request_uri)
    request.body = finalproduct.to_json
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{SALSIFY_API_KEY}"

    #Make API call
    response = http.request(request)

    if response.code == "204"
      puts "Product with SKU = #{sku} updated with success"
    else
      puts "Error updating product with SKU = #{sku}. Error: #{response.message}"
    end

  end

end

#Helper method to remove '@' from keys
def cleanProducts(product)
  #Empty object to store clean version of product
  finalproduct = {}

  #SKU and Item_Name had a '@' before their name so I'm removing that
  product.each do |key, value|
    tempkey = key.gsub('@', '')
    finalkey = tempkey.gsub('_', ' ')
    finalproduct[finalkey] = value
  end

  finalproduct
end

def main

  #Check if all arguments were passed.
  if ARGV.length != 5
    puts "You must provide all required arguments"
    exit 1
  end

  #Try to connect to the FTP server
  begin
    ftp = Net::FTP.new(SALSIFY_FTP_HOST)
    ftp.login(SALSIFY_FTP_USER, SALSIFY_FTP_PASSWORD)
  rescue => e
    puts "Error connecting to the FTP server with message: #{e.message}"
    exit 1
  end

  #Try to retrieve XML file
  begin
    xmlfile = getXml(ftp)
  rescue => e
    puts "Error retrieving XML file with message: #{e.message}"
    exit 1
  end

  #Try to convert XML file to JSON
  begin
    data = convertXML(xmlfile)
  rescue => e
    puts "Error converting XML file to JSON with message: #{e.message}"
    exit 1
  end

  #Try to update procuts on Salsify API
  begin
    updateProducts(data)
  rescue => e
    puts "Error updating products with message: #{e.message}"
    exit 1
  end

  ftp.close
end

#Call main method
main