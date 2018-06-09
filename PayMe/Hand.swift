//
//hand.swift
//  PayMe
//
//  Created by Maggie Casale on 6/2/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

class Hand {
    
    
    func findBestScore() {
        
    }
    
    func points(name: Name) -> Int {
        switch name {
        case .ace: return 15
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
        case .redJoker: return 0
        case .blackJoker: return 0
        }
    }
    
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
    func getTotalPointsBasedOnSets(hand: [Card], wild: Name) -> Int {
        
        // Seperate wilds from the hand
        let result = removeWildsFromHand(wild: wild, hand: hand)
        
        // Make an array of non set cards and remaining wild cards
        let sortIntoSets = SetSorting().sortIntoSetsAndWilds(hand: result.hand, wilds: result.wilds)
        
        // Make an array of non run cards and remaining wild cards
        let nonRunCards = RunSorting().getNonRunCards(hand: sortIntoSets.nonSetCards)
        
        var finalPoints = 0
        for card in nonRunCards {
            finalPoints = finalPoints + card.points
        }
        
        return finalPoints
    }
    
    // Makes a new hand with all runs removed, then returns the
    // points of the remaining hand with all sets removed
    func getTotalPointsBasedOnRuns(hand: [Card], wild: Name) -> Int {
        
        // Seperate wilds from the hand
        let result = removeWildsFromHand(wild: wild, hand: hand)
        
        // Make an array of non run cards and remaining wild cards
        let nonRunCards = RunSorting().getNonRunCards(hand: result.hand)
        
        // Make an array of non set cards and remaining wild cards
        let sortIntoSets = SetSorting().sortIntoSetsAndWilds(hand: nonRunCards, wilds:result.wilds)

        var finalPoints = 0
        for card in sortIntoSets.nonSetCards {
            finalPoints = finalPoints + card.points
        }
        
        return finalPoints
    }
    
    func sortHand(hand: [Card], byLow: Bool) -> [Card] {
        if byLow {
            return hand.sorted(by: { $0.order < $1.order })
        } else {
            return hand.sorted(by: { $0.order > $1.order })
        }
    }
    
    
    func removeWildsFromHand(wild: Name, hand: [Card]) -> (wilds: [Card], hand: [Card]) {
        // Pull wilds from the remaining cards
        var wilds = [Card]()
        var newHand = [Card]()
        for card in hand {
            if card.name == wild || card.name == .redJoker || card.name == .blackJoker {
                wilds.append(card)
            } else {
                newHand.append(card)
            }
        }
        return (wilds, newHand)
    }
}
