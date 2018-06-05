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
    // THIS IS BUILT WITH A MAXIMUM OF THREE DECKS BEING USED
    func organizedByRuns(hand: [Card], wild: Name) -> [[Card]] {
        
        let currentData: [[Card]] = getRunData(hand: hand) // Starting / Current Data to comb through
        var currentRunIndex = 0 // Index of a current unique run to append a card
        
        var sortedRuns = [[Card]]() // Array of sorted runs
        var remainingCards = [[Card]]() // Array of cards that couldn't be placed in a run
        
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
                if sortedRuns.count == 0 {
                    sortedRuns[currentRunIndex] = [card]
                    
                } else if sortedRuns[currentRunIndex].last!.order <= card.order {
                    // Update the run index
                    currentRunIndex = getCurrentRunIndex(sortedRuns: sortedRuns, card: card, currentRunIndex: currentRunIndex)
                    
                    var currentRun = sortedRuns[currentRunIndex] // Grab the current run
                    currentRun.append(card) // Append this card
                    sortedRuns[currentRunIndex] = currentRun // Update the sortedRuns array
                }
            }
        }
        
        // Handle wild cards
        var wilds = [Card]()
        var index = 0
        while index < remainingCards.count {
            
            var newRunArray = [Card]()
            for card in remainingCards[index] {
                if card.name == wild || card.name == .redJoker || card.name == .blackJoker {
                    wilds.append(card)
                } else {
                    newRunArray.append(card)
                }
            }
            
            // Update the array in case we removed a wild
            remainingCards[index] = newRunArray
            
            index = index + 1
        }
        
        while wilds.count > 0 {
            // Find the most points
            var maxPoints = 0
            var maxArray = [Card]()
            for runArray in remainingCards {
                // Only check if there's at least 2 cards in an array
                if runArray.count > 2 {
                    var points = 0
                    for card in runArray {
                        points = points + card.points
                    }
                    
                    if points > maxPoints {
                        
                    }

                }
            }

        }

        // Add the two final arrrays together and return
        for runArray in remainingCards {
            sortedRuns.append(runArray)
        }
        
        return sortedRuns
    }
    
    func getCurrentRunIndex(sortedRuns: [[Card]], card: Card, currentRunIndex: Int) -> Int {
        // Loop through our added ordered runs, backwards
        var index = sortedRuns.count - 1
        while index > -1 { // Include 0 for 1st position
            
            // If an added run has the same suit and this card can be appended to
            // the added run, add it and update the run index to this run's index
            let lastCard = sortedRuns[index].last!
            if lastCard.suit == card.suit && lastCard.order < card.order && index <= currentRunIndex {
                return index
            }

            index = index - 1
        }
        
        // There wasn't an available run, start a new one
        return sortedRuns.count
    }
    
    func getRunData(hand: [Card]) -> [[Card]] {
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
