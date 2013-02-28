module OAI
  require 'rexml/document'
  class Dc 
    attr_accessor :doc, :elms
    def initialize( doc )
      @doc = REXML::Document.new(doc.to_s).root
      @elms = []
      #Bypass first elemet
      @doc.elements.first.each do |elm|
        @elms << elm  
      end
    end
  end
end
