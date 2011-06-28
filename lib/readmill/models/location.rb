module Readmill
  class Location < Readmill::Model
    class << self
      def find_by_reading_id(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/readings/#{options[:reading_id]}/locations"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_or_private_params)
        
        JSON.parse(json).map do |reading|
          self.new(reading, options)
        end
      rescue RestClient::ResourceNotFound
        # raise RuntimeError, "the Readmill API is acting weird, should not give a 404 for this method"
      end
    end
    
    def period_id
      self[:period_id]
    end
    
    def latitude
      self[:lat]
    end
    
    def longitude
      self[:lng]
    end
    
    def inspect
      "<#{self.class} #{self.latitude} #{self.longitude} (#{self.id})>"
    end
  end
end