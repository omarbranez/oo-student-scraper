require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_html = Nokogiri::HTML(open(index_url))
    students = [] #wants to be returned as an array of hashes
    index_html.css("div.roster-cards-container").each do |profile|
      profile.css(".student-card a").each do |student|
        students << students_hash = {
          :name => student.css(".student-name").text,
          :location => student.css(".student-location").text,
          :profile_url => "#{student.attr("href")}"
        }       
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_html = Nokogiri::HTML(open(profile_url))
    socials = {}
    #profile_html.css("div.vitals-container").each do |pro_links|
      #profile_html.css(".social-icon-container").each do |soc_links|
      
      # socials = {
      #   :twitter => soc_links.css('@href:contains("twitter")').text,
      #   :linkedin => soc_links.css('@href:contains("linkedin")').text,
      #   :github => soc_links.css('@href:contains("github")').text,
      #   #:blog => soc_links.css('@href:not(.twitter)').text guess i'm no good at css yet
      # }
      blog_links = profile_html.css(".social-icon-container").children.css("a").map {|bl| bl.attribute('href').value}
      blog_links.each do |link|  
        if link.include?("twitter")
          socials[:twitter] = link
        elsif link.include?("linkedin")
          socials[:linkedin] = link
        elsif link.include?("github")
          socials[:github] = link
        else
          socials[:blog] = link
        end
      end
    socials[:profile_quote] = profile_html.css('.profile-quote').text
    socials[:bio] = profile_html.css('.description-holder p').text        
    socials.compact
  end

end

