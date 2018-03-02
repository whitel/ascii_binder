require 'ascii_binder/content_set'
require 'trollop'
require 'yaml'

module AsciiBinder
  class ContentSetMap
    def initialize(content_set_map_filepath,content_target_map_key,content_target_config)
      @id = content_target_map_key
      @content_set_map = {}
      content_target_config.each do |content_super_set_config|
        content_set_key = content_super_set_config['name']
        content_set_config = content_super_set_config['content_set']
        puts  "(ContentSetMap) target #{@id} content_key = #{content_set_key} : config = #{content_set_config}\n"
        if @content_set_map.has_key?(content_set_key)
          Trollop::die "Error parsing '#{content_set_map_filepath}': content set key '#{content_set_key}' is used more than once."
        end
        if content_set_config.nil?
          #this is a content item alone, let's make it look like a set
          puts  "(ContentSetMap) looks like an item: content_super_set_config = #{content_super_set_config}\n"
          content_set_config = [content_super_set_config]
        end
        @content_set_map[content_set_key] = AsciiBinder::ContentSet.new(
          content_set_map_filepath,content_set_key,content_set_config)
      end
    end

    def get_content_set(content_set_key)
      unless @content_set_map.has_key?(content_set_key)
        Trollop::die "Content Set key '#{content_set_key}' does not exist"
      end
      @content_set_map[content_set_key]
    end

    def include_content_set_key?(content_set_key)
      @content_set_map.has_key?(content_set_key)
    end

    def content_set_keys()
      @content_set_map.keys
    end

    def content_sets
      p @content_set_map
      @content_set_map.values
    end

    def is_valid?
      @content_set_map.values.each do |content_set|
        next if content_set.is_valid?
        return false
      end
      return true
    end

    def errors
      errors = []
      @content_set_map.values.each do |content_set|
        next if content_set.is_valid?
        errors << content_set.errors
      end
      return errors
    end
  end
end
