require 'thor'
require 'net/http'
require 'yaml'

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

  desc 'read_yml', 'Read YAML File'
  def read_yml
    parsed = begin
      conf = YAML::load_file(File.join(__dir__, '../config/auth.yml'))
      conf.each do |key, value|
        if (key == 'email')
          email_id = value
        end
      puts email_id
      end
     end
  end
end
