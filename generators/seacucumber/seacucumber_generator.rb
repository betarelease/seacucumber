class SeacucumberGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory File.join('test/javascripts')
      m.directory File.join('public/javascripts')      
      
      m.file 'unittest.js', File.join("test", "javascripts", "unittest.js")
      m.file 'test.css', File.join("test", "javascripts", "test.css")

      m.template 'javascript_template.js', File.join("public", "javascripts", "#{file_name}.js")
      m.template 'seacucumber_template.html', File.join("test", "javascripts", "#{file_name}_test.html")
    end
  end
end
