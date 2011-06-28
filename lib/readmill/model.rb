require 'restclient'

module Readmill
  class Model
    def initialize(contents, options)
      @contents, @options = contents, options
    end
    
    def [] (key)
      @contents[key.to_s]
    end
    
    def id
      self[:id].to_i
    end
    
    def options
      @options
    end
    
    def to_hash
      @contents
    end
  end
end