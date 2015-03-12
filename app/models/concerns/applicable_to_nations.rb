module ApplicableToNations
  extend ActiveSupport::Concern

  included do
    validate :applicable_to_at_least_one_nation
  end

  def possible_nations
    [
      :england,
      :northern_ireland,
      :scotland,
      :wales,
    ]
  end

  def applicable_nations
    applicable_nations = possible_nations.select { |n|
      self.send(n) == true
    }
  end

private

  def applicable_to_at_least_one_nation
    if applicable_nations.empty?
      errors.add(:applicability, "must have at least one nation")
    end
  end
end
