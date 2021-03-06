require 'bundler'
Bundler.require

require_relative 'board'
require_relative 'player'
require_relative 'display'


class Game

  attr_accessor :player_X, :current_player, :player_O
  @@victory = false
  @@draw = false

  def initialize
    @canvas = Display.new
    Tk.update
    @board = Board.new
    @player_X = Player.new(:X)
    @player_O = Player.new(:O)
    welcome_players_on_screen
    Tk.update
    @current_player = coin_flip
  end


  def welcome_players_on_screen
    @text = TkText.new(@root) do
      font TkFont.new("family" => 'Helvetica', "size" => 20)
      place('x' => 320, 'y' => 60, 'height' => 295, 'width' => 195)
    end

    @text.insert 'end', "Bienvenue sur\n\nTic-Tac-Toe :D"

    @text = TkText.new(@root) do
      font TkFont.new("family" => 'Helvetica', "size" => 16)
      place('x' => 320, 'y' => 200, 'height' => 295, 'width' => 195)
    end

    @text.insert 'end', "#{@player_X.name} : X\n#{@player_O.name} : O"

  end


  def coin_flip
    puts 'Pile ou Face (le joueur X choisit) ?'
    puts 'P - Pour Pile !'
    puts 'F - Pour Face !'
    cf_input = nil
    until cf_input == 'p' || cf_input == 'f'
      print '> '
      cf_input = gets.chomp
      cf_input = cf_input.downcase
    end
    coin_flip_out(cf_input)
  end

  # retourne le premier joueur
  def coin_flip_out(cf_input)
    flip = ['p, f'].sample
    if flip == 'p'
      if cf_input == flip
        puts "Pile ! #{@player_X.name} commence !"
        @player_X
      else
        puts "Pile ! #{@player_O.name} commence !"
        @player_O
      end
    else
      if cf_input == flip
        puts "Face ! #{@player_X.name} commence !"
        @player_X
      else
        puts "Face ! #{@player_O.name} commence !"
        @player_O
      end
    end
  end


  def play
    until @@victory || @@draw # pour sortir de la boucle
      coords = @current_player.get_coordinates # demande l'input
      if @board.coordinates_available?(coords) # check si coord ok
        @board.move_board(coords, @current_player) # fait le move
        if @current_player == @player_X
          @canvas.cross(coords) # fait une croix dans le canvas
        else
          @canvas.circle(coords) # fait un cercle dans le canvas
        end
        Tk.update
        if @board.has_won?(@current_player) # check si joueur a gagné
          @@victory = true
        elsif @board.is_draw? # check si match nul
          @@draw = true
        end
        switch_players unless @@victory # change de current player sauf si finit
      else
        puts 'La case est déjà prise !'
      end
    end
    puts "Le gagnant est #{@current_player.name} !!" if @@victory
    puts 'Match nul ...' if @@draw
  end

  # méthode pour changer de joueur en fin de boucle play
  def switch_players
    @current_player = if @current_player == player_X
                        player_O
                      else
                        player_X
                      end
  end

end

