//
//  Deck.swift
//  PayMe
//
//  Created by Maggie Casale on 5/30/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

class Deck {
    var cards: [Card] = [
        // hearts
        Card.init(suit: .hearts, name: .ace),
        Card.init(suit: .hearts, name: .two),
        Card.init(suit: .hearts, name: .three),
        Card.init(suit: .hearts, name: .four),
        Card.init(suit: .hearts, name: .five),
        Card.init(suit: .hearts, name: .six),
        Card.init(suit: .hearts, name: .seven),
        Card.init(suit: .hearts, name: .eight),
        Card.init(suit: .hearts, name: .nine),
        Card.init(suit: .hearts, name: .ten),
        Card.init(suit: .hearts, name: .jack),
        Card.init(suit: .hearts, name: .queen),
        Card.init(suit: .hearts, name: .king),
        
        // diamonds
        Card.init(suit: .diamonds, name: .ace),
        Card.init(suit: .diamonds, name: .two),
        Card.init(suit: .diamonds, name: .three),
        Card.init(suit: .diamonds, name: .four),
        Card.init(suit: .diamonds, name: .five),
        Card.init(suit: .diamonds, name: .six),
        Card.init(suit: .diamonds, name: .seven),
        Card.init(suit: .diamonds, name: .eight),
        Card.init(suit: .diamonds, name: .nine),
        Card.init(suit: .diamonds, name: .ten),
        Card.init(suit: .diamonds, name: .jack),
        Card.init(suit: .diamonds, name: .queen),
        Card.init(suit: .diamonds, name: .king),
        
        // clubs
        Card.init(suit: .clubs, name: .ace),
        Card.init(suit: .clubs, name: .two),
        Card.init(suit: .clubs, name: .three),
        Card.init(suit: .clubs, name: .four),
        Card.init(suit: .clubs, name: .five),
        Card.init(suit: .clubs, name: .six),
        Card.init(suit: .clubs, name: .seven),
        Card.init(suit: .clubs, name: .eight),
        Card.init(suit: .clubs, name: .nine),
        Card.init(suit: .clubs, name: .ten),
        Card.init(suit: .clubs, name: .jack),
        Card.init(suit: .clubs, name: .queen),
        Card.init(suit: .clubs, name: .king),
        
        // spades
        Card.init(suit: .spades, name: .ace),
        Card.init(suit: .spades, name: .two),
        Card.init(suit: .spades, name: .three),
        Card.init(suit: .spades, name: .four),
        Card.init(suit: .spades, name: .five),
        Card.init(suit: .spades, name: .six),
        Card.init(suit: .spades, name: .seven),
        Card.init(suit: .spades, name: .eight),
        Card.init(suit: .spades, name: .nine),
        Card.init(suit: .spades, name: .ten),
        Card.init(suit: .spades, name: .jack),
        Card.init(suit: .spades, name: .queen),
        Card.init(suit: .spades, name: .king),
        
        // jokers
        Card.init(suit: .redJoker, name: .redJoker),
        Card.init(suit: .blackJoker, name: .blackJoker)
                         ]
    
    func shuffle() {
        var shuffled = [Card]()
        
        for _ in 0..<cards.count {
            // Get random postion
            let rand = Int(arc4random_uniform(UInt32(cards.count)))
            
            // Copy card to the new array
            shuffled.append(cards[rand])
            
            // remove the card from the original array
            cards.remove(at: rand)
        }
        
        cards = shuffled
    }
    
    func draw() -> Card {
        let rand = Int(arc4random_uniform(UInt32(cards.count)))
        
        // Get random card from the deck
        let randCard = cards[rand]
        
        // Remove the card from the deck since it's been drawn
        cards.remove(at: rand)
        
        // Return teh drawn card
        return randCard
    }
    
    func deal(numberOfPlayers: Int, round: Int) -> [[Card]] {
        var hands = [[Card]]()
        
        var playerPosition = 0
        var currentRound = 0
        var i = 0
        
        while i < cards.count {
            // If we're not past the round we're dealing for
            if currentRound < round {
                // Add the current card to the current player's hand
                hands[playerPosition].append(draw())
                // Move to the next player postion
                playerPosition = playerPosition + 1
                
            } else  {
                // We've dealt all of the cards
                return hands
            }
            
            // If we're past the number of players
            if playerPosition > numberOfPlayers {
                // Reset to the first person
                playerPosition = 0
                // Move to the next round
                currentRound = currentRound + 1
            }
            
            i = i + 1
        }
        
        return hands
    }
    
    
    
    
    
    
    
    
    
    
}









