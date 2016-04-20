class Tests::EpsilonGreedy < Tests::Base

  def initialize(*args)
    super
    @name = 'Epsilon Greedy'
  end

  private

  def prepare_records
    sample_size.times do
      if rand() < 0.1 or variant_data.empty?
        @user = assign_a_random_value
      else
        @user = assign_the_most_lucrative_value
      end
      store_result(@user.variant, @user.conversion?)
    end

  end

  def assign_a_random_value
    @user = User.new(variant: variants.sample)
    @user.perform_test
    @user
  end

  def assign_the_most_lucrative_value
    User.new.tap do |user|
      user.variant = variant_data.
        sort_by { |key, attributes| attributes[:conversion_rate] }.last.first
      user.perform_test
    end
  end

  def variant_data
    @variant_data ||= {}
  end

  def store_result(variant_name, conversion)
    variant_data[variant_name] ||= Hash.new { |hash, key| hash[key] = 0 }
    variant_data[variant_name][:count] += 1
    variant_data[variant_name][:conversion_count] += 1 if conversion
    variant_data[variant_name][:conversion_rate] = Rational(variant_data[variant_name][:conversion_count], variant_data[variant_name][:count]).to_f
  end

end