require 'mongoid/time_with_named_zone'

describe Mongoid::TimeWithNamedZone do
  describe '#mongoize' do
    let(:time) { Time.utc(2010, 11, 19) }
    subject { described_class.mongoize(time) }

    it { is_expected.to eq(time: Time.utc(2010, 11, 19), zone: 'UTC') }

    context 'time in Lima zone' do
      let(:time) { super().in_time_zone 'Lima' }
      it { is_expected.to eq(time: Time.utc(2010, 11, 19), zone: 'Lima') }
    end

    context 'when time is an instance of `Date`' do
      let(:time) { Date.new(2010, 11, 29) }
      it { is_expected.to eq(time: Time.utc(2010, 11, 29), zone: 'UTC') }
    end

    context 'when time is an instanc of `DateTime`' do
      let(:time) { DateTime.new(2010, 11, 29) }
      it { is_expected.to eq(time: Time.utc(2010, 11, 29), zone: 'UTC') }
    end

    context 'when time is actually a `Hash`' do
      let(:time) { { time: Time.utc(2010, 11, 29), zone: 'UTC' } }
      it { is_expected.to eq(time: Time.utc(2010, 11, 29), zone: 'UTC') }
    end
  end

  describe '.demongoize' do
    let(:hash) { { 'time' => Time.utc(2010, 11, 19), 'zone' => 'Pacific/Auckland' } }
    subject { described_class.demongoize(hash) }

    it 'returns time in saved zone' do
      expect(subject).to eq(Time.new(2010, 11, 19, '+13:00'))
    end

    context 'When the hash has symbol keys' do
      let(:hash) { super().stringify_keys }

      it 'returns time in saved zone' do
        expect(subject).to eq(Time.new(2010, 11, 19, '+13:00'))
      end
    end

    context 'When the payload is nil' do
      let(:hash) { nil }
      it { is_expected.to eq(nil) }
    end

    context 'When the payload is empty' do
      let(:hash) { {} }
      it { is_expected.to eq(nil) }
    end

    context 'When the hash has no time' do
      let(:hash) { super().tap { |h| h.delete('time') } }
      it { is_expected.to eq(nil) }
    end

    context 'When the hash has no zone' do
      let(:hash) { super().tap { |h| h.delete('zone') } }
      it { is_expected.to eq(nil) }
    end

    context 'When the hash is actually an instance of `BSON::Document`' do
      let(:hash) { BSON::Document.new(super()) }
      it { is_expected.to eq(Time.new(2010, 11, 19, '+13:00')) }
    end
  end
end
