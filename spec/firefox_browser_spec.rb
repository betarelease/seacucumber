require File.dirname(__FILE__) + '/spec_helper'

describe SeaCucumber::FirefoxBrowser do

  it "visit(url) should be specific depending on host OS" do
    firefox = SeaCucumber::FirefoxBrowser.new

    # OSX
    firefox.stub!(:macos?).and_return(true)
    firefox.stub!(:windows?).and_return(false)
    firefox.stub!(:linux?).and_return(false)
    firefox.should_receive(:applescript).with("tell application \"Firefox\" to Get URL \"osx_url\"")
    firefox.visit("osx_url")

    # Windows
    firefox.stub!(:windows?).and_return(true)
    firefox.stub!(:macos?).and_return(false)
    firefox.stub!(:linux?).and_return(false)
    firefox.should_receive(:system).with("start /D \"c:\\Program Files\\Mozilla Firefox\" firefox.exe \"windows_url\"")
    firefox.visit("windows_url")

    # Linux
    firefox.stub!(:linux?).and_return(true)
    firefox.stub!(:windows?).and_return(false)
    firefox.stub!(:macos?).and_return(false)
    firefox.should_receive(:system).with("firefox linux_url")
    firefox.visit("linux_url")
  end

end