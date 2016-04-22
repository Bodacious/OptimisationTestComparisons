require_relative "variant_data_store"

# See superclass for documentation
class Tests::EpsilonGreedy < Tests::Base

  # The percentage of samples that should be assigned a random variation
  RANDOM_RATE = Rational(ENV["RANDOM"] || 10, 100).to_f

  def initialize(*args)
    super
    @name = 'Epsilon Greedy'
    # Explicitly initialize
    variants.each do |name|
      variant_data[name].increment_count
    end
  end


  private


  def prepare_records
    sample_size.times do
      user = User.new(variant: determine_variant_for_user).tap { |u| u.perform_test }
      store_result(user.variant, user.conversion?)
    end
  end

  def determine_variant_for_user
    if rand < RANDOM_RATE
      random_variant
    else
      most_lucrative_variant
    end
  end


  # A random variant name
  #
  # Returns a String
  def random_variant
    variants.sample
  end

  # The name of the variant that's performing the best so far.
  #
  # Returns a String
  def most_lucrative_variant
    variant_data.sort_by { |key, store| store.conversion_rate }.last.first
  end

  # A Hash of data for each test variant. Each key returns a VariantDataStore by
  # default.
  #
  # Returns a Hash
  def variant_data
    @variant_data ||= Hash.new { |hash, key| hash[key] = Tests::VariantDataStore.new }
  end

  # Store the result for this sample to compare in future iterations.
  def store_result(variant_name, conversion)
    variant_data[variant_name].increment_count
    variant_data[variant_name].increment_conversion_count if conversion
  end

end