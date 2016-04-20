class User < ActiveRecord::Base

  cattr_accessor :results


  scope :variant, -> (name) { where(variant: name) }

  scope :conversion, -> (true_false) { where(conversion: true_false) }


  def conversion?
    @conversion ||= range_for_conversion_rate.include?(random_value)
  end

  def perform_test
    raise StandardError, "Variant has not been set on #{self}" unless variant?
    self.conversion = conversion?
    self.save!
  end

  def self.results
    @@results ||= Hash.new { |hash, key| hash[key] = rand(100) }
  end

  def self.conversions_for_variant(var)
    variant(var).conversion(true).count
  end

  def self.total_for_variant(var)
    variant(var).count
  end

  def self.conversion_rate_for_variant(var)
    converted = conversions_for_variant(var) * 100
    total     = total_for_variant(var)
    return 0.0 if converted.zero? or total.zero?
    Rational(converted, total).to_f.round(precision)
  end


  protected


  def self.multiplication_factor
    @multiplication_factor ||= (10 ** precision)
  end

  def self.precision
    @precision ||= results.values.map { |s| s.to_f.to_s.split('.').last.length }.max
  end

  def self.factored_percentage
    @factored_percentage ||= multiplication_factor * 100
  end


  private


  def range_for_conversion_rate
    0...factored_conversion_rate_for_variant
  end

  def random_value
    rand(factored_percentage)
  end

  def factored_percentage
    self.class.factored_percentage
  end

  def factored_conversion_rate_for_variant
    conversion_rate_for_variant * multiplication_factor
  end

  def conversion_rate_for_variant
    self.class.results[variant]
  end

  def multiplication_factor
    self.class.multiplication_factor
  end

end
