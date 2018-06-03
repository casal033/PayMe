//
//  Card.swift
//  PayMe
//
//  Created by Maggie Casale on 5/30/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

enum Suit: String {
    case spades = "♠"
    case hearts = "♥"
    case diamonds = "♦"
    case clubs = "♣"
    case joker = "JOKER"
}

enum Name: String {
    case ace = "A"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case jack = "J"
    case queen = "Q"
    case king = "K"
    case joker = "JOKER"
}

class Card {
    var suit: Suit = .hearts
    var name: Name = .two
    
    var order: Int {
        switch name {
        case .ace: return 0
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .jack: return 11
        case .queen: return 12
        case .king: return 13
        case .joker: return 14
        }
    }
    
    var points: Int {
        switch name {
        case .ace: return 15
        case .one: return 1
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
        case .joker: return 0
        }
    }
    
    convenience init(suit: Suit, name: Name) {
        self.init()
        self.suit = suit
        self.name = name
    }
    
    func isEqualTo(otherCard: Card) -> Bool {
        if name == otherCard.name && suit == otherCard.suit {
            return true
        }
        
        return false
    }
}
