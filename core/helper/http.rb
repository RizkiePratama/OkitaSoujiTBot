require 'net/https'

module TBot
  module Helper
    class HTTP
      def self.get(url, cred_user=nil, cred_pass=nil )
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri.request_uri)
        if !cred_user.nil?
          request.basic_auth(cred_user, cred_pass)
        end

        response = http.request(request)
        if response.kind_of?(Net::HTTPSuccess) && response.code == '200'
          return response.body
        else
          return false
        end
      end

      def self.post(url,type,req)
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(uri.path, 'Content-Type' => type)
        response = http.request(request)
        if response.kind_of?(Net::HTTPSuccess) && response.code == '200'
          return response.body
        else
          return false
        end
      end

    end
  end
end
