require 'rspec/core/rake_task'

desc 'Default: run specs.'
RSpec::Core::RakeTask.new :spec => :build_ruby_math_3d do |t|
  t.pattern = FileList["**/spec/*_spec.rb"]
  #.exclude('spec/lol_model_spec.rb', 'spec/md2_model_spec.rb')
end

task :build_ruby_math_3d do |t|
  # vendor / ruby-math-3d
  pid = Process.fork do
    Dir.chdir('vendor') do
      Dir.chdir('ruby-math-3d') do
        require File.expand_path('./extconf.rb', Dir.pwd)
        system 'make'
        Process.exit
      end
    end
  end
  Process.waitpid2(pid, Process::WNOHANG)
end

task :default  => :spec
