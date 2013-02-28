module OAI
  require 'rexml/document'
  class Dc 
    def initialize( doc )
      doc = RECML::Document.new(doc).root
      #Bypass first elemet
      doc.elements.first.each do |elm|
        p elm.name
      end
    end
  end
end
