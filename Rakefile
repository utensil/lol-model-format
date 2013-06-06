require 'rspec/core/rake_task'

desc 'Default: run specs.'
RSpec::Core::RakeTask.new :spec do |t|
  t.pattern = FileList["**/spec/*_spec.rb"].
                exclude('spec/lol_model_spec.rb', 'spec/md2_model_spec.rb')
end

task :default  => :spec