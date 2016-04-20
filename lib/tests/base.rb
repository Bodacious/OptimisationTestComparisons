require "view"

class Tests::Base

  attr_reader :sample_size

  attr_reader :results

  attr_reader :name

  def initialize(sample_size , results)
    @sample_size = sample_size
    @results     = results
    @name        = "Base class"
    User.results = results
  end

  def run!
    purge_database
    prepare_records
    print_output
  end

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
