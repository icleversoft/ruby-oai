module OAI
  class Dc < REXML::Document
    def initialize( doc )
      doc = super.new(doc).root
      #Bypass first elemet
      doc.elements.first.each do |elm|
        p elm.name
      end
    end
  end
end
