# Object that stores time and tz information as embedded object
# transparently works with AS:TwZ, supports mongoid serialization
class TimeWithZone
  attr_reader :time, :zone

  def initialize(time, zone = 'UTC')
    @time, @zone = time, zone
  end

  # Converts an object of this instance into a database friendly value.
  def mongoize
    { time: time, zone: zone }
  end

  class << self
    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      object[:time].in_time_zone(object[:zone]) if object
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
      when TimeWithZone then object.mongoize
      when ActiveSupport::TimeWithZone
        TimeWithZone.new(object.utc, object.time_zone.name).mongoize
      when Time
        TimeWithZone.new(object.utc, 'UTC').mongoize
      else object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when TimeWithZone then object.mongoize
      else object
      end
    end
  end
end
