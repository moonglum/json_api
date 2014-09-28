require 'ashikawa-core'
require 'cucumber/rake/task'

desc 'Truncate all collections in the database'
task :truncate do
  database = Ashikawa::Core::Database.new do |config|
    config.url = 'http://localhost:8529'
  end
  database.truncate
  puts 'Truncated the collections'
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format pretty'
end

desc 'Truncate all collections in the database and then run cucumber features'
task default: [:truncate, :features]
