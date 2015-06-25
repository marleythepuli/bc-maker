require 'yaml'

class Helper
  def self.read_yml
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
