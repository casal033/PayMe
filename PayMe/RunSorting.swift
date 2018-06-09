//
//  RunSorting.swift
//  PayMe
//
//  Created by Maggie Casale on 6/8/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

// THIS IS BUILT WITH A MAXIMUM OF THREE DECKS BEING USED
class RunSorting: NSObject {
    
    // Make an array of non run cars 
    func getNonRunCards(hand: [Card]) -> [Card] {
        var nonRunCards = [Card]()
        var sortedByRuns = RunSorting().organizedByRuns(hand:hand)
        while sortedByRuns.filter( { $0.count < 3 } ).count > 0 {
            
            // Loop through the array of runs
            var index = 0
            while index < sortedByRuns.count {
                
                // If the run has less than 3 cards
                let run = sortedByRuns[index]
                if run.count < 3 {
                    for card in run {
                        nonRunCards.append(card)
                    }
                    
                    // Remove partial run from runs array
                    sortedByRuns.remove(at: index)
                } else {
                    
                    // Only increment if we're not removing cards
                    index = index + 1
                }
            }
        }
        return nonRunCards
    }
    
    // Returns the player's hand sorted by runs into an array from least number of cards in the run to the most
    func organizedByRuns(hand: [Card]) -> [[Card]] {
        // Sort the cards into a runs array and non runs array
        let result1 = getSplitRunArrays(hand: hand)
        
        // Loop through the partial runs with 1 or 2 cards
        var result2 = placeOneOrTwoCardRuns(sortedByRuns: result1.sortedByRuns, remainingCards: result1.remainingCards)
        
        // Add the two final arrrays together and return
        for runArray in result2.remainingCards {
            result2.sortedByRuns.append(runArray)
        }
        
        return (result2.sortedByRuns)
    }
    
    // Loop through the partial runs with 1 or 2 cards and try to fin homs for them
    func placeOneOrTwoCardRuns(sortedByRuns: [[Card]], remainingCards: [[Card]]) -> (sortedByRuns: [[Card]], remainingCards: [[Card]]) {
        var sortedByRuns = sortedByRuns
        var remainingCards = remainingCards
        
        // Loop through the partial runs with 1 or 2 cards
        for runArray in sortedByRuns.filter({ $0.count <= 2 }).sorted(by: { $0.count < $1.count }) {
            
            // Loop through the partial run
            var notMoved = [Card]()
            for card in runArray {
                
                // Try and find a run to add the current card
                var index = 0
                var added = false
                while index < sortedByRuns.count {
                    var uniqueRun = sortedByRuns[index]
                    if uniqueRun.last!.suit == card.suit && uniqueRun.last!.order < card.order {
                        uniqueRun.append(card)
                        added = true
                    }
                    
                    index = index + 1
                }
                
                // No luck, store the card to add it to the remaining cards
                if !added {
                    notMoved.append(card)
                    
                } else { // We added the card, resort the unique runs
                    sortedByRuns = sortedByRuns.filter({ $0.count > 2 }).sorted(by: { $0.count < $1.count })
                }
            }
            
            // If cards weren't removed from the array
            if notMoved.count > 0 {
                remainingCards.append(notMoved) // Add the not moved cards
            }
        }
        
        return (sortedByRuns, remainingCards)
    }
    
    // Loop through hand that's sorted into an array of run arrays
    // return split up arrays of runs and not runs
    func getSplitRunArrays(hand: [Card]) -> (sortedByRuns: [[Card]], remainingCards: [[Card]]) {
        
        // Sort cards into overlapping (with duplicate cards) run arrays
        let currentData: [[Card]] = getInitialRunArrays(hand: hand)
        
        // Array of sorted runs
        var sortedByRuns = [[Card]]()
        
        // Array of cards that couldn't be placed in a run
        var remainingCards = [[Card]]()
        
        var currentRunIndex = 0 // Index of a current unique run to append a card
        
        // Loop through hand that's sorted into an array of run arrays
        for runArray in currentData {
            // If this array had less than three card
            if runArray.count < 3 {
                remainingCards.append(runArray)
                break
            }
            
            // Loop through cards in the run array
            for card in runArray {
                // If we're in a new hand
                if sortedByRuns.count == 0 {
                    sortedByRuns[currentRunIndex] = [card]
                    break
                }
                
                // Sort the runs by the number of cards in their arrays from LOWEST to HIGHEST
                sortedByRuns = sortedByRuns.sorted(by: { $0.count < $1.count })
                
                // Find the index to add this card
                currentRunIndex = 0
                for addedRun in sortedByRuns {
                    // If an added run has the same suit and this card can be appended
                    // to the added run, stop incrementing the current run index
                    if addedRun.last!.suit == card.suit && addedRun.last!.order < card.order {
                        break // Stop looping, were at the right index
                    }
                    
                    currentRunIndex = currentRunIndex + 1
                }
                
                // There wasn't an available run, start a new one
                if currentRunIndex >= sortedByRuns.count {
                    sortedByRuns.append([card]) // Make a new array
                    
                } else { // Add it to the current run
                    var currentRun = sortedByRuns[currentRunIndex] // Grab the current run
                    currentRun.append(card) // Append this card
                    sortedByRuns[currentRunIndex] = currentRun // Update the sortedByRuns array
                }
            }
        }
        
        // Grab the unique runs (arrays with more than 2 cards) and sort them by count
        let uniqueRuns = sortedByRuns.filter({ $0.count > 2 }).sorted(by: { $0.count < $1.count })
        
        return (remainingCards, uniqueRuns)
    }
    
    func getInitialRunArrays(hand: [Card]) -> [[Card]] {
        var arrayOfCards = [Card]()
        var arrayOfRuns = [[Card]]()
        
        for card in sortHand(hand: hand, byLow: true) {
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
    
    func sortHand(hand: [Card], byLow: Bool) -> [Card] {
        if byLow {
            return hand.sorted(by: { $0.order < $1.order })
        } else {
            return hand.sorted(by: { $0.order > $1.order })
        }
    }
}
