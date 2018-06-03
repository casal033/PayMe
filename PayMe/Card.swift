//
//  Card.swift
//  PayMe
//
//  Created by Maggie Casale on 5/30/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation
import UIKit

enum Suit: String {
    case spades = "♠"
    case hearts = "♥"
    case diamonds = "♦"
    case clubs = "♣"
    case blackJoker, redJoker = "JOKER"
}

enum Name: String {
    case ace = "A"
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
    case blackJoker = "RJOKER"
    case redJoker = "BJOKER"
}

class Card {
    var suit: Suit = .hearts
    var name: Name = .two
    
    var order: Int {
        switch name {
        case .ace: return 0
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
        case .blackJoker: return 14
        case .redJoker: return 15
        }
    }
    
    var points: Int {
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
        case .blackJoker: return 0
        case .redJoker: return 0
        }
    }
    
    var image: UIImage {
        switch suit {
        case .spades:
            return UIImage(named: String(format: "%@S", name.rawValue))!
        case .hearts:
            return UIImage(named: String(format: "%@H", name.rawValue))!
        case .diamonds:
            return UIImage(named: String(format: "%@D", name.rawValue))!
        case .clubs:
            return UIImage(named: String(format: "%@C", name.rawValue))!
        case .blackJoker:
            return UIImage(named: name.rawValue)!
        case .redJoker:
            return UIImage(named: name.rawValue)!
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
