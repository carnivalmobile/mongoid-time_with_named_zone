require 'mongoid/time_with_named_zone/version'

# Mongoid namespace from the Mongoid gem
module Mongoid
  # Object that stores time and tz information as embedded object
  # transparently works with AS:TwZ, supports mongoid serialization
  class TimeWithNamedZone
    attr_reader :time, :zone

    def initialize(time, zone = 'UTC')
      @time, @zone = time, zone
    end

    # Converts an object of this instance into a database friendly value.
    def mongoize
      TimeWithNamedZone.mongoize(self)
    end

    class << self
      # Get the object as it was stored in the database, and instantiate`
      # this custom class from it.
      def demongoize(object)
        return nil unless object && object[:time] && object[:zone]
        object[:time].in_time_zone(object[:zone])
      end

      def mongoize(object)
        hash = case object
               when self
                 {
                   time: object.time,
                   zone: ActiveSupport::TimeZone.new(object.zone).name
                 }
               when ActiveSupport::TimeWithZone
                 {
                   time: object.utc,
                   zone: object.time_zone
                 }
               when Time
                 {
                   time: object.utc,
                   zone: 'UTC'
                 }
               else
                 nil
               end
        hash.mongoize
      end
    end
  end
end
