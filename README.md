# Extract Van Gogh Paintings Code Challenge

Goal is to extract a list of Van Gogh paintings from the attached Google search results page.

![Van Gogh paintings](https://github.com/serpapi/code-challenge/blob/master/files/van-gogh-paintings.png?raw=true "Van Gogh paintings")

## Tools

Uses [Nokogiri] to parse the HTML after reading in the HTML file

[CGI] to unescape necessary properties

[OpenURI] to open the remote html file

[JSON] to write the resulting hash to the `.json` file

[nokogiri]: https://nokogiri.org/index.html
[cgi]: https://ruby-doc.org/stdlib-2.5.1/libdoc/cgi/rdoc/CGI.html
[openuri]: https://github.com/ruby/open-uri
[json]: https://ruby-doc.org/stdlib-3.0.0/libdoc/json/rdoc/JSON.html

## Instructions

How to run the program:

`ruby carousel_scraper.rb`

`Carousel Scraper` in `carousel_scraper.rb` contains all the logic that reads the Google search HTML result.

`#parse` parses the HTML and adds all the paintings data into the resulting `artworks` hash that can be seen in `result.json`

`#write_to_file` writes the JSON result of the artworks hash that contains all the artwork data to `result.json`

## Testing

In `/spec` run `bundle exec rspec carousel_scraper_spec.rb` to test `carousel_scraper.rb`

Result:

<img width="612" alt="Screen Shot 2023-07-21 at 7 44 09 PM" src="https://github.com/kylelong/carousel-scraper/assets/6677487/160b35e0-23e6-4d99-887a-24a711e4c4ae">

