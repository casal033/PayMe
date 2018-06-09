//
//  SetSorting.swift
//  PayMe
//
//  Created by Maggie Casale on 6/9/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

class SetSorting: NSObject {
    
    // Make an array of non set cards and remaining wild cards
    func sortIntoSetsAndWilds(hand: [Card], wilds: [Card]) -> (nonSetCards: [Card], wilds: [Card]) {
        var nonSetCards = [Card]()
        var sortedBySets = SetSorting().organizedBySets(hand: hand, wilds: wilds)
        while sortedBySets.sortedBySets.filter( { $0.count < 3 } ).count > 0 {
            
            // Loop through the array of runs
            var index = 0
            while index < sortedBySets.sortedBySets.count {
                
                // If the run has less than 3 cards
                let run = sortedBySets.sortedBySets[index]
                if run.count < 3 {
                    for card in run {
                        nonSetCards.append(card)
                    }
                    
                    // Remove partial run from runs array
                    sortedBySets.sortedBySets.remove(at: index)
                } else {
                    
                    // Only increment if we're not removing cards
                    index = index + 1
                }
            }
        }
        
        return (nonSetCards, sortedBySets.wilds)
    }
    
    // Returns the player's hand organized by sets into an array of sets
    func organizedBySets(hand: [Card], wilds: [Card]) -> (sortedBySets: [[Card]], wilds: [Card]) {
        var sortedBySets = getSortedBySets(hand: hand).sorted(by: { $0.count < $1.count })
        var wilds = wilds
        
        while wilds.count > 0 {
            var maxPoints = 0
            var maxPointsIndex = 0
            var index = 0
            
            // Go through each 'set' of the sorted sets
            for cards in sortedBySets {
                
                // If there's no more 'sets' with less than 3 cards
                if !Bool(sortedBySets.filter( { $0.count < 3 } ).count > 0) {
                    
                    // Return the sortedBySets and remaning wilds
                    return (sortedBySets, wilds)
                    
                } else {
                    // If there's a single card in the 'set' and it's points are greater than the max points
                    if cards.count == 1 && cards[0].points > maxPoints {
                        maxPoints = cards[0].points
                        maxPointsIndex = index
                        
                        // If there's two cards in the 'set'
                    } else if cards.count == 2 {
                        
                        // Check to see if their points are greater than the max points
                        let points = cards[0].points + cards[1].points
                        if points > maxPoints {
                            maxPoints = points
                            maxPointsIndex = index
                        }
                    }
                    
                    // Don't check completed sets
                    index = index + 1
                }
                
                if maxPointsIndex > 0 {
                    sortedBySets[maxPointsIndex].append(wilds[0])
                    wilds.remove(at: 0)
                    
                    sortedBySets = sortedBySets.sorted(by: { $0.count < $1.count })
                }
            }
        }
        
        return (sortedBySets, wilds)
    }
    
    func getSortedBySets(hand: [Card]) -> [[Card]] {
        // The current set we're appending to
        var currentSet = [Card]()
        
        // Array of arrays sorted into sets
        var arrayOfSets = [[Card]]()
        
        for card in hand {
            if currentSet.count == 0 {
                // Add the first card to the new set
                currentSet.append(card)
                
            } else if card.name == currentSet[currentSet.count - 1].name {
                // Add card to existing set
                currentSet.append(card)
                
            } else {
                // Add this set to the master array
                arrayOfSets.append(currentSet)
                
                // Start a new set
                currentSet = [Card]()
                currentSet.append(card)
            }
        }
        
        return arrayOfSets
    }
}
