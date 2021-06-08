namespace :test do
  require "rspec/core/rake_task"

  tests = []

  desc "Runs unit tests"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/unit/**/test_*.rb"
    # do NOT remove --fail-fast below, it would break image creation due to a RSpec bug (?)
    t.rspec_opts = ["-Ilib", "-Ispec/unit", "--color", "--backtrace", "--format=progress", "--fail-fast"]
  end
  tests << :unit

  task :all => tests
end

desc "Runs all tests, unit then integration on examples"
task :test => :'test:all'
