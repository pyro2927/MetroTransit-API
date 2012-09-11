require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'

configure :production do
end

baseURL = "http://metrotransit.org/Mobile/Nextrip.aspx"

get '/' do
  "Congradulations!
   You're running a Sinatra application on Heroku!"
end

get '/routes' do
	doc = Nokogiri::HTML(open(baseURL))
	select = doc.xpath("//select[@id='ctl00_mainContent_NexTripControl1_ddlNexTripRoute']").first
	options = select.search("option")
	routes = Hash.new
	options.each do |option|
		unless option['value'].eql? "0"
			routes[option['value']] = option.content
		end
	end
	content_type :json
	routes.to_json
end

get '/directions' do
	if params[:route].nil?
		"{'error':'Please include the route parameter in your request'}";
		return
	end
	doc = Nokogiri::HTML(open(baseURL + "?route=" + params[:route]))
	select = doc.xpath("//select[@id='ctl00_mainContent_NexTripControl1_ddlNexTripDirection']").first
	options = select.search("option")
	directions = Hash.new
	options.each do |option|
		unless option['value'].eql? "0"
			directions[option['value']] = option.content
		end
	end
	content_type :json
	directions.to_json
end

get '/stops' do
	doc = Nokogiri::HTML(open(baseURL + "?route=" + params[:route] + "&direction=" + params[:direction]))
	select = doc.xpath("//select[@id='ctl00_mainContent_NexTripControl1_ddlNexTripNode']").first
	options = select.search("option")
	stops = Hash.new
	options.each do |option|
		unless option['value'].eql? "0"
			stops[option['value']] = option.content
		end
	end
	content_type :json
	stops.to_json
end

['/nexttrip', '/nextTrip'].each do |path|
	get path do
		doc = Nokogiri::HTML(open(baseURL + "?route=" + params[:route] + "&direction=" + params[:direction] + "&stop=" + params[:stop]))
		div = doc.xpath("//div[@id='ctl00_mainContent_NexTripControl1_NexTripResults1_departures']").first
		nexttrips = Array.new
		div.search("div").each do |row|
			spans = row.css('span')
			nexttrips << {:number => spans.first.content, :time => spans.last.content}
		end
		content_type :json
		nexttrips.to_json
	end
end
