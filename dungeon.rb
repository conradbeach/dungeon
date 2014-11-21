#TODO: Add room events. Add objects. Add monsters.

class Dungeon
  attr_accessor :player

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end

  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def start(location)
    @player.location = location
    show_current_description
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def go(direction)
    puts "You go " + direction.to_s
    @player.location = find_room_in_direction(direction)
    show_current_description
  end



  class Player
    attr_accessor :name, :location

    def initialize(name)
      @name = name
    end
  end

  class Room
    attr_accessor :reference, :name, :description, :connections, :number_of_times_visited

    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections

      @number_of_times_visited = 0
    end

    def full_description
      "#{@name}: #{@description}"
    end

    def display_connections
      count = 1
      @connections.each_pair do |direction, connection|
        puts "#{count}. You look to the #{direction.to_s} and see a #{connection}."
        count += 1
      end
    end
  end

end

dark_dungeon = Dungeon.new("Conrad")

dark_dungeon.add_room(:large_cave, "Large Cave", "You are in a large cavernous cave.", { east: :smallcave, west: :dragons_den })
dark_dungeon.add_room(:small_cave, "Small Cave", "It appears to be a rather small, claustrophobic cave.", { west: :largecave })
dark_dungeon.add_room(:dragons_den, "Dragon's Den", "Hmmmm... It smells strongly or rotting meat. Nothing to be worried about I'm sure.", { east: :large_cave })
dark_dungeon.add_room(:hallway, "Long Hallway", "I don't really see anything. I wonder where this leads.", { east: :far_room, west: :shiny_room })
dark_dungeon.add_room(:far_room, "Far Room", "Ack! There's a dinosaur like monster at the other end of the room.", { west: :hallway })
dark_dungeon.add_room(:shiny_room, "Shiny Room", "Hoorah! We found the treasure!", { east: :hallway })



