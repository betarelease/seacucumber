require File.dirname(__FILE__) + '/spec_helper'

describe SeaCucumber::TestRunner do

  it "should handle all browsers" do
    browsers = SeaCucumber::TestRunner.browsers

    browsers.length.should == 4
    browsers[:firefox].class.should == SeaCucumber::FirefoxBrowser
    browsers[:ie].class.should ==  SeaCucumber::IEBrowser
    browsers[:konqueror].class.should ==  SeaCucumber::KonquerorBrowser
    browsers[:safari].class.should ==  SeaCucumber::SafariBrowser
  end

  it "should initialize WEBrick server and exexute all browsers" do
    SeaCucumber::TestRunner.browsers.clear

    # Adding two tests to be run
    runner = SeaCucumber::TestRunner.new do |t|
      t.run("test_one")
      t.run("test_two")
    end

    runner.instance_variable_get(:@queue) << "result for test one"
    runner.instance_variable_get(:@queue) << "result for test two"

    Time.stub!(:now).and_return(99)

    # Supported browser
    supported = mock('supported browser')
    supported.should_receive(:supported?).and_return(true)
    supported.should_receive(:setup)
    supported.should_receive(:visit).with("http://localhost:4711/test_one?resultsURL=http://localhost:4711/results&t=99.000000")
    supported.should_receive(:visit).with("http://localhost:4711/test_two?resultsURL=http://localhost:4711/results&t=99.000000")
    supported.should_receive(:teardown)

    # Unsupported browser
    unsupported = mock('unsupported browser')
    unsupported.should_receive(:supported?).and_return(false)
    unsupported.should_receive(:teardown)

    SeaCucumber::TestRunner.browsers[:supported] = supported
    SeaCucumber::TestRunner.browsers[:unsupported] = unsupported

    webrick = mock('webrick server')
    webrick.should_receive(:mount_proc).with('/results')
    webrick.should_receive(:start)
    webrick.should_receive(:shutdown)

    WEBrick::HTTPServer.should_receive(:new).with(:Port => 4711).and_return(webrick)

    # Assert output messages
    runner.should_receive(:puts).with("Starting WEBrick server (listening on 4711)...")
    runner.should_receive(:puts).with(%r{^Testing 'test_one' on #{supported}: result for test one})
    runner.should_receive(:puts).with(%r{^Testing 'test_two' on #{supported}: result for test two})
    runner.should_receive(:puts).with(%r{Skipping #{unsupported}, not supported on this OS})

    Rake::Task[:test].invoke
  end

  it "should provide default values for name, host and port" do
    runner = SeaCucumber::TestRunner.new

    runner.instance_variable_get(:@name).should == :test
    runner.instance_variable_get(:@host).should == 'localhost'
    runner.instance_variable_get(:@port).should == 4711
  end

  # This test needs to be run last because it changes the values for the class instance variables
  it "should be able to override default options" do
    SeaCucumber::TestRunner.options[:name] = :foobar
    SeaCucumber::TestRunner.options[:host] = 'www.thoughtworks.com'
    SeaCucumber::TestRunner.options[:port] = 8080

    runner = SeaCucumber::TestRunner.new

    runner.instance_variable_get(:@name).should == :foobar
    runner.instance_variable_get(:@host).should == 'www.thoughtworks.com'
    runner.instance_variable_get(:@port).should == 8080
  end

end


