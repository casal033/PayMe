//
//  CardView.swift
//  PayMe
//
//  Created by Maggie Casale on 6/2/18.
//  Copyright © 2018 Maggie Casale. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIImageView {
    var card: Card!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(card: Card) {
        self.card = card

        super.init(frame: CGRect(x: 0, y: 0, width: card.image.size.width, height: card.image.size.height))
    }
}
