# frozen_string_literal: true
require 'pry'

# The game of tic tac toe, for 2 players
class TicTacToe
  @@player_1_marker = 'X'
  @@player_2_marker = 'O'
  attr_accessor :player1, :player2
  attr_reader :board, :turn, :in_progress

  def initialize(player1, player2)
    @player1 = "#{player1} (#{@@player_1_marker})"
    @player2 = "#{player2} (#{@@player_2_marker})"
    @turn = @player1
    @in_progress = true
    reset
    start
  end

  def show_board
    pp @board
    puts "#{status_of_spot(0, 0)}|#{status_of_spot(0, 1)}|#{status_of_spot(0, 2)}"
    puts "#{status_of_spot(1, 0)}|#{status_of_spot(1, 1)}|#{status_of_spot(1, 2)}"
    puts "#{status_of_spot(2, 0)}|#{status_of_spot(2, 1)}|#{status_of_spot(2, 2)}"
  end

  def status_of_spot(row_index, column_index)
    if (@board[row_index][column_index].eql?(@@player_1_marker)) 
      @@player_1_marker
    elsif (@board[row_index][column_index].eql?(@@player_2_marker))
      @@player_2_marker
    else
      user_representation_of_cell(row_index, column_index)
    end
  end

  private

  def start
    take_turn while @in_progress
    puts "Play again?  yes / no"
    choice = gets.chomp
    if choice == 'yes' 
      reset
      start
    elsif choice != 'no'
      puts "Uh, what???"
      start
    end
  end

  # @return [Array<Number>]
  def calculate_choices
    @board.flatten.select { |item| item != @@player_1_marker && item != @@player_2_marker }
  end

  def take_turn
    show_board
    puts "#{turn}'s turn, where will you mark?"
    choice = gets.chomp.to_i
    until calculate_choices.include?(choice)
      puts "That's not a valid choice at this point. . . try again!"
      pp calculate_choices
      choice = gets.chomp.to_i
    end
    modify_board(choice)
    update_status
    @turn = @turn == @player1 ? @player2 : @player1
  end

  def user_representation_of_cell(row_index, column_index)
    (row_index * 3) + column_index
  end

  def modify_board(choice)
    row_index = choice / 3
    column_index = choice % 3
    @board[row_index][column_index] = @turn == @player1 ? @@player_1_marker : @@player_2_marker
  end

  # go through possible winning lines and see if they are of one players marker
  def update_status
    if player_1_wins?
      puts "#{@player1} wins!"
      @in_progress = false
    end
    if player_2_wins?
      puts "#{@player2} wins!"
      @in_progress = false
    end
    if calculate_choices.length == 0
      puts "Wow, neither of you managed to win. . ."
      @in_progress = false
    end
  end

  def player_wins?(player_marker)
    return true if @board[0].all?(player_marker)
    return true if @board[1].all?(player_marker)
    return true if @board[2].all?(player_marker)
    return true if [@board[0][0], @board[0][1], @board[0, 2]].all?(player_marker)
    return true if [@board[1][0], @board[1][1], @board[1, 2]].all?(player_marker)
    return true if [@board[2][0], @board[2][1], @board[2, 2]].all?(player_marker)

    if @board[1][1] == player_marker
      return true if @board[0][0] == player_marker && @board[2][2] == player_marker
      return true if @board[2][0] == player_marker && @board[0][2] == player_marker
    end
    false
  end

  def player_1_wins?
    player_wins?(@@player_1_marker)
  end

  def player_2_wins?
    player_wins?(@@player_2_marker)
  end

  def reset
    @in_progress = true
    @board = Array.new(3) { |row_index| Array.new(3) { |column_index| user_representation_of_cell(row_index, column_index) } }
  end
end
