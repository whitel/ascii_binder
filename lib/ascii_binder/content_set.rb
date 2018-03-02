require 'ascii_binder/content_item'
require 'ascii_binder/helpers'
require 'ascii_binder/site'
require 'trollop'

include AsciiBinder::Helpers

module AsciiBinder
  class ContentSet
    attr_reader :id, :content_set

    def initialize(content_set_map_filepath,content_set_key,content_set_config)
      @id           = content_set_key
      @content_set  = {}
      puts "content set: #{@id} \ncontent_set_config: #{content_set_config}"
      puts
      unless content_set_config.nil?
        content_set_config.each do |content_item_config|
          puts "content set: #{@id} content_item_config: #{content_item_config}"
          content_name = content_item_config['name']
          @content_set[content_name] = AsciiBinder::ContentItem.new(content_set_map_filepath,content_name,content_item_config,self)
        end
      end
    end

    def is_valid?
      validate
      return true
    end

    def errors
      validate(true)
    end

    def content(content_name)
      unless @content_set.has_key?(content_name)
        Trollop::die "Content set '#{@id}' does not include content item '#{content_name}' in the content set map."
      end
      @content_set[content_name]
    end

    def content_ids
      @content_set.keys
    end

    def content
      @content_set.values
    end

    private

    def validate(verbose=false)
      errors = []
      unless valid_id?(@id)
        if verbose
          errors << "Content Set ID '#{@id}' is not a valid string"
        else
          return false
        end
      end
    end
  end
end
