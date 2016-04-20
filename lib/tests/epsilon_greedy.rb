require_relative "variant_data_store"

class Tests::EpsilonGreedy < Tests::Base

  RANDOM_RATE = Rational(ENV["RANDOM"] || 10, 100).to_f

  def initialize(*args)
    super
    @name = 'Epsilon Greedy'
  end


  private


  def prepare_records
    sample_size.times do
      user = User.new(variant: determine_variant_for_user).tap { |u| u.perform_test }
      store_result(user.variant, user.conversion?)
    end
  end

  def determine_variant_for_user
    if rand < RANDOM_RATE or variant_data.empty?
      random_variant
    else
      most_lucrative_variant
    end
  end

  def random_variant
    variants.sample
  end

  def most_lucrative_variant
    variant_data.sort_by { |key, store| store.conversion_rate }.last.first
  end

  def variant_data
    @variant_data ||= Hash.new { |hash, key| hash[key] = Tests::VariantDataStore.new }
  end

  def store_result(variant_name, conversion)
    variant_data[variant_name].increment_count
    variant_data[variant_name].increment_conversion_count if conversion
  end

end