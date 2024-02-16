//
//  Item.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 15/02/24.
//

import Foundation
import SwiftData

@Model
final class LaundryImage {
    var image: [Data]
    var isChecked: Bool
    
    init(image: [Data], isChecked: Bool = false) {
        self.image = image
        self.isChecked = isChecked
    }
}
