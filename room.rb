class Room
  attr_accessor :reference, :name, :description, :connections

  def initialize(reference, name, description, connections)
    @reference = reference
    @name = name
    @description = description
    @connections = connections
  end

  def display_connections
    @connections.each_pair do |direction, connection|
      gets_puts "You look to the #{direction} and see a #{connection}."
    end
  end
end
