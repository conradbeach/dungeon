#TODO: Implement riddle for treasure room. Validate user input for same method.

class Dungeon
  attr_accessor :player
  attr_reader :moves

  def initialize
    @rooms = {}
    @moves = 0

    add_room(:large_cave, "Large Cave", "You find yourself in a large cavernous room.",
            { east: :small_cave, west: :dragons_den, north: :hallway })
    add_room(:small_cave, "Small Cave", "It appears to be a rather small cave.", { west: :large_cave })
    add_room(:dragons_den, "Dragon's Den", "Hmmmm... It smells strongly of rotting meat in here.
              Well, it's nothing to be worried about I'm sure.", { east: :large_cave })
    add_room(:hallway, "Long Hallway", "I don't really see anything. I wonder where this leads.", { east: :far_room, south: :large_cave })
    add_room(:far_room, "Far Room", "It's kind of dark in here.", { west: :hallway })
  end

  def add_room(reference, name, description, connections)
    @rooms[reference] = Room.new(reference, name, description, connections)
  end

  def start
    puts "\n\"Welcome adventurer! What's your name?\""
    @player = Player.new(gets.chomp)
    @player.location = :large_cave
    puts "\"We're glad you're here #{@player.name}.\""
    gets
    puts "\"We're told there's treasure in the cave ahead, but it will likely be dangerous.\""
    gets
    puts "\"You don't have much to help you out unfortunately. But you do have courage, intellect and strength.\""
    gets
    puts "\"Well, you've also got that sack lunch your mom gave you but that thing is like really old so we'd definitely recommend not eating that.\""
    gets
    puts "\"Seriously.\""
    gets
    puts "\"Good luck! And bring us back some treasure!\""
    gets
    puts "Hesitantly, you walk into the cave..."
  end

  def play
    while true
      if @moves == 7
        open_treasure_room
      end
      show_current_description
      event(@player.location)
      display_options
      gets
      while true
        puts "\nWhich direction would you like to go?"
        choice = gets.chomp.downcase.to_sym
        unless find_room_in_dungeon(@player.location).connections.keys.include?(choice)
          puts "That's not really an option right now. Best try something else!\n"
          gets
        else
          break
        end
      end
      go(choice)
    end
  end

  def go(direction)
    @moves += 1
    @player.location = find_room_in_direction(direction)
    puts "\nYou go #{direction.to_s}."
  end

  def show_current_description
    gets
    puts "\n"
    puts find_room_in_dungeon(@player.location).description
    puts "----------------------------------------------------"
  end

  def find_room_in_dungeon(reference)
    @rooms[reference]
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def display_options
    find_room_in_dungeon(@player.location).display_connections
  end

  def event(location)
    case location
    when :dragons_den
      dragon_attack
    when :small_cave
      panic_attack
    when :far_room
      monster_battle
    when :shiny_room
      riddle
    end
  end

  def dragon_attack
    gets
    puts "Suddenly, a dragon swoops down from the top of the room!"
    gets
    puts "\"ROOOOAAAAAAR!!!\""
    gets
    draw_dragon
    gets
    puts "He promptly roasts you in flame and devours you."
    gets
    puts "Ummm... Well, you're dead."
    gets
    puts "Really, though, what did you expect?!? This place was clearly labeled dragons_den!"
    gets
    puts "Who do you think you are? Bilbo Baggins? Sheesh!"
    game_over
  end

  def panic_attack
    if @visited
      gets
      puts "\"Ok, when I said I was a little claustrophobic, I meant I'm incredibly claustrophobic!\""
      gets
      puts "\"We (WHEEZE) need (WHEEZE) to (WHEEZE) get out (WHEEZE) of here!\""
      gets
      puts "\"Accccckkkkkk!!!\""
      gets
      puts "Ooooh, I'm sorry. But your hero just had a pretty bad panic attack."
      gets
      puts "It appears he suffocated, and well, you're dead."
      gets
      puts "Maybe next time you should have a little more concern for peoples phobias. Serious stuff those things."
      game_over
    else
      gets
      puts "\"No, it's like really tiny in here. And I'm a little claustrophic.\""
      gets
      puts "\"We should probably leave pretty quick and not come back. I'm don't think I can handle this place much longer.\""
      @visited = true
    end
  end

  def monster_battle
    if @dead_dino
      gets
      puts "\"Not sure there's much left to see in this room. I already got my souvenir.\"\n\n"
    else
      gets
      puts "\"I can't really see much so far. I guess I'll have a look around.\""
      gets
      puts "\"Ahh! There's a dinosour looking monster on the other side of this room.\""
      gets
      draw_dino
      gets
      puts "\"He doesn't look too dangerous though. Looks kind of nice actually. I'll just get a little closer...\""
      gets
      puts "\n\"RAAAAAAWWWWR!!\""
      gets
      puts "\n\"Nevermind! Not a nice dinosaur!\""
      gets
      puts "\nIt appears your hero has been thrust into a battle with the beast. Fight well!"

      @dino_hp = 100
      @hero_hp = 100

      gets
      puts "Your hero's hp is #{@hero_hp}."
      puts "The monster's hp is #{@dino_hp}."

      gets
      puts "You can kick (k), punch (p) or scream like a little girl (s)?"


      while !@dead_dino
        while true
          gets
          puts "\nWhat attack would you like to use?"
          attack = gets.chomp.downcase
          unless ["k", "p", "s"].include?(attack)
            puts "\nI'm afraid your hero doesn't know that particular move!"
            gets
            puts "He's not a ninja! Give him a break.\n"
          else
            break
          end
        end

        case attack
        when "k"
          puts "\nYou level a hearty kick at the foul creature!"
          @damage_to_dino = rand(12..23)
        when "p"
          puts "\nYou give the dino a good punch to the noggin!"
          @damage_to_dino = rand(8..18)
        when "s"
          puts "\nYou let out a frightened scream!"
          gets
          puts "Uhhh. That really didn't do anything."
          @damage_to_dino = 0
        end
        @dino_hp -= @damage_to_dino
          gets
          puts "Your hero dealt #{@damage_to_dino} damage! And the monster's HP drops to #{@dino_hp}."
        if @dino_hp <= 0
          gets
          puts "\nHoorah! You have vanquished the beast! Well done."
          gets
          puts "Your hero plucks out one of the monster's horns as a momento of his great victory."
          gets
          puts "Let us press on. To treasure! And glory!\n\n"
          @dead_dino = true
          break
        end

        @damage_to_hero = rand(10..20)
        @hero_hp -= @damage_to_hero
        gets
        puts "\nThe monster attacks!"
        gets
        puts "The monster dealt #{@damage_to_hero} damage! And your hero's HP drops to #{@hero_hp}"
        if @hero_hp <= 0
          gets
          puts "\nI regret to say that you've been bested by your prehistoric foe. You fought nobly. For that, you are to be commended."
          gets
          puts "Unless you didn't actually fight nobly. If so, I would like my commendation back thank you very much!"
          gets
          puts "I really don't know what happened."
          gets
          puts "This is a prewritten message after all. Sooooo... yeah."
          gets
          puts "Either way your hero is dead. So sorry."
          game_over
        end
      end
    end
  end

  def riddle
    gets
    puts "But wait. It appears we'll have to solve a puzzle before we can get to the treasure."
    gets
    puts "You see before you 3 cups."
    gets
    puts "One is of pure crystal."
    gets
    puts "Another is of plain wood."
    gets
    puts "The third is made of ornate gold inset with various gems."
    gets
    puts "The inscription below says you must choose one of them. But we must choose wisely."
    gets
    while true
      puts "\nWhich cup should your hero select? Crystal, wood or gold?"
      answer = gets.chomp.downcase

      unless ["crystal", "wood", "gold"].include?(answer)
        puts "I'm afraid your hero didn't quite understand that."
      else
        break
      end
    end

    if answer == "wood"
      puts "\nAbove, a voice says, \"You have chosen well. You may proceed to your reward.\""
      gets
      puts "My goodness! You've done it!"
      gets
      puts "You have traversed the trails and trials before you and have found a great treasure!"
      gets
      puts "Use your newfound wealth for good my friend. Go buy a sportscar or something."
      game_over
    else
      puts "A booming, unseen voice cries out, \"You have failed the test! You are unworthy. You must be destroyed!\""
      gets
      puts "In an instant, magma pours in from the ceiling and doors."
      gets
      puts "Your hero frantically searches for a means of escape but sees nothing."
      gets
      puts "This looks like... the end."
      gets
      puts "..."
      gets
      puts "Your hero is dead."
      gets
      puts "May I recommend watching a little more Indiana Jones. Would probably help a bit."
      game_over
    end
  end

  def open_treasure_room
    gets
    puts "\nRUUUUUUMMMMBLE! CRASH!"
    gets
    puts "\"Whoah! What was that?!?\""
    gets
    puts "\"I guess I'll find out... Or maybe I don't want to.\""
    gets
    puts "Slightly shaken, your hero presses on."
    add_room(:shiny_room, "Shiny Room", "Hoorah! We found it. The treasure is ours!", { east: :hallway })
    @rooms[:hallway].connections[:west] = :shiny_room
  end

  def game_over
    gets
    puts "\n\n********************************************************************"
    puts "Thanks for adventuring with us today. Come back and play again sometime!\n\n"
    exit
  end

  def draw_dino
    puts "                                 .       . "
    puts "                                / `.   .' \ "
    puts "                        .---.  <    > <    >  .---. "
    puts "                        |    \  \ - ~ ~ - /  /    | "
    puts "                         ~-..-~             ~-..-~ "
    puts "                     \~~~\.'                    `./~~~/ "
    puts "           .-~~^-.    \__/                        \__/ "
    puts "         .'  O    \     /               /       \  \ "
    puts "        (_____,    `._.'               |         }  \/~~~/ "
    puts "         `----.          /       }     |        /    \__/ "
    puts "               `-.      |       /      |       /      `. ,~~| "
    puts "                   ~-.__|      /_ - ~ ^|      /- _      `..-'   f: f: "
    puts "                        |     /        |     /     ~-.     `-. _||_||_ "
    puts "                        |_____|        |_____|         ~ - . _ _ _ _ _> "
  end

  def draw_dragon
    puts "                       .     _///_, "
    puts "                     .      / ` ' '> "
    puts "                       )   o'  __/_'> "
    puts "                      (   /  _/  )_\'> "
    puts "                       ' '__/   /_/\_> "
    puts "                           ____/_/_/_/ "
    puts "                          /,---, _/ / "
    puts "                         ''  /_/_/_/ "
    puts "                            /_(_(_(_ "
    puts "                           (   \_\_\\_               )\ "
    puts "                            \'__\_\_\_\__            ).\ "
    puts "                            //____|___\__)           )_/ "
    puts "                            |  _  \'___'_(           /' "
    puts "                             \_ (-'\'___'_\      __,'_' "
    puts "                             __) \  \\___(_   __/.__,' "
    puts "                          ,((,-,__\  '', __\_/. __,' "
    puts "                                       ''./_._._-' "
  end


  class Player
    attr_accessor :name, :location

    def initialize(name)
      @name = name
    end
  end


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
        gets
        puts "You look to the #{direction.to_s} and see a #{connection.to_s}."
      end
    end
  end

end

dark_dungeon = Dungeon.new
dark_dungeon.start
dark_dungeon.play








