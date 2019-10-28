//
//  Position.swift
//  Chessboard
//
//  Created by Marsel Tzatzo on 27/10/2019.
//  Copyright © 2019 Kleanthis Gkergki. All rights reserved.
//

import Foundation

struct Position {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func isEqual(to position: Position) -> Bool {
        if self.x == position.x && self.y == position.y {
            return true
        }
        return false
    }
}
