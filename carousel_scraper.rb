require 'nokogiri'
require 'open-uri'
require 'cgi'
require 'json'

##
# scrapes a remote html file that is a Google search showing
# results in a carousel format

class CarouselScraper
  @@default_url = 'https://raw.githubusercontent.com/serpapi/code-challenge/master/files/van-gogh-paintings.html'

  def initialize(url = @@default_url)
    @url = url
    @doc = Nokogiri::HTML(URI.open(@url))
    @document_text = @doc.text
    @artworks = []
    @result = []
  end

  ##
  # takes an img which referes to the <img /> tag while the parsing
  # is happening. extracts the img id and finds its src in the
  # js portion of the html file based on its position in the file
  
  def image_src(img)

    img_element = img.at('img')

    # Get the value of the "id" attribute for this image
    image_id = img_element['id']
    id_position = @document_text.index("['#{image_id}']")

    # find src in the js portion of the html file 
    if id_position
      target_string = "var s=" # delimiter starting for every img src
      nearest_index = @document_text.rindex(target_string, id_position)
      prev_semicolon = @document_text.rindex(";", id_position)
      start_pos = nearest_index + target_string.length + 1
      end_pos = id_position - (id_position - prev_semicolon + 1)
      img_src =  @document_text[start_pos...end_pos].gsub('\\', '')
      return img_src
    else
      return nil
    end
    
  end

  # returns link with proper domain name appended 
  def source_link(link)
    return "https://www.google.com#{link}"
  end

  ##
  # processes html file and stores relevant information 
  # (name, extensions, link, and image) in the result variable
  def parse

    @doc.css("g-scrolling-carousel div a").each do |element|

      img = element.css('img')

      text = element.text
      title = element['title']
      link = element['href']

      name = element['aria-label']
      extensions = []

      if name
        extensions = text.split(name).select {|el| !el.empty?}
      end

      # convert link and img to proper format
      unescaped_link = CGI.unescapeHTML(link)
      source = source_link(unescaped_link)
      image = image_src(img)

      data = {}

      data['name'] = name
      if !extensions.empty?
        data['extensions'] = extensions
      end
      data['link'] = source
      data['image'] = image

      # don't add extraneous results if aria-label (name) is nil

      if name
        @artworks.push(data)
      end
    end
    @result = {"artworks": @artworks}
    return @result
  end

  # writes @result to json file
  def write_to_file
    parse
    File.open('result.json', 'w') do |file|
      file.write(JSON.generate(@result))
    end
  end

  


end

# scraper = CarouselScraper.new
# p scraper.parse
# scraper.write_to_file


