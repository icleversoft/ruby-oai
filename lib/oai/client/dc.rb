module OAI
  require 'rexml/document'
  class Dcelement
    attr_accessor :name, :value, :lang
    attr_reader :fields
    def initialize(elm)
      @name = elm.name
      @value = elm.children.first.to_s
      @lang = elm.attributes["lang"]
    end
  end
  class Dc 
    def initialize( doc )
      @doc = REXML::Document.new(doc.to_s).root
      @elms = {} 
      return if @doc.nil?
      #Bypass first element. Work only for dc elements
      unless @doc.elements.first.name.match(/dc/i).nil?
        @doc.elements.first.elements.each do |elm|
          unless elm.children.first.to_s.strip.empty?
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
        end
        build_attributes
      end
    end

    def fields
      @elms.keys
    end

    private

    def create_method( name, &block )
      self.class.send( :define_method, name, &block )
    end

    def build_attributes
      #Define dynamic methods
      @elms.each do |name, value|
        create_method("#{name}=".to_sym) do |val|
          instance_variable_set("@" + name, val)
        end
        create_method( name.to_sym ) do
          instance_variable_get("@" + name)
        end
        self.instance_variable_set("@" + name, value)
      end
    end
  end
end
