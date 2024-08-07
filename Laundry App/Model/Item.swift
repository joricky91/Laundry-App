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
    @Attribute(.externalStorage) var image: Data
    var otherImages: [LaundryData]?
    var isChecked: Bool
    var isMainImage: Bool
    
    init(image: Data, isChecked: Bool = false, isMainImage: Bool = false) {
        self.image = image
        self.isChecked = isChecked
        self.isMainImage = isMainImage
    }
}

@Model
final class LaundryData {
    var imageData: LaundryImage
    
    init(imageData: LaundryImage) {
        self.imageData = imageData
    }
}
