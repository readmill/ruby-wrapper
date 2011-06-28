module Readmill
  class User < Readmill::Model
    class << self
      def current(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/me"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].private_params)
        
        self.new(JSON.parse(json), options)
      end
      
      def find(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/users/#{options[:id]}"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_params)
        
        self.new(JSON.parse(json), options)
      rescue RestClient::ResourceNotFound
        nil
      end
    end
    
    def readings
      Readmill::Reading.by_user_id(self.options.merge(:user_id => self.id))
    end
    
    def name; self[:fullname]; end
    def username; self[:username]; end
    
    def first_name; self[:first_name]; end
    def last_name; self[:last_name]; end
    
    def country; self[:country]; end
    def city; self[:city]; end
    def website_url; self[:website]; end
    def avatar_url; self[:avatar_url]; end
    
    def description; self[:description]; end
    
    def interesting_book_count; self[:books_interesting].to_i; end
    def open_book_count; self[:books_open].to_i; end
    def finished_book_count; self[:books_finished].to_i; end
    def abandoned_book_count; self[:books_abandoned].to_i; end
    
    def follower_count; self[:followers].to_i; end
    def following_count; self[:following].to_i; end
    
    def uri; self[:uri]; end
    def permalink_url; self[:permalink_url]; end
    
    def inspect
      "<#{self.class} '#{self.username}' (#{self.id})>"
    end
  end
end