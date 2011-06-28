module Readmill
  class Book < Readmill::Model
    class << self
      def find(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/books/#{options[:id]}"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_params)
        
        self.new(JSON.parse(json), options)
      rescue RestClient::ResourceNotFound
        nil
      end
      
      def match(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/books/match"
        
        query = { }
        
        query['q[title]']   = options[:title]   if options[:title]
        query['q[author]']  = options[:author]  if options[:author]
        query['q[isbn]']    = options[:isbn]    if options[:isbn]
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_params.merge(query))
        
        self.new(JSON.parse(json), options)
      rescue RestClient::ResourceNotFound
        nil
      end
      
      def all(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/books"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_params)
        
        JSON.parse(json).map do |book|
          self.new(book, options)
        end
      rescue RestClient::ResourceNotFound
        nil # the Readmill API is acting weird, should not give a 404 for this method
      end
      
      def search(options)
        url = "#{Readmill.protocol}://#{options[:endpoint]}/books"
        
        json = RestClient.get(url, :accept => :json, :params => options[:token].public_params.merge('q' => options[:query]))
        
        JSON.parse(json).map do |book|
          self.new(book, options)
        end
      rescue RestClient::ResourceNotFound
        nil # the Readmill API is acting weird, should not give a 404 for this method
      end
      
      def create(options)
        if existing = self.match(options)
          existing
        else
          params = options[:token].private_params.merge('book' => {
            'author' => options[:author],
            'title'  => options[:title],
          })

          params['book']['isbn'] = options[:isbn] if options[:isbn]

          response = RestClient.post("#{Readmill.protocol}://#{options[:endpoint]}/books", params.to_json, :content_type => :json)

          if response.headers[:status] == '201'
            response.headers[:location] =~ /\/books\/([0-9]+)$/

            self.find(options.merge(:id => $1.to_i))
          else
            nil
          end
        end
      end
    end
    
    def root_edition_id; self[:root_edition_id]; end
    def root_edition; Book.find(self.root_edition_id); end
    
    def title; self[:title]; end
    def author; self[:author]; end
    def isbn; self[:isbn]; end
    def language; self[:language]; end
    def published_at; Time.parse(self[:published_at]); end
    def story; self[:story]; end
    
    def cover_url; self[:cover_url]; self[:cover_url]; end
    
    def assets; self[:assets]; end
    
    def uri; self[:uri]; end
    def permalink; self[:permalink]; end
    def permalink_url; self[:permalink_url]; end
    
    def add_reading(params)
      Readmill::Reading.create(self.options.merge(params).merge(:book_id => self.id))
    end
    
    def inspect
      "<#{self.class} '#{self.title}' by '#{self.author}' (#{self.id})>"
    end
  end
end