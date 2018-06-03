//
//  Player.swift
//  PayMe
//
//  Created by Maggie Casale on 5/30/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation

class Player {
    var name: String = ""
    var position: Int = 0
    var hand: [Card] = [Card]()
    
    convenience init(position: Int) {
        self.init()
        self.position = position
    }
}
