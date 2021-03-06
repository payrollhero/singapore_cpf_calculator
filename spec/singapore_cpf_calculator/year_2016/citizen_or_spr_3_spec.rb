require 'spec_helper'

describe SingaporeCPFCalculator::Year2016::CitizenOrSPR3 do

  subject(:mod) { described_class }

  describe ".applies_to?" do
    let(:current_date) { Date.new(2016, 7, 1) }
    let(:spr_start_date) { nil }
    let(:employee_contribution_type) { nil }
    let(:employer_contribution_type) { nil }

    let(:result) {
      mod.applies_to? status: status,
                      current_date: current_date,
                      spr_start_date: spr_start_date,
                      employee_contribution_type: employee_contribution_type,
                      employer_contribution_type: employer_contribution_type
    }

    context "when the employee is a citizen" do
      let(:status) { "citizen" }
      it { expect(result).to be_truthy }
    end

    context "when the employee is a permanent resident on their 3rd year" do
      let(:status) { "permanent_resident" }
      let(:spr_start_date) { Date.new(2014, 6, 20) }
      it { expect(result).to be_truthy }
    end

    context "when the employee is a permanent resident on their 2nd year" do
      let(:status) { "permanent_resident" }
      let(:spr_start_date) { Date.new(2015, 6, 20) }

      context "for full employer and employee contribution type" do
        let(:employee_contribution_type) { "full" }
        let(:employer_contribution_type) { "full" }
        it { expect(result).to be_truthy }
      end

      context "for graduated employer and employee contribution type" do
        let(:employee_contribution_type) { "graduated" }
        let(:employer_contribution_type) { "graduated" }
        it { expect(result).to be_falsey }
      end

      context "for full employer and graduated employee contribution type" do
        let(:employee_contribution_type) { "graduated" }
        let(:employer_contribution_type) { "full" }
        it { expect(result).to be_falsey }
      end
    end

    context "when the employee is a permanent resident on their 1st year" do
      let(:status) { "permanent_resident" }
      let(:spr_start_date) { Date.new(2016, 6, 20) }

      context "for full employer and employee contribution type" do
        let(:employee_contribution_type) { "full" }
        let(:employer_contribution_type) { "full" }
        it { expect(result).to be_truthy }
      end

      context "for graduated employer and employee contribution type" do
        let(:employee_contribution_type) { "graduated" }
        let(:employer_contribution_type) { "graduated" }
        it { expect(result).to be_falsey }
      end

      context "for full employer and graduated employee contribution type" do
        let(:employee_contribution_type) { "graduated" }
        let(:employer_contribution_type) { "full" }
        it { expect(result).to be_falsey }
      end
    end

  end

  describe "AW Ceiling" do
    let(:calculator) { mod.calculator_for(current_date, birthdate: birthdate) }
    let(:current_date) { Date.new(2016, 9, 15) }
    let(:birthdate) { Date.new(1998, 8, 15) }
    let(:status) { "permanent_resident" }
    let(:spr_start_date) { Date.new(2016, 6, 20) }
    let(:ordinary_wages) { 3_000 }
    let(:additional_wages) { 2_000 }
    let(:employee_contribution_type) { "full" }
    let(:employer_contribution_type) { "full" }
    subject(:result) {
      calculator.calculate ordinary_wages: ordinary_wages,
                           additional_wages: additional_wages,
                           ytd_ow_subject_to_cpf: cumulative_ordinary
    }

    context "have earned far less than the AW ceiling cumulative" do
      let(:cumulative_ordinary) { 2_000 }
      let(:expected_result) do
        SingaporeCPFCalculator::CPFContribution.new(total: 1850.0,
                                                    employee: 1000.0,
                                                    ow_subject_to_cpf: ordinary_wages,
                                                    aw_subject_to_cpf: additional_wages)
      end

      it { is_expected.to equal_cpf total: 1850, employee: 1000, ow: ordinary_wages, aw: 2000 }
    end

    context "earned 1k under the AW ceiling cumulative" do
      let(:cumulative_ordinary) { 98_000 }
      it { is_expected.to equal_cpf total: 1480, employee: 400, ow: ordinary_wages, aw: 1000 }
    end

    context "has earned the wage ceiling" do
      let(:cumulative_ordinary) { 105_000 }
      it { is_expected.to equal_cpf total: 1110, employee: 300, ow: ordinary_wages, aw: 0 }
    end

    describe "using estimated yearly ordinary wages" do
      subject(:result) {
        calculator.calculate ordinary_wages: ordinary_wages,
                             additional_wages: additional_wages,
                             ytd_ow_subject_to_cpf: cumulative_ordinary,
                             ytd_additional_wages: ytd_additional_wages,
                             estimated_yearly_ow: estimated_yearly_ow
      }
      let(:cumulative_ordinary) { 0 }
      let(:ytd_additional_wages) { 0 }

      context "estimated yearly earnings at the threshold" do
        let(:estimated_yearly_ow) { 102_000 }
        it { is_expected.to equal_cpf total: 1110, employee: 300, ow: ordinary_wages, aw: 0 }
      end

      context "estimated yearly earnings 1k below threshold" do
        let(:estimated_yearly_ow) { 101_000 }
        it { is_expected.to equal_cpf total: 1480, employee: 800, ow: ordinary_wages, aw: 1000 }
      end

      context "estimated yearly earnings 3k below threshold" do
        let(:estimated_yearly_ow) { 99_000 }
        it { is_expected.to equal_cpf total: 1850, employee: 1000, ow: ordinary_wages, aw: 2000 }
      end
    end
  end

  describe "calculator_for" do
    let(:calculator) { mod.calculator_for(current_date, birthdate: birthdate) }
    let(:current_date) { Date.new(2016, 9, 15) }

    context "when the employee's age is 55 or below" do
      context "lower limit" do
        let(:birthdate) { Date.new(1998, 8, 15) }

        it {
          expect(calculator).
            to be SingaporeCPFCalculator::Year2016::CitizenOrSPR3::Age55BelowContributionCalculator
        }
      end

      context "upper limit" do
        let(:birthdate) { Date.new(1961, 9, 15) }
        it {
          expect(calculator).
            to be SingaporeCPFCalculator::Year2016::CitizenOrSPR3::Age55BelowContributionCalculator
        }
      end
    end

    context "when the employee's age is above 55 to 60" do
      context "lower limit" do
        let(:birthdate) { Date.new(1960, 8, 15) }
        it {
          expect(calculator).
            to be SingaporeCPFCalculator::Year2016::CitizenOrSPR3::Age55To60ContributionCalculator
        }
      end

      context "upper limit" do
        let(:birthdate) { Date.new(1956, 9, 15) }
        it {
          expect(calculator).
            to be SingaporeCPFCalculator::Year2016::CitizenOrSPR3::Age55To60ContributionCalculator
        }
      end
    end

    context "when the employee's age is above 60 to 65" do
      context "lower limit" do
        let(:birthdate) { Date.new(1955, 8, 15) }
        it {
          expect(calculator).
            to be SingaporeCPFCalculator::Year2016::CitizenOrSPR3::Age60To65ContributionCalculator
        }
      end

      context "upper limit" do
        let(:birthdate) { Date.new(1951, 9, 15) }
        it {
          expect(calculator).
            to be SingaporeCPFCalculator::Year2016::CitizenOrSPR3::Age60To65ContributionCalculator
        }
      end
    end

    context "when the employee's age is 65 or above" do
      context "lower limit" do
        let(:birthdate) { Date.new(1950, 8, 15) }
        it {
          expect(calculator).
            to be SingaporeCPFCalculator::Year2016::CitizenOrSPR3::Age65UpContributionCalculator
        }
      end

      context "upper limit" do
        let(:birthdate) { Date.new(1916, 8, 15) }
        it {
          expect(calculator).
            to be SingaporeCPFCalculator::Year2016::CitizenOrSPR3::Age65UpContributionCalculator
        }
      end
    end
  end

end
