//
//  RunWildSorting.swift
//  PayMe
//
//  Created by Maggie Casale on 6/9/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

class RunWildSorting: NSObject {
    
    // Add wilds to remaining cards to lessen as many points as possible
    func makeRunsFromWilds(wilds: [Card], hand: [Card]) -> (sortedByRuns: [[Card]], wilds: [Card]) {
        var wilds = wilds
        
        // Sort the cards into a runs array and non runs array
        let result1 = RunSorting().getSplitRunArrays(hand: hand)
        
        // Loop through the partial runs with 1 or 2 cards
        let result2 = RunSorting().placeOneOrTwoCardRuns(sortedByRuns: result1.sortedByRuns,
                                                         remainingCards: result1.remainingCards)

        var remainingCards = result2.remainingCards
        var sortedByRuns = result2.sortedByRuns
        
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
                    
                    // Return sortedByRuns and remaning wilds
                    for cards in remainingCards {
                        sortedByRuns.append(cards)
                    }
                    
                    return (sortedByRuns, wilds)
                }
                
                // TODO: Handle case for checking two wilds. Also do thhis in sets class.
                let result = getPointsWithWilds(addedCards: addedCards, maxPoints: maxPoints, remainingCardIndex: remainingCardIndex, sortedByRuns: sortedByRuns)
                
                twoCardPoints = result.twoCardPoints
                maxPoints = result.maxPoints
                maxArrayIndex = result.maxArrayIndex
                uniqueRunMaxArrayIndex = result.uniqueRunMaxArrayIndex
                
                remainingCardIndex = remainingCardIndex + 1
                
                if maxPoints > 0 {
                    
                    let result2 = updateMaxPoints(twoCardPoints: twoCardPoints, remainingCards: remainingCards, maxArrayIndex: maxArrayIndex, wild: wilds[0], sortedByRuns: sortedByRuns, uniqueRunMaxArrayIndex: uniqueRunMaxArrayIndex)
                    
                    sortedByRuns = result2.sortedByRuns
                    remainingCards = result2.remainingCards
                    
                    // Remove wild from wilds array
                    wilds.remove(at: 0)
                    
                    // Remove the single card array from remaining cards
                    remainingCards.remove(at: maxArrayIndex)
                }
            }
        }
        
        // Return sortedByRuns and remaning wilds
        for cards in remainingCards {
            sortedByRuns.append(cards)
        }
        
        return (sortedByRuns, wilds)
    }
    
    func updateMaxPoints(twoCardPoints: Bool, remainingCards: [[Card]], maxArrayIndex: Int, wild: Card, sortedByRuns: [[Card]], uniqueRunMaxArrayIndex: Int) -> (sortedByRuns: [[Card]], remainingCards: [[Card]]) {
        var sortedByRuns = sortedByRuns
        
        // Max points was in a pair
        if twoCardPoints {
            
            // Grab the partial run from remaining cards
            var newRun = remainingCards[maxArrayIndex]
            
            // Move wild from wilds array and append it to the new run
            newRun.append(wild)
            
            // Move the new run from remaining cards and add it to the unique runs
            sortedByRuns.append(newRun)
            
            // Max points was with a signle card
        } else {
            
            // Grab the card arrays from remaining cards & unique runs
            var addedCards = remainingCards[maxArrayIndex]
            var uniqueRun = sortedByRuns[uniqueRunMaxArrayIndex]
            
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
        
        return (sortedByRuns: sortedByRuns, remainingCards: remainingCards)
    }
    
    // Find the total points for each opportunity to add a wild
    func getPointsWithWilds(addedCards: [Card], maxPoints: Int, remainingCardIndex: Int, sortedByRuns: [[Card]]) -> (maxPoints: Int, twoCardPoints: Bool, maxArrayIndex: Int, uniqueRunMaxArrayIndex: Int) {
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
            for uniqueRun in sortedByRuns {
                
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

}
