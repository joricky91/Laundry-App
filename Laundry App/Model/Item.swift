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
    var imagePath: String
    var otherImages: [LaundryData]?
    var isChecked: Bool
    var isMainImage: Bool
    
    init(imagePath: String, isChecked: Bool = false, isMainImage: Bool = false) {
        self.imagePath = imagePath
        self.isChecked = isChecked
        self.isMainImage = isMainImage
    }
    
    var imageURL: URL? {
        URL(fileURLWithPath: imagePath)
    }
}

@Model
final class LaundryData {
    var imageData: LaundryImage
    
    init(imageData: LaundryImage) {
        self.imageData = imageData
    }
}
