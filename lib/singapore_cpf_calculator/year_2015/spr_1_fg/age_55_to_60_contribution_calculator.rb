module SingaporeCPFCalculator
  module Year2015
    module SPR1FG

      # Payment calculator for Singapore's Central Provident Fund for employee's age 55 to 60.
      class Age55To60ContributionCalculator < Year2015::Base

        class << self

          # @param [String] age age of the employee
          # @return [true, false] returns true if the matches.
          def applies_to?(age)
            55.0 < age && age <= 60.0
          end

        end

        private

        def tc_rate_1
          d("0.12")
        end

        def tc_rate_2
          d("0.17")
        end

        def ec_rate
          d("0.05")
        end

        def adjustment_rate
          d("0.15")
        end

      end

    end
  end
end
