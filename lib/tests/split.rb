class Tests::Split < Tests::Base

  def initialize(*args)
    super
    @name = 'Split test'
  end


  private


  def prepare_records
    sample_size.times { User.new(variant: variants.sample).perform_test }
  end

end