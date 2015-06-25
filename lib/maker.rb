require 'thor'
require 'net/http'
require 'yaml'
require 'json'
require_relative 'api_helper'

class Maker < Thor

	option :id
	desc 'create', 'Crates user, app or brand'
	def create(what)
		f = File.open(File.join(__dir__, "../config/#{what}.json"), 'r')
		conf = JSON.parse(f.read)
		conf['body']['id'] = options[:id] if options[:id] != nil
		resp = ApiHelper.post(conf['uri']+ conf['path'], conf['body'].to_json, conf['headers'])
		puts resp.code
		puts "#{resp.body}"
	end
end
