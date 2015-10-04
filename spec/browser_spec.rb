require File.dirname(__FILE__) + '/spec_helper'

describe SeaCucumber::Browser do

  it "should be able to determine OS" do
    browser = SeaCucumber::Browser.new

    browser.stub!(:host).and_return("fake")
    browser.macos?.should == false
    browser.windows?.should == false
    browser.linux?.should == false

    browser.stub!(:host).and_return("i686-apple-darwin8.9.1")
    browser.macos?.should == true

    browser.stub!(:host).and_return("xxx_mswin_xxx1")
    browser.windows?.should == true

    browser.stub!(:host).and_return("xxx_linux_xxx1")
    browser.linux?.should == true
  end

end