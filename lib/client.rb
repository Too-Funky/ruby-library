require 'net/https'
require 'uri'
require 'json'

class Client

	def get(url)
		uri = URI(url)
		begin
			response = Net::HTTP.get(uri)
		rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
			Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
			STDERR.puts "[error] HTTP error: #{e}"
		end
		@data = JSON.parse(response)
	end

	def post(url,data)
	uri = URI.parse(url)
	begin
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
		request.body = "[ #{data.to_json} ]"
		response = https.request(request)
	rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
		Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
		STDERR.puts "[error] HTTP error: #{e}"
	end
end

def delete(url,data)
	uri = URI.parse(url)
	begin
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		request = Net::HTTP::Delete.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
		request.body = "[ #{data.to_json} ]"
		response = https.request(request)
	rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
		Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
		STDERR.puts "[error] HTTP error: #{e}"
	end
end

end