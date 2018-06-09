//
//  SetSorting.swift
//  PayMe
//
//  Created by Maggie Casale on 6/9/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

class SetSorting: NSObject {
    
    // Make an array of non set cards
    func getNonSetCards(hand: [Card]) -> [Card] {
        var nonSetCards = [Card]()
        var sortedBySets = SetSorting().organizedBySets(hand: hand)
        while sortedBySets.filter( { $0.count < 3 } ).count > 0 {
            
            // Loop through the array of runs
            var index = 0
            while index < sortedBySets.count {
                
                // If the run has less than 3 cards
                let run = sortedBySets[index]
                if run.count < 3 {
                    for card in run {
                        nonSetCards.append(card)
                    }
                    
                    // Remove partial run from runs array
                    sortedBySets.remove(at: index)
                } else {
                    
                    // Only increment if we're not removing cards
                    index = index + 1
                }
            }
        }
        
        return nonSetCards
    }
    
    // Returns the player's hand organized by sets into an array of sets
    func organizedBySets(hand: [Card]) -> [[Card]] {
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
