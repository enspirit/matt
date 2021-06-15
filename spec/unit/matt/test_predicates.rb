require 'spec_helper'
describe Matt, "time predicates" do

  describe "last" do
    subject{
      Matt.last_predicate("7days")
    }

    it 'works as expected' do
      expect(subject).to be_a(Predicate)
      expect(subject).to eql(Predicate.gte(:at, Date.today - 7) & Predicate.lt(:at, Date.today + 1))
    end
  end

  describe "since" do
    subject{
      Matt.since_predicate("2020-01-01")
    }

    it 'works as expected' do
      expect(subject).to be_a(Predicate)
      expect(subject).to eql(Predicate.gte(:at, Date.parse("2020-01-01")) & Predicate.lt(:at, Date.today + 1))
    end
  end

  describe "between" do
    subject{
      Matt.between_predicate("2020-01-01", "2021-01-01")
    }

    it 'works as expected' do
      expect(subject).to be_a(Predicate)
      expect(subject).to eql(Predicate.gte(:at, Date.parse("2020-01-01")) & Predicate.lt(:at, Date.parse("2021-01-01")))
    end
  end
end