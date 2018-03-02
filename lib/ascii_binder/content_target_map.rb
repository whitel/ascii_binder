require 'ascii_binder/content_set'
require 'trollop'
require 'yaml'

module AsciiBinder
  class ContentTargetMap
    def initialize(content_target_map_filepath)
      @content_target_map_yaml = YAML.load_file(content_target_map_filepath)
      @content_target_map  = {}
      @content_target_map_yaml.each do |content_target_key,content_target_config|
        if @content_target_map.has_key?(content_target_key)
          Trollop::die "Error parsing '#{content_target_map_filepath}': content target key '#{content_target_key}' is used more than once."
        end
        puts "target: #{content_target_key}: #{content_target_config}"
        @content_target_map[content_target_key] = AsciiBinder::ContentSetMap.new(content_target_map_filepath,content_target_key,content_target_config)
      end
    end

    def get_content_target(content_target_key)
      unless @content_target_map.has_key?(content_target_key)
        Trollop::die "Content Target key '#{content_target_key}' does not exist"
      end
      @content_target_map[content_target_key]
    end

    def include_target_key?(content_target_key)
      @content_target_map.has_key?(content_target_key)
    end

    def content_target_keys
      @content_target_map.keys
    end

    def content_targets
      @content_target_map.values
    end

    def is_valid?
      @content_target_map.values.each do |content_target_map|
        next if content_target_map.is_valid?
        return false
      end
      return true
    end

    def errors
      errors = []
      @content_target_map.values.each do |content_target_map|
        next if content_target_map.is_valid?
        errors << content_target_map.errors
      end
      return errors
    end
  end
end
