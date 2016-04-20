$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")

Bundler.require

require "boot"

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # no rspec available
end


SAMPLES = ENV["SAMPLES"].nil? ? 5_000 : ENV["SAMPLES"].to_i

namespace :run do

  desc "Run the Split test"
  task :split do |t, args|
    Tests::Split.new(SAMPLES, { "A" => 5.1, "B" => 7.5 }).run!
  end

  desc "Run the greedy test"
  task :epsilon_greedy do
    Tests::EpsilonGreedy.new(SAMPLES, { "A" => 5.1, "B" => 7.5 }).run!
  end

  desc "Run all tests"
  task :all => [:split, :epsilon_greedy] do
  end



end

desc "Run all of the tests (alias for rake run:all)"
task :run => :"run:all"

task :default => :run

