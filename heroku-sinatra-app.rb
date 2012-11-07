require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'redcarpet'

configure :production do
end

baseURL = "http://metrotransit.org/Mobile/Nextrip.aspx"

get '/' do
	options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
  readme = File.read("README.md").gsub("http://metrotransit.heroku.com", "http://" + request.host_with_port)
  renderer = Redcarpet::Render::HTML.new(:hard_wrap => true)
  md = Redcarpet::Markdown.new(renderer, :autolink => true, :no_intra_emphasis => true, :fenced_code_blocks => true)
  md.render(readme)
end

['/routes', '/Routes'].each do |path|
	get path do
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
end

['/directions', '/Directions'].each do |path|
	get path do
		content_type :json
		if params[:route].nil?
			return "{'error':'Please include the route parameter in your request'}"
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
		directions.to_json
	end
end

['/stops', '/Stops'].each do |path|
	get path do
		content_type :json
		if params[:route].nil? or params[:direction].nil?
			return "{'error':'Please include the route and direction parameters in your request'}"
		end
		doc = Nokogiri::HTML(open(baseURL + "?route=" + params[:route] + "&direction=" + params[:direction]))
		select = doc.xpath("//select[@id='ctl00_mainContent_NexTripControl1_ddlNexTripNode']").first
		options = select.search("option")
		stops = Array.new
		options.each do |option|
			unless option['value'].eql? "0"
				stop = Hash.new
				stop["key"] = option['value']
				stop["name"] = option.content
				stops << stop
			end
		end
		stops.to_json
	end
end

['/nexttrip', '/nextTrip', '/NextTrip'].each do |path|
	get path do
		content_type :json
		if ( params[:route].nil? or params[:direction].nil? or params[:stop].nil? ) and params[:stopnumber].nil?
			return "{'error':'Please include the route, direction, and stop parameters in your request'}"
		end
		if params[:stopnumber].nil?
			doc = Nokogiri::HTML(open(baseURL + "?route=" + params[:route] + "&direction=" + params[:direction] + "&stop=" + params[:stop]))
		else
			doc = Nokogiri::HTML(open(baseURL + "?stopnumber=" + params[:stopnumber]))
		end
		div = doc.xpath("//div[@id='ctl00_mainContent_NexTripControl1_NexTripResults1_departures']").first
		stop_name = doc.css('span.black10').last.content
		nexttrips = Array.new
		div.search("div").each do |row|
			spans = row.css('span')
			nexttrips << {:number => spans.first.content, :time => spans.last.content, :stop_name => stop_name}
		end
		nexttrips.to_json
	end
end
