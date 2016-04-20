$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")

Bundler.require

require "boot"

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # no rspec available
end

DEFAULT_RANGE = 5..15

SAMPLES = ENV.has_key?("SAMPLES") ? ENV["SAMPLES"].to_i : 5_000

RESULTS = ENV.has_key?("RESULTS") ? JSON.parse(ENV["RESULTS"]) :
  { "A" => rand(DEFAULT_RANGE), "B" => rand(DEFAULT_RANGE) }

namespace :run do

  desc "Run the Split test"
  task :split do |t, args|
    Tests::Split.new(SAMPLES, RESULTS).run!
  end

  desc "Run the greedy test"
  task :epsilon_greedy do
    Tests::EpsilonGreedy.new(SAMPLES, RESULTS).run!
  end

  desc "Run all tests"
  task :all => [:split, :epsilon_greedy] do
  end



end

desc "Run all of the tests (alias for rake run:all)"
task :run => :"run:all"

task :default => :run

