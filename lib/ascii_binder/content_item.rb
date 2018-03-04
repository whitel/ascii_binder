require 'ascii_binder/helpers'

include AsciiBinder::Helpers

module AsciiBinder
  class ContentItem
    attr_reader :id, :repo, :branch, :dir, :content_set, :content_subsets

    def initialize(content_set_map_filepath,content_item_name,content_item_config,content_set)
      puts "#{content_item_name} : #{content_item_config}"
      @id              = content_item_name
      @repo            = content_item_config['repo']
      @branch          = content_item_config['branch']
      @dir             = content_item_config['dir']
      @content_set     = content_set
      @content_subsets = {}

      if content_item_config.has_key?('content_set')
        content_subset_config = content_item_config['content_set']
        content_subset_key = content_subset_config['name']
        if content_subsets.has_key?(content_subset_key)
          Trollop::die "Error parsing '#{content_set_map_filepath}': content set #{content_set.id} contains subset #{content_subset_key} more than once."
        end

        content_subsets[content_subset_key] = AsciiBinder::ContentSet.new(content_set_map_filepath,content_subset_key,content_subset_config)
      end
      puts "printing self"
      p self
    end

    def is_valid?
      validate
      return true
    end

    def errors
      validate(true)
    end

    private

    def validate(verbose=true)
      errors = []
      unless valid_string?(@id)
        if verbose
          errors << "Content Item '#{@id}' is not a valid string."
        else
          return false
        end
      end
      unless valid_string?(@repo)
        if verbose
          errors << "Content Repo '#{@repo}' for Content Item '#{@id}' is not a valid string."
        else
          return false
        end
      end
      unless valid_string?(@branch)
        if verbose
          errors << "Branch '#{@branch}' for Content Item '#{@id}' is not a valid string."
        else
          return false
        end
      end
      return errors if verbose
      return true
    end
  end
end
