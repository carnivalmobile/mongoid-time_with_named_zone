require 'mongoid'
require 'mongoid/time_with_named_zone'

describe Mongoid::TimeWithNamedZone do
  describe '#mongoize' do
    context 'TimeWithNamedZone' do
      let(:time) { Mongoid::TimeWithNamedZone.new(Time.utc(2010, 11, 19), 'Pacific/Auckland') }
      let(:time_with_invalid_zone) { Mongoid::TimeWithNamedZone.new(Time.utc(2010, 11, 19), 'Invalid_timezone') }

      it 'returns hash with utc time and zone' do
        expect(Mongoid::TimeWithNamedZone.mongoize(time)).to eq(time: Time.utc(2010, 11, 19), zone: 'Pacific/Auckland')
      end

      it 'raise an error for invalid timezone' do
        expect { Mongoid::TimeWithNamedZone.mongoize(time_with_invalid_zone) }.to raise_error
      end
    end

    context 'ActiveSupport::TimeWithZone' do
      let(:time) { ActiveSupport::TimeWithZone.new(Time.utc(2010, 11, 19), 'Pacific/Auckland') }

      it 'returns hash with utc time and zone' do
        expect(Mongoid::TimeWithNamedZone.mongoize(time)).to eq(time: Time.utc(2010, 11, 19), zone: 'Pacific/Auckland')
      end
    end

    context 'Time' do
      let(:time) { Time.utc(2010, 11, 19) }

      it 'returns hash with utc time and utc zone' do
        expect(Mongoid::TimeWithNamedZone.mongoize(time)).to eq(time: Time.utc(2010, 11, 19), zone: 'UTC')
      end
    end
  end

  describe '.demongoize' do
    it 'returns time in saved zone' do
      hash = { time: Time.utc(2010, 11, 19), zone: 'Pacific/Auckland' }
      demongoized_value = Mongoid::TimeWithNamedZone.demongoize(hash)
      expect(demongoized_value).to eq(Time.new(2010, 11, 19, '+13:00'))
    end

    it 'returns nil for blank object' do
      expect(Mongoid::TimeWithNamedZone.demongoize(nil)).to eq(nil)
    end
  end
end
