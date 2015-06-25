require 'yaml'
require 'fileutils'

  class Maker
    class Configuration < Hash

      def initialize
        config = File.join(File.dirname(File.expand_path(__FILE__)), '../')
        File.join(config, "etc/hosts.yml")

        ::YAML.load_file(config).each do |key, val|
          self[key.to_sym] = val
        end
      end

    end
end
