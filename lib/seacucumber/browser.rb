require 'rbconfig'

module SeaCucumber
  
  class Browser
    def supported?
      true
    end
    
    def setup
      puts self.class.to_s
    end
    
    def open(url);  end
    
    def teardown; end

    def host
      Config::CONFIG['host_os']
    end

    def macos?
      host.include?('darwin')
    end

    def windows?
      host.include?('mswin')
    end

    def linux?
      host.include?('linux')
    end

    def applescript(script)
      raise "Can't run AppleScript on #{host}" unless macos?
      system "osascript -e '#{script}' 2>&1 >/dev/null"
    end
  end
  
end

