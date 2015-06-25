require 'thor'
require 'net/http'

class Maker < Thor
  desc 'create', 'Create a user'
	method_option :email, type: :string
	def create_user
    uri = "https://login.bcservices.dev/users"
		body = { email: "test" }
    headers = { "X-Auth-Client" => "test",
			          "Auth-Token" => "1234",
		            "Content-Type" => "application/json" }


    request = Net::HTTP.post.new(uri)
		re
	end
end
