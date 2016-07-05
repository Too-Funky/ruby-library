require 'net/https'
require 'uri'
require 'json'

class GoSquared
	class Account
		
		BASEURL = "https://api.gosquared.com/account/"
		VERSION = %w(v1 v2 v3)
		DIMENSIONS = %w(blocked feeds report_preferences shared_users sites tagged_vistors trigger_types webhooks)
		@@filters = {presenter: @presenter, ip: @ip}

		def initialize(api_key="demo", site_token="GSN-2194840-F")
			@site_token = site_token
			@api_key = api_key
			@bots = ""
			@ips = ""
			@visitor = ""
		end

		VERSION.each do |version|
			define_method version do
				@version = version + "/"
				self
			end
		end

		DIMENSIONS.each do |dimension|
			define_method dimension do
				@dimension = dimension 
				self
			end
		end	

		@@filters.each do |key, value|
			define_method key do |argument|
				@@filters[key] = argument
				self
			end
		end

		def bots
			@bots = "/bots"
		end

		def address
			@ips = "/ips"
			self
		end

		def visitors(id="")
			@visitor = "/visitors/#{id}"
			self
		end

		def fetch
			build_url
			uri = URI(@url)
			begin
				response = Net::HTTP.get(uri)
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
				Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
				STDERR.puts "[error] HTTP error: #{e}"
			end
			@data = JSON.parse(response)
		end

		def post
			build_url
			puts @url
			uri = URI.parse(@url)
			begin
				https = Net::HTTP.new(uri.host, uri.port)
				https.use_ssl = true
				request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
				request.body = "[ #{@data.to_json} ]"
				response = https.request(request)
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
				Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
				STDERR.puts "[error] HTTP error: #{e}"
			end
		end

		def build_url
			array = [""]
			@url = BASEURL + @version + @dimension + @visitor + @bots + @ips +
			"?api_key=#{@api_key}" + "&site_token=#{@site_token}"
			@@filters.each {|key, value| array << "#{key}=#{value}" if value }
			parameters=array.join('&')
			@url = @url.concat(parameters)
		end

	end
end