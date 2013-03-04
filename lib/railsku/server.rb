require 'net/http'

module Railsku
  class Server
    def self.call(env)
      request = Rack::Request.new(env)
      uri = URI(request.url)
      uri.path = env['PATH_INFO']

      be = find_backend(uri.host)
      if be
        #puts "Backend found for #{uri.host} on port #{be.port}"
        uri.host = "127.0.0.1"
        uri.port = be.port

        forward_request = Net::HTTP.const_get(request_method(request)).new(uri.request_uri)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https' ? true : false
        forward_response = http.request(forward_request)

        headers = {}
        forward_response.each_header do |k,v|
          headers[k] = v unless k.to_s =~ /status/i
        end
        headers["Transfer-Encoding"] = "none"

        [forward_response.code.to_i, headers, [forward_response.body]]
      else
        [500, [["Content-Type", "text/html"]], ["Couldn't find backend for #{uri.host}"]]
      end
    end

  private

    def self.request_method(request)
      method = request.request_method.downcase
      method[0..0] = method[0..0].upcase

      method
    end
  end
end
