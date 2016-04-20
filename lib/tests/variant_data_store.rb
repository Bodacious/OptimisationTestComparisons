class Tests::VariantDataStore

  attr_accessor :count

  attr_accessor :conversion_count

  def initialize
    @count = 0
    @conversion_count = 0
  end

  def conversion_rate
    Rational(conversion_count, count).to_i
  end

  def increment_count
    self.count += 1
  end

  def increment_conversion_count
    self.conversion_count += 1
  end

end