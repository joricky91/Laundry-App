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
    var image: Data
    
    init(image: Data) {
        self.image = image
    }
}
