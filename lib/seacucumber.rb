require 'thread'
require 'webrick'

require 'rake'
require 'rake/tasklib'

# Load Custom Classes
Dir[File.join(File.dirname(__FILE__), 'seacucumber/**/*.rb')].sort.each { |lib| require lib }

module SeaCucumber

  class TestRunner < ::Rake::TaskLib

    # browsers to be tested
    @browsers = {
      :firefox => FirefoxBrowser.new,
      :ie => IEBrowser.new,
      :konqueror => KonquerorBrowser.new,
      :safari => SafariBrowser.new
    }

    # configurable options for this task
    @options = {
      :name => :test,
      :host => 'localhost',
      :port => 4711
    }

    # Make class instance variables accesible
    class << self; attr_accessor :options, :browsers; end

    def initialize(port=4611, &block)
      @name = options[:name]
      @host = options[:host]
      @port = port
      @tests = []
      @queue = Queue.new

      define(&block)
    end

    def define
      task @name do
        result = []

        # Starting the server...
        # NOTE: this must be within the task, otherwise the server will be started regardless of whether the task was called
        puts "Starting WEBrick server (listening on #{@port})..."
        @server = WEBrick::HTTPServer.new(:Port => @port)
        @server.mount_proc("/results") do |req, res|
          @queue.push(req.query['result'])
          res.body = "OK"
        end

        yield self if block_given?

        trap("INT") { @server.shutdown }
        thread = Thread.new { @server.start }

        # run all combinations of browsers and tests
        browsers.values.each do |browser|
          if browser.supported?
            browser.setup
            @tests.each do |test|
              test_url = "http://#{@host}:#{@port}/#{test}?resultsURL='http://#{@host}:#{@port}/results'"
              browser.visit(test_url)
              result = @queue.pop
              puts "Testing '#{test}' on #{browser}: #{result}"
            end
          else
            puts "Skipping #{browser}, not supported on this OS"
          end

          browser.teardown
        end

        @server.shutdown
        thread.join
      end
    end

    def mount(path, dir=nil)
      dir = Dir.pwd + path unless dir

      @server.mount(path, WEBrick::HTTPServlet::FileHandler, dir)
    end

    # test should be specified as a url
    def run(test)
      @tests << test
    end

    private

    def options
      self.class.options
    end

    def browsers
      self.class.browsers
    end

  end
end

#:enddoc:
# silence webrick
class ::WEBrick::HTTPServer
  def access_log(config, req, res)
    # nop
  end
end
class ::WEBrick::BasicLog
  def log(level, data)
    # nop
  end
end
