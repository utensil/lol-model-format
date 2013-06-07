require 'rspec/core/rake_task'

desc 'Default: run specs.'
RSpec::Core::RakeTask.new :spec => :build_ruby_math_3d do |t|
  t.pattern = FileList["**/spec/*_spec.rb"]
  #.exclude('spec/lol_model_spec.rb', 'spec/md2_model_spec.rb')
end

task :build_ruby_math_3d do |t|
  # vendor / ruby-math-3d
  Dir.chdir('vendor') do
    Dir.chdir('ruby-math-3d') do
      pid=Process.fork do
          require 'extconf.rb'
          system 'make'
          Process.exit
      end
      Process.waitpid2(pid, Process::WNOHANG)
    end
  end
end

task :default  => :spec
