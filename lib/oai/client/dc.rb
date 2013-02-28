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
            if m.is_a?(Array)
              m << Dcelement.new(elm)
            else
              m = [m, Dcelement.new(elm)]
            end
          end
          @elms[elm.name] = m 
        end
        build_attributes
      end
    end
    private

    def create_method( name, &block )
      self.class.send( :define_method, name, &block )
    end

    def build_attributes
      #Define dynamic methods
      create_method("#{name}=".to_sym) do |val|
        instance_variable_set("@" + name, value)
      end
      create_method( name.to_sym ) do
        instance_variable_get("@" + name)
      end
      @elms.each do |name, value|
        self.instance_variable_set("@" + name, value)
      end
    end
  end
end
