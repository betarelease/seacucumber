module SeaCucumber
  
  class FirefoxBrowser < Browser
    def initialize(path='c:\Program Files\Mozilla Firefox')
      @path = path
    end

    def visit(url)
      applescript('tell application "Firefox" to Get URL "' + url + '"') if macos?

      system("start /D \"#{@path}\" firefox.exe \"#{url}\"") if windows?

      system("firefox #{url}") if linux?
    end

    def to_s
      "Firefox"
    end
  end

end

