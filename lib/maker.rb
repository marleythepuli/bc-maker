require 'thor'
require 'net/http'
require 'yaml'
require 'api_helper'

class Maker < Thor

  desc 'create_user', 'Create a user'
  method_option :email,    type: :string
  method_option :scopes,   type: :array
  method_option :is_owner, type: :boolean
  method_option :store_id, type: :string
  def create_user
    conf = YAML::load_file(File.join(__dir__, '../config/auth.yml'))
    puts "#{conf}"

    request = ApiHelper.post(conf['uri']+ conf['path'], conf['body'])
    puts "#{request}"


	end

end
