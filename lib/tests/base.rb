require "view"

# A Base class for tests to be performed
class Tests::Base

  ##
  # The number of samples for the full test
  attr_reader :sample_size

  ##
  # The final results to compare test results against
  attr_reader :results

  ##
  # The name of this Test
  attr_reader :name


  # Create a new test.
  #
  # sample_size - The number of samples for the test
  # results     - A hash of the test's final results
  def initialize(sample_size , results)
    @sample_size = sample_size
    @results     = results
    @name        = "Base class"
    User.results = results
  end

  # Perform the test...
  def run!
    purge_database
    prepare_records
    print_output
  end

  # The variant names available for the current test.
  def variants
    results.keys
  end


  private


  def purge_database
    User.delete_all
  end

  def print_output
    puts View.new(self).tap { |s| s.render }.output
  end

  def prepare_records
    sample_size.times { User.new(variant: variants.sample).perform_test }
  end

end
