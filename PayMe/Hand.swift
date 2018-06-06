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
    func getTotalPointsBasedOnSets(hand: [Card], wild: Name) -> Int {
        var nonSetCards = [Card]()
        for arrayOfCards in self.organizedBySets(hand:hand) {
            if arrayOfCards.count < 3 {
                for card in arrayOfCards {
                    nonSetCards.append(card)
                }
            }
        }
        
        return self.getPointsForRunsInHand(hand: nonSetCards, wild: wild)
    }
    
    // Makes a new hand with all runs removed, then returns the
    // points of the remaining hand with all sets removed
    func getTotalPointsBasedOnRuns(hand: [Card], wild: Name) -> Int {
        var nonRunCards = [Card]()
        for arrayOfCards in self.organizedByRuns(hand:hand, wild: wild) {
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
    func getPointsForRunsInHand(hand: [Card], wild: Name) -> Int {
        var points = 0
        for arrayOfCards in self.organizedByRuns(hand: hand, wild: wild) {
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
        let result: (wilds: [Card], hand: [Card]) = removeWildsFromHand(wild: wild, hand: hand)
        let hand = result.hand
        var wilds = result.wilds
        
        let currentData: [[Card]] = getRunData(hand: hand) // Starting Data to comb through
        var currentRunIndex = 0 // Index of a current unique run to append a card
        
        var runsSortedByCount = [[Card]]() // Array of sorted runs
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
        var uniqueRuns = runsSortedByCount.filter({ $0.count > 2 }).sorted(by: { $0.count < $1.count })

        // Loop through the partial runs with 1 or 2 cards
        for runArray in runsSortedByCount.filter({ $0.count <= 2 }).sorted(by: { $0.count < $1.count }) {
            
            // Loop through the partial run
            var notMoved = [Card]()
            for card in runArray {
                
                // Try and find a run to add the current card
                var index = 0
                var added = false
                while index < uniqueRuns.count {
                    var uniqueRun = uniqueRuns[index]
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
                    uniqueRuns = runsSortedByCount.filter({ $0.count > 2 }).sorted(by: { $0.count < $1.count })
                }
            }

            // If cards weren't removed from the array
            if notMoved.count > 0 {
                remainingCards.append(notMoved) // Add the not moved cards
            }
        }

        // Add wilds to remaining cards to lessen as many points as possible
        while wilds.count > 0 {
            
            var twoCardPoints = false
            var maxPoints = 0
            var remainingCardIndex = 0
            var maxArrayIndex = 0
            var uniqueRunMaxArrayIndex = 0

            for addedCards in remainingCards {
                // Get the total points for each opportunity to add a wild
                var points = 0
                
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
                    for uniqueRun in uniqueRuns {
                        
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
                    
                    remainingCardIndex = remainingCardIndex + 1
                }
                
                if maxPoints > 0 {
                    
                    // Max points was in a pair
                    if twoCardPoints {
                        
                        // Grab the partial run from remaining cards
                        var newRun = remainingCards[maxArrayIndex]
                        
                        // Move wild from wilds array and append it to the new run
                        newRun.append(wilds[0])
                        wilds.remove(at: 0)
                        
                        // Move the new run from remaining cards and add it to the unique runs
                        uniqueRuns.append(newRun)
                        remainingCards.remove(at: maxArrayIndex)
                        
                        // Max points was with a signle card
                    } else {
                        
                        // Grab the card arrays from remaining cards & unique runs
                        var addedCards = remainingCards[maxArrayIndex]
                        var uniqueRun = uniqueRuns[uniqueRunMaxArrayIndex]

                        if uniqueRun.first!.order - 2 == addedCards[0].order {
                            // Insert the single card to the begining of the unique run array
                            // Insert wild into the second postion of the run array
                            uniqueRun.insert(addedCards[0], at: 0)
                            uniqueRun.insert(wilds[0], at: 1)

                        } else if uniqueRun.last!.order + 2 == addedCards[0].order {
                            // Append the wild & single card to the end of the unique array
                            uniqueRun.append(wilds[0])
                            uniqueRun.append(addedCards[0])
                        }

                        // Remove wild from wilds array
                        wilds.remove(at: 0)
                        
                        // Remove the single card array from remaining cards
                        remainingCards.remove(at: maxArrayIndex)
                    }
                }
            }
        }
    
        // Add the two final arrrays together and return
        for runArray in remainingCards {
            runsSortedByCount.append(runArray)
        }
        
        return runsSortedByCount
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
