module SingaporeCPFCalculator
  module Year2016
    module SPR1GG

      # Payment calculator for Singapore's Central Provident Fund for employee's age 55 to 60.
      class Age55To60ContributionCalculator < Age55BelowContributionCalculator

        extend Requirements::GroupAbove55To60Years

      end

    end
  end
end
