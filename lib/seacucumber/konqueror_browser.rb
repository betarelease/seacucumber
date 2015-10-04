module SeaCucumber
  
  class KonquerorBrowser < Browser
    def supported?
      linux?
    end

    def visit(url)
      system("kfmclient openURL #{url}")
    end

    def to_s
      "Konqueror"
    end
  end
  
end

