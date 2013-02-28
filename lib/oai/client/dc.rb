module OAI
  require 'rexml/document'
  class Dcelement
    attr_accessor :name, :value, :lang
    def initialize(elm)
      @name = elm.name
      @value = elm.children.first.to_s
      @lang = elm.attributes["lang"]
    end
  end
  class Dc 
    attr_accessor :elms
    def initialize( doc )
      @doc = REXML::Document.new(doc.to_s).root
      @elms = {} 
      #Bypass first element. Work only for dc elements
      unless @doc.elements.first.name.match(/dc/i).nil?
        @doc.elements.first.elements.each do |elm|
          m = @elms[elm.name]
          if m.nil?
            m = Dcelement.new(elm)
          else
            m = [m] << Dcelement.new(elm)
          end
          @elms[elm.name] = m 
        end
      end
    end
  end
end
