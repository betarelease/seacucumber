require File.expand_path(File.dirname(__FILE__) + '/../lib/seacucumber.rb')
# require 'seacucumber'
namespace :js do

  desc "Run and collect results for all JavaScript unit tests"
  ::SeaCucumber::TestRunner.new(4711) do |task|
    
    task.mount("/", ".")
    task.mount("/js", "js")
    task.mount("/css", "css")

    # Find all tests and run them
    FileList["test/*_test.html"].each do |file|
      task.run(file)
    end
    
  end

end

namespace :screw_unit do

  desc "Run and collect results for all JavaScript unit tests"
  ::SeaCucumber::TestRunner.new(4711) do |task|

    task.mount("/", ".")    

    # Find all tests and run them
    FileList["screw-unit/spec/*.html"].each do |file|
      task.run(file)
    end
    
  end

end