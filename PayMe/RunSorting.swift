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
    
    // Make an array of non run cars and remaining wild cards
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
        var result2 = placeOneOrTwoCardRuns(runsSortedByCount: result1.runsSortedByCount, remainingCards: result1.remainingCards)
        
        // Add the two final arrrays together and return
        for runArray in result2.remainingCards {
            result2.runsSortedByCount.append(runArray)
        }
        
        return (result2.runsSortedByCount)
    }
    
    // Add wilds to remaining cards to lessen as many points as possible
    func makeRunsFromWilds(wilds: [Card], remainingCards: [[Card]], runsSortedByCount: [[Card]]) -> (remainingCards: [[Card]], runsSortedByCount: [[Card]], wilds: [Card]) {
        var wilds = wilds
        var remainingCards = remainingCards
        var runsSortedByCount = runsSortedByCount
        
        // Add wilds to remaining cards to lessen as many points as possible
        while wilds.count > 0 {
            var twoCardPoints = false
            var maxPoints = 0
            var remainingCardIndex = 0
            var maxArrayIndex = 0
            var uniqueRunMaxArrayIndex = 0
            
            for addedCards in remainingCards {
                
                // If there's no more 'runs' with less than 3 cards
                if !Bool(remainingCards.filter( { $0.count < 3 } ).count > 0) {
                    
                    // Return remainingCards, runsSortedByCount, and remaning wilds
                    return (remainingCards, runsSortedByCount, wilds)
                }
                
                let result = getPointsWithWilds(addedCards: addedCards, maxPoints: maxPoints, remainingCardIndex: remainingCardIndex, runsSortedByCount: runsSortedByCount)
                
                twoCardPoints = result.twoCardPoints
                maxPoints = result.maxPoints
                maxArrayIndex = result.maxArrayIndex
                uniqueRunMaxArrayIndex = result.uniqueRunMaxArrayIndex

                remainingCardIndex = remainingCardIndex + 1

                if maxPoints > 0 {
                    
                    let result2 = updateMaxPoints(twoCardPoints: twoCardPoints, remainingCards: remainingCards, maxArrayIndex: maxArrayIndex, wild: wilds[0], runsSortedByCount: runsSortedByCount, uniqueRunMaxArrayIndex: uniqueRunMaxArrayIndex)
                    
                    runsSortedByCount = result2.runsSortedByCount
                    remainingCards = result2.remainingCards
                    
                    // Remove wild from wilds array
                    wilds.remove(at: 0)
                    
                    // Remove the single card array from remaining cards
                    remainingCards.remove(at: maxArrayIndex)
                }
            }
        }
        return (remainingCards, runsSortedByCount, wilds)
    }
    
    func updateMaxPoints(twoCardPoints: Bool, remainingCards: [[Card]], maxArrayIndex: Int, wild: Card, runsSortedByCount: [[Card]], uniqueRunMaxArrayIndex: Int) -> (runsSortedByCount: [[Card]], remainingCards: [[Card]]) {
        var runsSortedByCount = runsSortedByCount
        
        // Max points was in a pair
        if twoCardPoints {
            
            // Grab the partial run from remaining cards
            var newRun = remainingCards[maxArrayIndex]
            
            // Move wild from wilds array and append it to the new run
            newRun.append(wild)
            
            // Move the new run from remaining cards and add it to the unique runs
            runsSortedByCount.append(newRun)
            
            // Max points was with a signle card
        } else {
            
            // Grab the card arrays from remaining cards & unique runs
            var addedCards = remainingCards[maxArrayIndex]
            var uniqueRun = runsSortedByCount[uniqueRunMaxArrayIndex]
            
            if uniqueRun.first!.order - 2 == addedCards[0].order {
                // Insert the single card to the begining of the unique run array
                // Insert wild into the second postion of the run array
                uniqueRun.insert(addedCards[0], at: 0)
                uniqueRun.insert(wild, at: 1)
                
            } else if uniqueRun.last!.order + 2 == addedCards[0].order {
                // Append the wild & single card to the end of the unique array
                uniqueRun.append(wild)
                uniqueRun.append(addedCards[0])
            }
        }

        return (runsSortedByCount: runsSortedByCount, remainingCards: remainingCards)
    }
    
    // Find the total points for each opportunity to add a wild
    func getPointsWithWilds(addedCards: [Card], maxPoints: Int, remainingCardIndex: Int, runsSortedByCount: [[Card]]) -> (maxPoints: Int, twoCardPoints: Bool, maxArrayIndex: Int, uniqueRunMaxArrayIndex: Int) {
        var points = 0
        var maxPoints = maxPoints
        var maxArrayIndex = 0
        var uniqueRunMaxArrayIndex = 0
        var twoCardPoints = false
        
        // If there's 2 cards
        if addedCards.count == 2 {
            // Add the points of the two cards together
            for card in addedCards {
                points = points + card.points
            }
            
            // Compare points with max points
            if points > maxPoints {
                maxPoints = points
                maxArrayIndex = remainingCardIndex
                twoCardPoints = true
            }
            
            // There's only a single card & it's points are higher than the max points
        } else if addedCards.count == 1 && addedCards[0].points > maxPoints {
            
            // Loop through the unique runs and see if this card could be added
            var couldBeAdded = false
            var uniqueRunIndex = 0
            for uniqueRun in runsSortedByCount {
                
                // If this unique run has the same suit
                if uniqueRun.last!.suit == addedCards[0].suit {
                    
                    // If the card of this added run is 2 positions (accounting for a
                    // wild in one of them) ahead of the first card in the unique run
                    if uniqueRun.first!.order - 2 == addedCards[0].order {
                        couldBeAdded = true
                        uniqueRunMaxArrayIndex = uniqueRunIndex
                        break
                        
                        // If the card of this added run is 2 positions (accounting for a
                        // wild in one of them) behind of the last card in the unique run
                    } else if uniqueRun.last!.order + 2 == addedCards[0].order {
                        couldBeAdded = true
                        uniqueRunMaxArrayIndex = uniqueRunIndex
                        break
                    }
                }
                
                uniqueRunIndex = uniqueRunIndex + 1
            }
            
            // If we found an array that we could add a wild and
            // this card, update max points and max array index
            if couldBeAdded {
                maxPoints = points
                maxArrayIndex = remainingCardIndex
                twoCardPoints = false
            }
        }

        return (maxPoints: maxPoints, twoCardPoints: twoCardPoints, maxArrayIndex: maxArrayIndex, uniqueRunMaxArrayIndex: uniqueRunMaxArrayIndex)
    }
    
    // Loop through the partial runs with 1 or 2 cards and try to fin homs for them
    func placeOneOrTwoCardRuns(runsSortedByCount: [[Card]], remainingCards: [[Card]]) -> (runsSortedByCount: [[Card]], remainingCards: [[Card]]) {
        var runsSortedByCount = runsSortedByCount
        var remainingCards = remainingCards
        
        // Loop through the partial runs with 1 or 2 cards
        for runArray in runsSortedByCount.filter({ $0.count <= 2 }).sorted(by: { $0.count < $1.count }) {
            
            // Loop through the partial run
            var notMoved = [Card]()
            for card in runArray {
                
                // Try and find a run to add the current card
                var index = 0
                var added = false
                while index < runsSortedByCount.count {
                    var uniqueRun = runsSortedByCount[index]
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
                    runsSortedByCount = runsSortedByCount.filter({ $0.count > 2 }).sorted(by: { $0.count < $1.count })
                }
            }
            
            // If cards weren't removed from the array
            if notMoved.count > 0 {
                remainingCards.append(notMoved) // Add the not moved cards
            }
        }
        
        return (runsSortedByCount, remainingCards)
    }
    
    // Loop through hand that's sorted into an array of run arrays
    // return split up arrays of runs and not runs
    func getSplitRunArrays(hand: [Card]) -> (runsSortedByCount: [[Card]], remainingCards: [[Card]]) {
        
        // Sort cards into overlapping (with duplicate cards) run arrays
        let currentData: [[Card]] = getInitialRunArrays(hand: hand)
        
        // Array of sorted runs
        var runsSortedByCount = [[Card]]()
        
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
                if runsSortedByCount.count == 0 {
                    runsSortedByCount[currentRunIndex] = [card]
                    break
                }
                
                // Sort the runs by the number of cards in their arrays from LOWEST to HIGHEST
                runsSortedByCount = runsSortedByCount.sorted(by: { $0.count < $1.count })
                
                // Find the index to add this card
                currentRunIndex = 0
                for addedRun in runsSortedByCount {
                    // If an added run has the same suit and this card can be appended
                    // to the added run, stop incrementing the current run index
                    if addedRun.last!.suit == card.suit && addedRun.last!.order < card.order {
                        break // Stop looping, were at the right index
                    }
                    
                    currentRunIndex = currentRunIndex + 1
                }
                
                // There wasn't an available run, start a new one
                if currentRunIndex >= runsSortedByCount.count {
                    runsSortedByCount.append([card]) // Make a new array
                    
                } else { // Add it to the current run
                    var currentRun = runsSortedByCount[currentRunIndex] // Grab the current run
                    currentRun.append(card) // Append this card
                    runsSortedByCount[currentRunIndex] = currentRun // Update the runsSortedByCount array
                }
            }
        }
        
        // Grab the unique runs (arrays with more than 2 cards) and sort them by count
        let uniqueRuns = runsSortedByCount.filter({ $0.count > 2 }).sorted(by: { $0.count < $1.count })
        
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
