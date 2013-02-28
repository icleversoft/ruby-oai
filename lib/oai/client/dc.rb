module OAI
  class Dc < REXML::Document
    def initialize( doc )
      super.new(doc).root
    end
  end
end
