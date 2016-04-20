$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")

Bundler.require

require "boot"

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)


rescue LoadError
  # no rspec available
end


namespace :run do


  desc "Run the Split test"
  task :split_test do |t, args|
    Tests::Split.new(ENV["SAMPLES"].to_i || 10_000, { "A" => 5.1, "B" => 7.5 }).run!
  end

  desc "Run the greedy test"
  task :epsilon_greedy do
    Tests::EpsilonGreedy.new(ENV["SAMPLES"].to_i || 10_000, { "A" => 5.1, "B" => 7.5 }).run!
  end

  desc "Run all tests"
  task :all => [:split_test, :epsilon_greedy] do
  end

end

task :default => :"run:all"

