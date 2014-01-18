require 'rspec/core/rake_task'
require 'fileutils'
require 'rubygems'

desc 'Default: run specs.'
RSpec::Core::RakeTask.new :spec => [:build_ruby_math_3d] do |t|
  t.pattern = FileList["**/spec/*_spec.rb"]
  #.exclude('spec/lol_model_spec.rb', 'spec/md2_model_spec.rb')
end

desc 'build ruby-math-3d native extension'
task :build_ruby_math_3d do |t|
  # vendor / ruby-math-3d
  Dir.chdir('vendor') do
    Dir.chdir('ruby-math-3d') do
      puts Dir.pwd
      FileUtils.rm(File.expand_path('./Makefile', Dir.pwd), :force => true)   # never raises exception
      system "#{Gem.ruby} #{File.expand_path('./extconf.rb', Dir.pwd)}"
      #puts IO.read(File.expand_path('./Makefile', Dir.pwd))
      system 'make'
    end
  end
end

task :default  => :spec
