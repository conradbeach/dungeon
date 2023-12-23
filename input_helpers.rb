module InputHelpers
  # Allows the user to advance to the next piece of text using the enter key.
  def gets_puts(text)
    gets
    puts text
  end

  # Accepts input from the player
  def get_input(prompt)
    puts prompt
    print "==> "
    gets.chomp.downcase
  end
end
