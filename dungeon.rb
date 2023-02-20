# Allows the user to advance to the next piece of text using the enter key.
def gets_puts(text)
  gets
  puts text
end

class Dungeon
  attr_accessor :player
  attr_reader :moves

  def initialize
    @rooms = {}
    @moves = 0

    #Create dungeon.
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
    gets_puts "\"We're told there's treasure in the cave ahead, but it will likely be dangerous.\""
    gets_puts "\"You don't have much to help you out unfortunately. But you do have courage, intellect and strength.\""
    gets_puts "\"Well, you've also got that sack lunch your mom gave you but that thing is like really old so we'd definitely recommend not eating that.\""
    gets_puts "\"Seriously.\""
    gets_puts "\"Good luck! And bring us back some treasure!\""
    gets_puts "Hesitantly, you walk into the cave..."
  end

  def play
    while true
      if @moves == 7
        open_treasure_room
      end
      show_current_description
      event(@player.location)
      display_options
      while true
        gets_puts "\nWhich direction would you like to go?"
        choice = gets.chomp.downcase.to_sym
        unless find_room_in_dungeon(@player.location).connections.keys.include?(choice)
          puts "That's not really an option right now. Best try something else!\n"
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
    gets_puts "\n"
    puts find_room_in_dungeon(@player.location).description
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
    gets_puts "Suddenly, a dragon swoops down from the top of the room!"
    gets_puts "\"ROOOOAAAAAAR!!!\""
    draw_dragon
    gets_puts "He promptly roasts you in flame and devours you."
    gets_puts "Ummm... Well, you're dead."
    gets_puts "Really, though, what did you expect?!? This place was clearly labeled dragons_den!"
    gets_puts "Who do you think you are? Bilbo Baggins? Sheesh!"
    game_over
  end

  def panic_attack
    if @visited
      gets_puts "\"Ok, when I said I was a little claustrophobic, I meant I'm incredibly claustrophobic!\""
      gets_puts "\"We (WHEEZE) need (WHEEZE) to (WHEEZE) get out (WHEEZE) of here!\""
      gets_puts "\"Accccckkkkkk!!!\""
      gets_puts "Ooooh, I'm sorry. But your hero just had a pretty bad panic attack."
      gets_puts "It appears he suffocated, and well, you're dead."
      gets_puts "Maybe next time you should have a little more concern for peoples phobias. Serious stuff those things."
      game_over
    else
      gets_puts "\"No, it's like really tiny in here. And I'm a little claustrophic.\""
      gets_puts "\"We should probably leave pretty quick and not come back. I'm don't think I can handle this place much longer.\""
      @visited = true
    end
  end

  def monster_battle
    if @dead_dino
      gets_puts "\"Not sure there's much left to see in this room. I already got my souvenir.\"\n\n"
    else
      gets_puts "\"I can't really see much so far. I guess I'll have a look around.\""
      gets_puts "\"Ahh! There's a dinosour looking monster on the other side of this room.\""
      draw_dino
      gets_puts "\"He doesn't look too dangerous though. Looks kind of nice actually. I'll just get a little closer...\""
      gets_puts "\n\"RAAAAAAWWWWR!!\""
      gets_puts "\n\"Nevermind! Not a nice dinosaur!\""
      gets_puts "\nIt appears your hero has been thrust into a battle with the beast. Fight well!"

      @dino_hp = 100
      @hero_hp = 100

      gets_puts "Your hero's hp is #{@hero_hp}."
      puts "The monster's hp is #{@dino_hp}."

      gets_puts "You can kick (k), punch (p) or scream like a little girl (s)?"


      while !@dead_dino
        while true
          gets_puts "\nWhat attack would you like to use?"
          attack = gets.chomp.downcase
          unless ["k", "p", "s"].include?(attack)
            puts "\nI'm afraid your hero doesn't know that particular move!"
            gets_puts "He's not a ninja! Give him a break.\n"
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
          gets_puts "Uhhh. That really didn't do anything."
          @damage_to_dino = 0
        end
        @dino_hp -= @damage_to_dino
          gets_puts "Your hero dealt #{@damage_to_dino} damage! And the monster's HP drops to #{@dino_hp}."
        if @dino_hp <= 0
          gets_puts "\nHoorah! You have vanquished the beast! Well done."
          gets_puts "Your hero plucks out one of the monster's horns as a momento of his great victory."
          gets_puts "Let us press on. To treasure! And glory!\n\n"
          @dead_dino = true
          break
        end

        @damage_to_hero = rand(10..20)
        @hero_hp -= @damage_to_hero
        gets_puts "\nThe monster attacks!"
        gets_puts "The monster dealt #{@damage_to_hero} damage! And your hero's HP drops to #{@hero_hp}"
        if @hero_hp <= 0
          gets_puts "\nI regret to say that you've been bested by your prehistoric foe. You fought nobly. For that, you are to be commended."
          gets_puts "Unless you didn't actually fight nobly. If so, I would like my commendation back thank you very much!"
          gets_puts "I really don't know what happened."
          gets_puts "This is a prewritten message after all. Sooooo... yeah."
          gets_puts "Either way your hero is dead. So sorry."
          game_over
        end
      end
    end
  end

  def riddle
    gets_puts "But wait. It appears we'll have to solve a puzzle before we can get to the treasure."
    gets_puts "You see before you 3 cups."
    gets_puts "One is of pure crystal."
    gets_puts "Another is of plain wood."
    gets_puts "The third is made of ornate gold inset with many gems."
    gets_puts "The inscription below says you must choose one of them. Choose wisely."
    while true
      gets_puts "\nWhich cup should your hero select? Crystal, wood or gold?"
      answer = gets.chomp.downcase

      unless ["crystal", "wood", "gold"].include?(answer)
        puts "I'm afraid your hero didn't quite understand that."
      else
        break
      end
    end

    if answer == "wood"
      puts "\nAbove, a voice says, \"You have chosen well. You may proceed to your reward.\""
      gets_puts "My goodness! You've done it!"
      gets_puts "You have traversed the trails and trials before you and have found a great treasure!"
      gets_puts "Use your newfound wealth for good my friend. Go buy a sportscar or something."
      game_over
    else
      puts "A booming, unseen voice cries out, \"You have failed the test! You are unworthy. You must be destroyed!\""
      gets_puts "In an instant, magma pours in from the ceiling and doors."
      gets_puts "Your hero frantically searches for a means of escape but sees nothing."
      gets_puts "This looks like... the end."
      gets_puts "..."
      gets_puts "Your hero is dead."
      gets_puts "May I recommend watching a little more Indiana Jones. Would probably help a bit."
      game_over
    end
  end

  def open_treasure_room
    gets_puts "\nRUUUUUUMMMMBLE! CRASH!"
    gets_puts "\"Whoah! What was that?!?\""
    gets_puts "\"I guess I'll find out... Or maybe I don't want to.\""
    gets_puts "Slightly shaken, your hero presses on."
    add_room(:shiny_room, "Shiny Room", "Hoorah! We found it. The treasure is ours!", { east: :hallway })
    @rooms[:hallway].connections[:west] = :shiny_room
  end

  def game_over
    gets_puts "\n\n********************************************************************"
    puts "Thanks for adventuring with us today. Come back and play again sometime!\n\n"
    exit
  end

  def draw_dino
    gets_puts "                                 .       . "
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
    gets_puts "                       .     _///_, "
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
        gets_puts "You look to the #{direction} and see a #{connection}."
      end
    end
  end
end

dark_dungeon = Dungeon.new
dark_dungeon.start
dark_dungeon.play
