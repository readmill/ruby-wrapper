module Readmill
  class Reading < Readmill::Model
    class << self
      def find(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/readings/#{options[:id]}"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_or_private_params)
        
        self.new(JSON.parse(json), options)
      rescue RestClient::ResourceNotFound
        nil
      end
      
      def all(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/readings"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_or_private_params)
        
        JSON.parse(json).map do |reading|
          self.new(reading, options)
        end
      rescue RestClient::ResourceNotFound
        # raise RuntimeError, "the Readmill API is acting weird, should not give a 404 for this method"
      end
      
      def by_user_id(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/users/#{options[:user_id]}/readings"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_or_private_params)
        
        JSON.parse(json).map do |reading|
          self.new(reading, options)
        end
      rescue RestClient::ResourceNotFound
        # raise RuntimeError, "the Readmill API is acting weird, should not give a 404 for this method"
      end
      
      def create(options)
        params = options[:token].private_params.merge('reading' => {
          'state' => { :interesting => 1, :open => 2, :finished => 3, :abandoned => 4 }[options[:state]],
          'is_private'  => options[:private],
        })

        response = RestClient.post("#{Readmill.protocol}://#{options[:endpoint]}/books/#{options[:book_id]}/readings", params.to_json, :content_type => :json)

        if response.headers[:status] == '201'
          response.headers[:location] =~ /\/readings\/([0-9]+)$/

          self.find(options.merge(:id => $1.to_i))
        else
          nil
        end
      end
    end
    
    def periods
      Readmill::Period.find_by_reading_id(self.options.merge(:reading_id => self.id))
    end
    
    def locations
      Readmill::Location.find_by_reading_id(self.options.merge(:reading_id => self.id))
    end
    
    def ping(options)
      params = self.options[:token].private_params.merge('ping' => {
        'identifier' => options[:identifier],
        'progress' => options[:progress]
      })
      
      params['ping']['duration'] = options[:duration] if options[:duration]
      params['ping']['occured_at'] = options[:occured_at] if options[:occured_at]
      
      params['ping']['lat'] = options[:latitude] if options[:latitude]
      params['ping']['lng'] = options[:longitude] if options[:longitude]
      
      response = RestClient.post("#{Readmill.protocol}://#{self.options[:endpoint]}/readings/#{self.id}/pings", params.to_json, :content_type => :json)
      
      response.headers[:status] == '201'
    end
    
    def save
      params = self.options[:token].private_params.merge('reading' => {
        'state' => { :interesting => 1, :open => 2, :finished => 3, :abandoned => 4 }[self.state],
        'is_private'  => self.private?,
      })
      
      params['reading']['closing_remark'] = self.closing_remark if self.closing_remark
      
      response = RestClient.put("#{Readmill.protocol}://#{self.options[:endpoint]}/readings/#{self.id}", params.to_json, :content_type => :json)
      
      response.headers[:status] == '200'
    end
    
    def state
      case @state || self[:state]
      when 1
        :interesting
      when 2
        :open
      when 3
        :finished
      when 4
        :abandoned
      else
        nil
      end
    end
    
    def state=(value)
      @state = {
        :interesting  => 1,
        :open         => 2,
        :finished     => 3,
        :abandoned    => 4
      }[value]
    end
    
    def private?
      @private || self[:private]
    end
    
    def private=(value)
      @private = value
    end
    
    def closing_remark
      @closing_remark || self[:closing_remark]
    end
    
    def closing_remark=(value)
      @closing_remark = value
    end
    
    def created_at; Time.parse(self[:created_at]); end
    def started_at; Time.parse(self[:started_at]); end
    def touched_at; Time.parse(self[:touched_at]); end
    def finished_at; Time.parse(self[:finished_at]); end
    def abandoned_at; Time.parse(self[:abandoned_at]); end
    
    def book; Readmill::Book.new(self[:book], self.options); end
    def user; Readmill::User.new(self[:user], self.options); end
    
    def duration; self[:duration]; end
    def progress; self[:progress]; end
    def estimated_time_left; self[:estimated_time_left]; end
    def average_period_time; self[:average_period_time]; end
    
    def inspect
      "<#{self.class} '#{self.user.name}' reading '#{self.book.title}' (#{self.id})>"
    end
  end
end
