require 'thor'
require 'net/http'
require 'yaml'
require 'json'
require_relative 'api_helper'

class Maker < Thor


	@@logo =
'
	==============================================================
	 ___
	|   \
	|    \
	|____|
	|    /
	|___/ I G commerce - API Loader

	Method:		%s
	Endpoint:	%s
	==============================================================
	'

	option :id

	# ============================================================ #
	desc 'create', 'CREATE user, app or brand from jason config'
	def create(what)
		f = File.open(File.join(__dir__, "../config/#{what}.json"), 'r')
		conf = JSON.parse(f.read)
		conf['body']['id'] = options[:id] if options[:id] != nil
		resp = ApiHelper.post(conf['uri']+ conf['path'], conf['body'].to_json, conf['headers'])

		print_logo('CREATE', conf['path'])
		puts "\t#{resp.body}"
		puts
	end

	# ============================================================ #
	desc 'create_all', 'CREATE all user, app or brand from jason config'
	def create_all(what)
		f = File.open(File.join(__dir__, "../config/#{what}.json"), 'r')
		conf = JSON.parse(f.read)
		body = conf['body']

		print_logo('CREATE', conf['path'])
		body.each do |key, val|
			resp = ApiHelper.post(conf['uri']+ conf['path'], val.to_json, conf['headers'])
			puts "\tAdding #{key}:\t#{resp.body}"
		end
		puts
	end

	# ============================================================ #
	desc 'get_all', 'GET all user, app or brand'
	def get_all(what, disp_headers=[])
		f = File.open(File.join(__dir__, "../config/#{what}.json"), 'r')
		conf = JSON.parse(f.read)
		path = "#{conf['uri']}#{conf['path']}"
		resp = ApiHelper.get(path, conf['headers'])
		resp_code = resp.code
		resp = JSON.parse(resp.body)

		print_logo('GET', conf['path'])

		if resp_code == 200.to_s
			lst_disp_headers = get_keys(resp[0], disp_headers)
			print_disp_headers(lst_disp_headers)
			print_result(resp, lst_disp_headers)
			puts
		else
			puts "\t" + resp.to_s
			puts
		end
	end

	# ============================================================ #
	desc 'get_id', 'GET user, app or brand by id'
	def get_id(what, id, disp_headers=[])
		f = File.open(File.join(__dir__, "../config/#{what}.json"), 'r')
		conf = JSON.parse(f.read)
		path = "#{conf['uri']}#{conf['path']}/#{id}"
		resp = ApiHelper.get(path, conf['headers'])
		resp_code = resp.code
		resp = JSON.parse(resp.body)

		print_logo('GET', conf['path'])

		if resp_code == 200.to_s
			lst_disp_headers = get_keys(resp, disp_headers)
			print_disp_headers(lst_disp_headers)
			print_result([resp], lst_disp_headers)
			puts
		else
			puts "\t" + resp.to_s
			puts
		end
	end

	# ============================================================ #
	desc 'get_id_raw', 'GET user, app or brand by id and display raw'
	def get_id_raw(what, id)
		f = File.open(File.join(__dir__, "../config/#{what}.json"), 'r')
		conf = JSON.parse(f.read)
		path = "#{conf['uri']}#{conf['path']}/#{id}"
		resp = ApiHelper.get(path, conf['headers'])
		resp = JSON.parse(resp.body)

		print_logo('GET', conf['path'])

		resp.each do |key, value|
		 	puts "\t#{key}:\t#{value}"
			end
		puts
	end

	# ============================================================ #
	desc 'delete_id', 'DELETE user, app or brand by id'
	def delete_id(what, id)
		f = File.open(File.join(__dir__, "../config/#{what}.json"), 'r')
		conf = JSON.parse(f.read)
		path = "#{conf['uri']}#{conf['path']}/#{id}"
		resp = ApiHelper.delete(path, conf['headers'])

		print_logo('DELETE', conf['path'])
		puts "\t#{resp.body}"
	end


	# ============================================================ #
	no_commands{

		@@hash_header_str_ct = {'id'=> 8, 'name'=>65, 'status'=>50}

		# -------------------------------------------------- #
		def print_log(string_log, color='black')
			color = color.downcase
			if color == 'red'
				puts "\e\[31m#{string_log}\e[0m"
			elsif color == 'green'
				puts "\e\[32m#{string_log}\e[0m"
			else
				puts "\e\[30m#{string_log}\e[0m"
			end
		end

		# -------------------------------------------------- #
		def print_logo(method, path)
			print_log(@@logo%[method,path], 'green')
		end

		# -------------------------------------------------- #
		def print_result(raw_data, disp_keys)
			raw_data.each do |item|
				 print "\t\s"
				 disp_keys.each do |key|
					 print "|" + item[key].to_s
					 desired_len = @@hash_header_str_ct[key] if @@hash_header_str_ct[key]
					 desired_len = 50 if not @@hash_header_str_ct[key]
					 actual_len = item[key].to_s.length
					 append_len = desired_len - actual_len
					 append_len.times do print ' ' end
				 end
				 print "|"
				 puts
			end
			print "\t\s\s"
			disp_keys.each do |header|
				desired_len = @@hash_header_str_ct[header] if @@hash_header_str_ct[header]
				desired_len = 50 if not @@hash_header_str_ct[header]
				desired_len.times do print '-' end
			end
			puts
		end

		# -------------------------------------------------- #
		def print_disp_headers(list_headers)
			print "\t\s\s"
			list_headers.each do |header|
				desired_len = @@hash_header_str_ct[header] if @@hash_header_str_ct[header]
				desired_len = 50 if not @@hash_header_str_ct[header]
				desired_len.times do print "\e\[31m-\e[0m" end
			end
			puts

			print "\t "
			list_headers.each do |header|
				print "\e\[31m|\e[0m" + "\e\[31m#{header}\e[0m"
				desired_len = @@hash_header_str_ct[header] if @@hash_header_str_ct[header]
				desired_len = 50 if not @@hash_header_str_ct[header]
				append_len = desired_len - header.length
				append_len.times do print ' ' end
			end
			print "\e\[31m|\e[0m"
			puts

			print "\t\s\s"
			list_headers.each do |header|
				desired_len = @@hash_header_str_ct[header] if @@hash_header_str_ct[header]
				desired_len = 50 if not @@hash_header_str_ct[header]
				desired_len.times do print "\e\[31m-\e[0m" end
			end
			puts
		end

		# -------------------------------------------------- #
		def print_nice()

		end

		# -------------------------------------------------- #
		def print_raw()

		end

		# -------------------------------------------------- #
		def get_keys(raw_data, keys_wanted=[])
			list_keys = []
			keys_wanted = ['id', 'name', 'status'] if keys_wanted == []

			raw_data.each do |key, val|
				list_keys << key.to_s if keys_wanted.include? key.to_s
			end

			return list_keys
		end
	}
end
