module SeaCucumber
  
  class IEBrowser < Browser
    def initialize(path='C:\Program Files\Internet Explorer\IEXPLORE.EXE')
      @path = path
    end

    def supported?
      windows?
    end

    def visit(url)
      system("start \"#{@path}\" \"#{url}\"") if windows?
    end
    
    def teardown
      system("TASKKILL /F /IM IEXPLORE.EXE")
    end

    def to_s
      "Internet Explorer"
    end
  end
  
end