require File.dirname(__FILE__) + '/spec_helper'

describe SeaCucumber::IEBrowser do

  it "visit(url) should make correct system call" do
    ie = SeaCucumber::IEBrowser.new
    ie.should_receive(:windows?).and_return(true)
    ie.should_receive(:system).with(%{start "C:\\Program Files\\Internet Explorer\\IEXPLORE.EXE" "my url"})

    ie.visit("my url")
  end

  it "teardown should make correct system call" do
    ie = SeaCucumber::IEBrowser.new
    ie.should_receive(:system).with(%{TASKKILL /F /IM IEXPLORE.EXE})

    ie.teardown
  end

end