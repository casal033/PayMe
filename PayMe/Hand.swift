//
//hand.swift
//  PayMe
//
//  Created by Maggie Casale on 6/2/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

class Hand {
    
    func sortHand(hand: [Card], byLow: Bool) -> [Card] {
        if byLow {
            return hand.sorted(by: { $0.order < $1.order })
        } else {
            return hand.sorted(by: { $0.order > $1.order })
        }
    }
    
    func findBestScore() {
        
    }
    
    func points(name: Name) -> Int {
        switch name {
        case .ace: return 15
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .jack: return 10
        case .queen: return 10
        case .king: return 10
        case .joker: return 0
        }
    }
    
    
    /*
     
     TODO:
     - Setup a git repository to commit ths awesomeness!
     
     */
    
    // Returns an identical copy of a hand of cards
    func copyHand(hand: [Card]) -> [Card] {
        var copy = [Card]()
        
        for card in hand {
            copy.append(card)
        }
        
        return copy
    }
    
    // Makes a new hand with all sets removed, then returns the
    // points of the remaining hand with all runs removed
    func getTotalPointsBasedOnSets(hand: [Card]) -> Int {
        var nonSetCards = [Card]()
        for arrayOfCards in self.organizedBySets(hand:hand) {
            if arrayOfCards.count < 3 {
                for card in arrayOfCards {
                    nonSetCards.append(card)
                }
            }
        }
        
        return self.getPointsForRunsInHand(hand: nonSetCards)
    }
    
    // Makes a new hand with all runs removed, then returns the
    // points of the remaining hand with all sets removed
    func getTotalPointsBasedOnRuns(hand: [Card]) -> Int {
        var nonRunCards = [Card]()
        for arrayOfCards in self.organizedByRuns(hand:hand) {
            if arrayOfCards.count < 3 {
                for card in arrayOfCards {
                    nonRunCards.append(card)
                }
            }
        }
        
        return self.getPointsForSetsInHand(hand: nonRunCards)
    }
    
    // Returns the number of points in the hand based on sets
    func getPointsForSetsInHand(hand: [Card]) -> Int {
        var points = 0
        for arrayOfCards in self.organizedBySets(hand:hand) {
            if arrayOfCards.count < 3 {
                // Get points for the amount of cards in the reamining cards
                points = points + (self.points(name: arrayOfCards[0].name) * arrayOfCards.count)
            }
        }
        
        return points
    }
    
    // Returns the number of points in the hand based on runs
    func getPointsForRunsInHand(hand: [Card]) -> Int {
        var points = 0
        for arrayOfCards in self.organizedByRuns(hand: hand) {
            if arrayOfCards.count < 3 {
                // Get points for the remaining cards
                for card in arrayOfCards {
                    points = points + self.points(name: card.name)
                }
            }
        }
        
        return points
    }
    
    // Returns the player's hand organized by sets into a dictionary
    func organizedBySets(hand: [Card]) -> [[Card]] {
        var arrayOfCards = [Card]()
        var arrayOfSets = [[Card]]()
        
        for card in hand {
            if arrayOfCards.count == 0{
                // Start a new run
                arrayOfCards.append(card)
                
            } else if card.name == arrayOfCards[arrayOfCards.count - 1].name {
                // Add card to existing run
                arrayOfCards.append(card)
                
            } else {
                // Add this run to the master array
                arrayOfSets.append(arrayOfCards)
                
                // Start a new run
                arrayOfCards = [Card]()
                arrayOfCards.append(card)
            }
        }
        
        return arrayOfSets
    }
    
    // Returns the player's hand sorted by runs into an array
    // from least number of cards in the run to the most
    func organizedByRuns(hand: [Card]) -> [[Card]] {
        var arrayOfCards = [Card]()
        var arrayOfRuns = [[Card]]()
        
        for card in self.sortHand(hand: hand, byLow: true) {
            if arrayOfCards.count == 0{
                // Start a new run
                arrayOfCards.append(card)
                
            } else if card.order > arrayOfCards[arrayOfCards.count - 1].order {
                // Add card to existing run
                arrayOfCards.append(card)
                
            } else {
                // Add this run to the master array
                arrayOfRuns.append(arrayOfCards)
                
                // Start a new run
                arrayOfCards = [Card]()
                arrayOfCards.append(card)
            }
        }
        return arrayOfRuns.sorted(by: { $0.count < $1.count })
    }
}
