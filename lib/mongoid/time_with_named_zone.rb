require 'mongoid'
require 'mongoid/time_with_named_zone/version'

# Mongoid namespace from the Mongoid gem
module Mongoid
  # Object that stores time and tz information as embedded object
  # transparently works with AS:TwZ, supports mongoid serialization
  module TimeWithNamedZone
    class << self
      # Convert the object from its mongo friendly ruby type to this type
      def demongoize(object)
        return nil unless object.is_a? Hash
        object.symbolize_keys!
        return nil unless object[:time] && object[:zone]
        object[:time].in_time_zone(object[:zone])
      end

      # Turn the object from the ruby type we deal with to a Mongo friendly type
      def mongoize(object)
        case object
        when ActiveSupport::TimeWithZone
          { time: object.utc.mongoize, zone: object.time_zone.name.mongoize }
        when Time || DateTime
          { time: object.utc.mongoize, zone: 'UTC'.mongoize }
        when Date
          { time: object.mongoize, zone: 'UTC'.mongoize }
        when Hash
          { time: object[:time], zone: object[:zone] }
        end
      end

      alias_method :evolve, :mongoize
    end
  end
end
