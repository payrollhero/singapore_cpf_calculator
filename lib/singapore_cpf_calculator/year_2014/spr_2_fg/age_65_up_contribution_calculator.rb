module SingaporeCPFCalculator
  module Year2014
    module SPR2FG

      # Payment calculator for Singapore's Central Provident Fund for employee's age 65 and above.
      class Age65UpContributionCalculator < Year2014::Base

        extend Requirements::GroupAbove65Years

        private

        def tc_rate_1
          "0.065"
        end

        def tc_rate_2
          "0.115"
        end

        def adjustment_rate
          "0.15"
        end

        def ec_rate
          "0.05"
        end

      end

    end
  end
end
