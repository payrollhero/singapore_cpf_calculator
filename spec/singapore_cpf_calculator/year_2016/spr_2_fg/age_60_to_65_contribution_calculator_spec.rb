require 'spec_helper'

describe SingaporeCPFCalculator::Year2016::SPR2FG::Age60To65ContributionCalculator do

  subject(:calculator) {
    described_class.new ordinary_wages: ordinary_wages,
                        additional_wages: additional_wages
  }

  let(:result) { calculator.calculate }

  let(:additional_wages) { 0.0 }

  describe "#calculate" do

    context "when the total wages amounts to 0.00" do
      let(:ordinary_wages) { 0.00 }
      it { expect(result).to equal_cpf total: 0.00, employee: 0.00, employer: 0.00 }
    end

    context "when the total wages amounts to 50.00" do
      let(:ordinary_wages) { 50.00 }
      it { expect(result).to equal_cpf total: 0.00, employee: 0.00, employer: 0.00 }
    end

    context "when the total wages amounts to 50.01" do
      let(:ordinary_wages) { 50.01 }
      it { expect(result).to equal_cpf total: 5.00, employee: 0.00, employer: 5.00 }
    end

    context "when the total wages amounts to 500.00" do
      let(:ordinary_wages) { 500.00 }
      it { expect(result).to equal_cpf total: 45.00, employee: 0.00, employer: 45.00 }
    end

    context "when the total wages amounts to 500.01" do
      let(:ordinary_wages) { 500.01 }
      it { expect(result).to equal_cpf total: 45.00, employee: 0.00, employer: 45.00 }
    end

    context "when the total wages amounts to 749.99" do
      let(:ordinary_wages) { 749.99 }
      it { expect(result).to equal_cpf total: 124.00, employee: 56.00, employer: 68.00 }
    end

    context "when the total wages amounts to 750.00" do
      let(:ordinary_wages) { 750.00 }
      it { expect(result).to equal_cpf total: 124.00, employee: 56.00, employer: 68.00 }
    end

    context "when the total wages amounts to 5,000.00" do
      let(:ordinary_wages) { 5_000.00 }
      it { expect(result).to equal_cpf total: 825.00, employee: 375.00, employer: 440.00 }
    end

    context "when the total wages amounts to 10,000.00" do
      let(:ordinary_wages) { 10_000.00 }
      it { expect(result).to equal_cpf total: 990.00, employee: 450.00, employer: 540.00 }
    end

  end

end
