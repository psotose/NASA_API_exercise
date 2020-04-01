require 'uri'
require 'net/http'
require 'openssl'
require 'json'

def get_data(url_inicial)
    url = URI(url_inicial)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    JSON.parse(response.read_body)
end

url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&page=2&api_key=DEMO_KEY"

data_to_process = get_data(url)

def head
    "<!DOCTYPE html>\n
        <html lang='en'>\n
        <head>\n
            <meta charset='UTF-8'>\n
            <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n
            <meta http-equiv='X-UA-Compatible' content='ie=edge'>\n
            <title>Document</title>\n
        </head>\n
        <body>\n"
end  

def footer
    "\t</body>\n
        </html>"
end        

def build_web_page(data_to_process)
    File.open("index.html", "w") do |f|
        f.puts head
        f.puts "\t\t<ul>\n"
        data_to_process['photos'].each do |key|
        f.puts "\t\t\t<li><img src='#{key['img_src']}' alt ='#{key['earth_date']}'></li>\n"
        end     
        f.puts "\t\t</ul>\n"
        f.puts footer 
    end   
end     

puts build_web_page(data_to_process)

def photos_count(data_to_process)
    camera_name_and_shots = {}
    data_to_process['photos'].each_with_index do |photo, index|
      camera_name_and_shots[index] = { :camera_name => photo['camera']['name'], :shots => photo['rover']['total_photos']}
    end    
    return camera_name_and_shots
end

puts photos_count(data_to_process)

