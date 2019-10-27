//
//  Data.swift
//  Chessboard
//
//  Copyright © 2019 Kleanthis Gkergki. All rights reserved.
//

import UIKit


struct Data {
    let name: String?
    var selected: Bool = false
    let color: UIColor?
    
    init(name: String, selected: Bool, color: UIColor) {
        self.name = name
        self.selected = selected
        self.color = color
    }
}
