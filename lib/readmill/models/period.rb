module Readmill
  class Period < Readmill::Model
    class << self
      def find_by_reading_id(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/readings/#{options[:reading_id]}/periods"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_or_private_params)
        
        JSON.parse(json).map do |reading|
          self.new(reading, options)
        end
      rescue RestClient::ResourceNotFound
        # raise RuntimeError, "the Readmill API is acting weird, should not give a 404 for this method"
      end
    end
    
    def user_id
      self[:user_id]
    end
    
    def user
      Readmill::User.find(self.options.merge(:id => self.user_id))
    end
    
    def reading_id
      self[:reading_id]
    end
    
    def reading_id
      Readmill::Reading.find(self.options.merge(:id => self.reading_id))
    end
    
    def progress
      self[:progress]
    end
    
    def started_at
      Time.parse(self[:started_at])
    end
    
    def duration
      self[:duration]
    end
    
    def locations
      self[:locations].map do |location|
        Readmill::Location.new(location, self.options)
      end
    end
    
    def inspect
      "<#{self.class} (#{self.id})>"
    end
  end
end