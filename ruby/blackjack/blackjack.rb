class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
      :two   => 2,
      :three => 3,
      :four  => 4,
      :five  => 5,
      :six   => 6,
      :seven => 7,
      :eight => 8,
      :nine  => 9,
      :ten   => 10,
      :jack  => 10,
      :queen => 10,
      :king  => 10,
      :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards, :isDealer, :topCard, :cardValue

  MAX_VALUE = 21

  def initialize(isDealer)
    @cards = []
    @isDealer = isDealer
    @topCard = nil
    @cardValue = 0
  end

  # gives the hand 2 cards initially, returns true if we already lost, false otherwise
  def deal_initial_hand(cards, topCard)
    cards.each do |card|
      @cards.push(card)

      if(card.value.class == Array)
        @cardValue += card.value[0] # choose the 11
      else
        @cardValue += card.value
      end

      if @cardValue >= MAX_VALUE
        return true
      end

    end

    if(@isDealer)
      @topCard = topCard
    end

    return false

  end

  def getMyDealerShowingCard(dealer)
    if @isDealer
      puts "This is not the player!"
    else
      @topCard = dealer.getTopCard
      return @topCard
    end
  end

  def getTopCard
    return @topCard
  end


  # returns true if game is over, false otherwise
  def hitMe(card)
    @hit = card
    if @hit.value.class == Array
      @cardValue += @hit.value[0]
    else
      @cardValue += @hit.value
    end


    @cards.push(@hit)

    if @cardValue >= MAX_VALUE
      return true
    end

    return false


  end

  def setTopCard(card)
    @topCard = card
  end



end

require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end

  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end

  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end

  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(!@deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class GameTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
    @player = Hand.new(false)
    @dealer = Hand.new(true)
  end

  def test_initial_hand
    @deck.shuffle
    @playercards = []
    @dealercards = []

    @playercards.push(@deck.deal_card)
    @playercards.push(@deck.deal_card)
    @dealercards.push(@deck.deal_card)
    @dealercards.push(@deck.deal_card)

    @player.deal_initial_hand(@playercards, nil)
    @dealer.deal_initial_hand(@dealercards, @deck.deal_card)

    assert_equal(2,@player.cards.length)
    assert_equal(2,@dealer.cards.length)

  end

  def test_see_dealer_showing
    @deck.shuffle
    playercards = []
    dealercards = []

    playercards.push(@deck.deal_card)
    playercards.push(@deck.deal_card)
    dealercards.push(@deck.deal_card)
    dealercards.push(@deck.deal_card)

    topCard = @deck.deal_card

    @player.deal_initial_hand(playercards, nil)
    @dealer.deal_initial_hand(dealercards, topCard)

    assert_equal(topCard, @player.getMyDealerShowingCard(@dealer))
  end

  def test_hit
    @deck.shuffle
    @playercards = []
    @dealercards = []

    @playercards.push(@deck.deal_card)
    @playercards.push(@deck.deal_card)
    @dealercards.push(@deck.deal_card)
    @dealercards.push(@deck.deal_card)

    @gameover = false

    @topCard = @deck.deal_card

    @gameover = @player.deal_initial_hand(@playercards, nil)

    if @gameover
      if @player.cardValue == 21
        puts "PLAYER WINS INITIAL WITH SCORE 21"
      else
        puts "PLAYER LOSES INITIAL WITH SCORE " + @player.cardValue.to_s + ", DEALER SCORE WAS " + @dealer.cardValue.to_s
      end

      assert(@gameover)
      return
    end


    @gameover = @dealer.deal_initial_hand(@dealercards, @topCard)

    if @gameover
      if @dealer.cardValue == 21
        puts "DEALER WINS INITIAL WITH SCORE 21!"
      else
        puts "DEALER LOSES INITIAL WITH SCORE " + @dealer.cardValue.to_s + ", PLAYER SCORE WAS " + @player.cardValue.to_s
      end
      assert(@gameover)
      return
    end

    playerturn = true

    while !@gameover do
      if playerturn
        @gameover = @player.hitMe(@topCard)
        if @gameover
          if @player.cardValue == 21
            puts "PLAYER WINS WITH CARD VALUE 21"
          else
            puts "DEALER WINS WITH CARD VALUE " + @dealer.cardValue.to_s + ", PLAYER SCORE WAS " + @player.cardValue.to_s
          end
        end

      else
        @gameover = @dealer.hitMe(@topCard)
        if @gameover
          if @dealer.cardValue == 21
            puts "DEALER WINS WITH CARD VALUE 21"
          else
            puts "PLAYER WINS WITH CARD VALUE " + @player.cardValue.to_s + ", DEALER SCORE WAS " + @dealer.cardValue.to_s
          end
        end
      end

      @topCard = @deck.deal_card

      playerturn = !playerturn

    end

    assert(@gameover)
  end

end