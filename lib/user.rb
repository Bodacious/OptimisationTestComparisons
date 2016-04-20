# A User represents a hypothetical Real-World user who takes part in a test.
#
#
class User < ActiveRecord::Base

  # The final results for a given test. These are set BEFORE the tests are run,
  #   to allow the app to predict what the result should be.
  #
  # Returns a Hash
  cattr_accessor :results


  # ===============
  # = Validations =
  # ===============

  validates :variant, presence: true, format: { with: /\A[A-Z]{1}\Z/i }


  # ==========
  # = Scopes =
  # ==========

  ##
  # Returns all of the Users with a given variant
  #
  # Examples:
  #
  #   User.variant("A") =>  Returns all of the Users of Variant "A"
  #
  # Returns an ActiveRecord::Relation
  scope :variant, -> (name) { where(variant: name) }

  ##
  # Returns all of the Users who converted
  #
  # Examples:
  #
  #   User.conversion =>  Returns all of the Users who converted
  #
  # Returns an ActiveRecord::Relation
  scope :conversion, -> (true_false) { where(conversion: true_false) }


  # ========================
  # = Public class methods =
  # ========================

  # Returns a Hash of the final results for the current Test. If no results are
  #   provided, the hash will return a random value for each given key.
  def self.results
    @@results ||= Hash.new { |hash, key| hash[key] = rand(100) }
  end

  # The number of conversions for a given variant
  #
  # Returns an Integer
  def self.conversions_for_variant(var)
    variant(var).conversion(true).count
  end

  # The total number of users shown a given variant
  #
  # Returns an Integer
  def self.total_for_variant(var)
    variant(var).count
  end

  # The conversion rate for a given variant (from DB results).
  #
  # Returns a Float
  def self.conversion_rate_for_variant(var)
    converted = conversions_for_variant(var) * 100
    total     = total_for_variant(var)
    return 0.0 if converted.zero? or total.zero?
    Rational(converted, total).to_f.round(precision)
  end

  # Did this User convert?
  #
  # Returns a Boolean true or false
  def conversion?
    @conversion ||= range_for_conversion_rate.include?(random_value)
  end

  # Carry out a test on a User. This method will set the User's test outcome
  #   (conversion true or false) based on the probability of them converting
  #   on their given test variant.
  #
  #   For example, if variant "A" in +User.results+ has a 20% conversion rate, this
  #   will set the User's conversion to `true`, 20% of the time.
  def perform_test
    raise StandardError, "Variant has not been set on #{self}" unless variant?
    self.conversion = conversion?
    self.save!
  end


  # ===========================
  # = Protected class methods =
  # ===========================

  protected


  # A multiplication factor applied to the conversion rate, to allow for more
  #   precise results than simple Integers.
  #
  # Returns an Integer
  def self.multiplication_factor
    @multiplication_factor ||= (10 ** precision)
  end

  # The precision required for output results. This is used when results are
  #   more precise, for example "A" => `1.2345` requires a precision of 4.
  #
  # Returns an Integer
  def self.precision
    @precision ||= results.values.map { |s| s.to_f.to_s.split('.').last.length }.max
  end

  # The `multiplication_factor` multiplied by 100 for percentage calculations
  #
  # Returns an Integer
  def self.factored_percentage
    @factored_percentage ||= multiplication_factor * 100
  end


  # ===================
  # = Private methods =
  # ===================

  private


  # The range of integers, from zero to the maximum conversion rate for the User's
  #   variant.
  #
  # Returns a Range
  def range_for_conversion_rate
    0...factored_conversion_rate_for_variant
  end

  # A random Integer within the `factored_percentage`
  def random_value
    rand(factored_percentage)
  end

  # Acessor for `User.factored_percentage`
  def factored_percentage
    self.class.factored_percentage
  end

  # The final conversion rate for the User's variant.
  def conversion_rate_for_variant
    self.class.results[variant]
  end

  # The conversion rate multiplied by the multiplication factor
  def factored_conversion_rate_for_variant
    conversion_rate_for_variant * multiplication_factor
  end

  def multiplication_factor
    self.class.multiplication_factor
  end

end
