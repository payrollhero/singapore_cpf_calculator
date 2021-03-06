module SingaporeCPFCalculator
  module Year2014
    module SPR2FG

      # Payment calculator for Singapore's Central Provident Fund for employee's age 55 to 60.
      class Age55To60ContributionCalculator < Year2014::Base

        extend Requirements::GroupAbove55To60Years

        private

        def tc_rate_1
          "0.105"
        end

        def tc_rate_2
          "0.23"
        end

        def adjustment_rate
          "0.375"
        end

        def ec_rate
          "0.125"
        end

      end

    end
  end
end
