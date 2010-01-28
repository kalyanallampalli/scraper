require 'rubygems'
require 'feed_tools'
require 'open-uri'
require 'feedbag'
require 'nokogiri'
require 'thread'

class ScraperController < ApplicationController
  
  attr_accessor :feeds
  def index
	url = "http://anand.biz"	
	#url = "http://kalyan-4-ever.blogspot.com/"
	#url = "http://everything.typepad.com/"
	#url = "http://sethgodin.typepad.com/"
	#url = "http://www.camajorityreport.com/"
	#url = "http://carolineoncrack.com/"
	#url = "http://goldenblogs.blogsome.com/"
	#url = "http://www.sacatomato.com/"
	#url = "http://catsofruatha.blogspot.com/"
	#url = "http://sexscandals1.blogspot.com/"
	#url = "http://4uall2.blogspot.com/"
	#url = "http://cantspellathing.blogspot.com/"
	#url = "http://blog.vimukti.com/"	
	
	
	@mutex = Mutex.new
	@feeds = Feedbag.find url
	@items = scrape
  end
  
  def scrape
	items = []
	threads = []
	@feeds.each do |feed|
		begin		
		rss = FeedTools::Feed.open(feed)
		rss.items.each do |item|
		threads <<	Thread.new do
				@mutex.synchronize{
				items << item.title
				items << item.link
				items << find_html(item)					
				}
			end	
		end if rss != nil
		rescue Exception => e
			puts e.message
		end
		threads.each { |t| t.join }
	end
	return items
  end
  
  def find_html(item)
	doc = Nokogiri::HTML(open(item.link))
	blog_data = doc_starts_with(doc, item)
	if blog_data.nil? || blog_data == 0
		return doc_test_end(doc, item)
	else	
		return blog_data
	end	
  end 
  
  def doc_test_end(doc, item)
	doc.xpath("//div").each do |t|
	  content = t.inner_html.strip!
	  begin			
		if !item.description.ends_with?("[...]")
			return item.description
		elsif match_html?(content, item.description.scan(/.{25}/)[0])
			return t.content.strip!.gsub(/\s+/, " ")					 
		end		
	  rescue Exception => e
		puts e.message
	  end if content != nil
	end  
  end
  
  def doc_starts_with(doc, item)
	doc.xpath("//div").each do |t|
	  content = t.content.strip!
	  begin	
		return content.gsub(/\s+/, " ") if startsWith? content, item.description.scan(/.{25}/)[0]
	  rescue Exception => e
		puts e.message
	  end if content != nil
	end
  end
  
  def match_html?(content, desc)
	i = 1;
	content.each_line do |line|
		return line.match(desc) if i == 3
		i+=1
	end if content != nil
  end
  
  def startsWith?(content, desc)
  	cont = content[0...desc.length]  			
  	cont.eql? desc
  end
  
end
