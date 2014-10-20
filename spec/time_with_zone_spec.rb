require 'mongoid/time_with_named_zone'
require 'pry'

describe Mongoid::TimeWithNamedZone do
  describe '#mongoize' do
    subject { Mongoid::TimeWithNamedZone.mongoize(time) }

    context 'time in Lima zone' do
      let(:time) { Time.utc(2010, 11, 19).in_time_zone 'Lima' }
      it { is_expected.to eq(time: Time.utc(2010, 11, 19), zone: 'Lima') }
    end

    context 'Time object' do
      let(:time) { Time.utc(2010, 11, 19) }
      it { is_expected.to eq(time: Time.utc(2010, 11, 19), zone: 'UTC') }
    end

    context 'Date object' do
      let(:time) { Date.new(2010, 11, 29) }
      it { is_expected.to eq(time: Time.utc(2010, 11, 29), zone: 'UTC') }
    end

    context 'DateTime object' do
      let(:time) { DateTime.new(2010, 11, 29) }
      it { is_expected.to eq(time: Time.utc(2010, 11, 29), zone: 'UTC') }
    end
  end

  describe '.demongoize' do
    it 'returns time in saved zone' do
      hash = { 'time' => Time.utc(2010, 11, 19), 'zone' => 'Pacific/Auckland' }
      demongoized_value = Mongoid::TimeWithNamedZone.demongoize(hash)
      expect(demongoized_value).to eq(Time.new(2010, 11, 19, '+13:00'))
    end

    it 'returns nil for blank object' do
      expect(Mongoid::TimeWithNamedZone.demongoize(nil)).to eq(nil)
    end

    it 'returns nil for empty hash' do
      expect(Mongoid::TimeWithNamedZone.demongoize({})).to eq(nil)
    end

    it 'returns nil for hash without time' do
      expect(Mongoid::TimeWithNamedZone.demongoize('zone' => 'UTC')).to eq(nil)
    end
  end
end
