require 'openssl'

module ApiHelper
  class << self
    def get(path, headers)
      request(:get, path, '', headers)
    end

    def post(path, content, headers)
      request(:post, path, content, headers)
    end

    def post_without_payload(path)
      request(:post, path)
    end

    def delete(path, headers)
      request(:delete, path, '', headers)
    end

    def put(path, content)
      request(:put, path, content)
    end

    def request(verb, path, data = '', headers)
      url = URI.parse(path)
    #  binding.pry
      path = url.path
      http = Net::HTTP.new(url.host, url.port)

      if url.scheme == 'https'
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = true
      end

      case verb
      when :delete
        request = Net::HTTP::Delete.new(path)
      when :put
        request = Net::HTTP::Put.new(path)
        request.body = data
      when :post
        request = Net::HTTP::Post.new(path)
        request.body = data
      when :get
        request = Net::HTTP::Get.new(path)
      end

      request['Content-Type']  = 'application/json'
      request['Accept']        = 'application/json'

      if headers['request-type'] == 'basic'
        request.basic_auth(headers['client_id'], headers['auth_token'])
      else
        request['X-Auth-Client'] = headers['client_id']
        request['X-Auth-Token']  = headers['auth_token']
      end

      http.request(request)
    end

  end
end
