module SingaporeCPFCalculator
  module Year2015
    module SPR1FG

      # Payment calculator for Singapore's Central Provident Fund for employee's age 60 to 65.
      class Age60To65ContributionCalculator < Year2015::Base

        extend Requirements::GroupAbove60To65Years

        private

        def tc_rate_1
          "0.085"
        end

        def tc_rate_2
          "0.135"
        end

        def ec_rate
          "0.05"
        end

        def adjustment_rate
          "0.15"
        end

      end

    end
  end
end
