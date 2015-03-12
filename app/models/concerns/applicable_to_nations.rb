module ApplicableToNations
  extend ActiveSupport::Concern

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
end
