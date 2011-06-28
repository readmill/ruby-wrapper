module Readmill
  class AnonymousToken
    def initialize(id)
      @id = id
    end
    
    def public_params
      { :client_id => @id }
    end
    
    def public_or_private_params
      self.public_params
    end
    
    def private_params
      return nil
    end
    
    def inspect
      "<#{self.class} '#{@id}'>"
    end
  end
end