//
//  SetWildSorting.swift
//  PayMe
//
//  Created by Maggie Casale on 6/9/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

class SetWildSorting: NSObject {
    
    func makeSetsFromWilds(hand: [Card], wilds: [Card]) -> (sortedBySets: [[Card]], wilds: [Card]) {
        var sortedBySets = SetSorting().organizedBySets(hand: hand)
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
                    
                }
                
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
                
                if maxPointsIndex > 0 {
                    sortedBySets[maxPointsIndex].append(wilds[0])
                    wilds.remove(at: 0)
                    
                    sortedBySets = sortedBySets.sorted(by: { $0.count < $1.count })
                }
            }
        }
        
        // Return the sortedBySets and remaning wilds
        return (sortedBySets, wilds)
    }
}
