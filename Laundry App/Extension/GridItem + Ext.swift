//
//  GridItem + Ext.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 05/03/25.
//

import SwiftUI

extension GridItem {
    static func gridItems() -> [GridItem] {
        return Array.init(repeating: GridItem(.flexible(minimum: (UIScreen.main.bounds.width / 3) - 16, maximum: (UIScreen.main.bounds.width / 3) - 16)), count: 3)
    }
}
