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
        
        
        // REMOVE SETS AND THEN RUNS
        // Make an array of non set cards
        let nonSetCards = SetSorting().getNonSetCards(hand: result.hand)
        
        // Make an array of non run cards
        let nonRunCards = RunSorting().getNonRunCards(hand: nonSetCards)
        
        
        // ADD WILDS THEN REMOVE SETS AND THEN RUNS
        // Make an array of non set cards by adding wilds to the existing cards to make runs
        let nonSetCardsWithWilds = addWildsToMakeSets(wilds: result.wilds, hand: nonRunCards)

        // Gather final points with the remaing cards that wilds couldn't help
        var finalPoints = 0
        for card in addWildsToMakeRuns(wilds: nonSetCardsWithWilds.wilds, hand: nonSetCardsWithWilds.nonSetCards).nonRunCards {
            finalPoints = finalPoints + card.points
        }
        
        return finalPoints
    }
    
    // Makes a new hand with all runs removed, then returns the
    // points of the remaining hand with all sets removed
    func getTotalPointsBasedOnRuns(hand: [Card], wild: Name) -> Int {
        
        // Seperate wilds from the hand
        let result = removeWildsFromHand(wild: wild, hand: hand)
        
        
        // REMOVE RUNS AND THEN SETS
        // Make an array of non run cards
        let nonRunCards = RunSorting().getNonRunCards(hand: result.hand)
        
        // Make an array of non set cards
        let nonSetCards = SetSorting().getNonSetCards(hand: nonRunCards)
        
        
        // ADD WILDS THEN REMOVE RUNS AND THEN SETS
        // Make an array of non run cards by adding wilds to the existing cards to make sets
        let nonRunCardsWithWilds = addWildsToMakeRuns(wilds: result.wilds, hand: nonSetCards)
        
        // Gather final points with the remaing cards that wilds couldn't help
        var finalPoints = 0
        for card in addWildsToMakeSets(wilds: nonRunCardsWithWilds.wilds, hand: nonRunCardsWithWilds.nonRunCards).nonSetCards {
            finalPoints = finalPoints + card.points
        }
        
        return finalPoints
    }
    
    func addWildsToMakeSets(wilds: [Card], hand: [Card]) -> (nonSetCards: [Card], wilds: [Card]) {
        // Make array of sets that include wilds and the remaining wilds
        let setsWithWilds = SetWildSorting().makeSetsFromWilds(hand: hand, wilds: wilds)
        
        // Make new hand without sets
        var handWithoutSets = [Card]()
        for set in setsWithWilds.sortedBySets {
            if set.count < 3 {
                
                for card in set {
                    
                    handWithoutSets.append(card)
                }
            }
        }
        
        // Return an array of non run cards and the remaining wilds
        return (SetSorting().getNonSetCards(hand: handWithoutSets), setsWithWilds.wilds)
    }
    
    func addWildsToMakeRuns(wilds: [Card], hand: [Card]) -> (nonRunCards: [Card], wilds: [Card]) {
        // Make array of runs that include wilds and the unused wilds
        let runsWithWilds = RunWildSorting().makeRunsFromWilds(wilds: wilds, hand: hand)
        
        // Make new hand without runs
        var handWithoutRuns = [Card]()
        for run in runsWithWilds.sortedByRuns {
            if run.count < 3 {
                for card in run {
                    handWithoutRuns.append(card)
                }
            }
        }
        
        // Return an array of non run cards and the remaining wilds
        return (RunSorting().getNonRunCards(hand: handWithoutRuns), runsWithWilds.wilds)
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
