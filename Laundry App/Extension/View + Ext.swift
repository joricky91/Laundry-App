//
//  View + Ext.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 06/03/25.
//

import SwiftUI
import PhotosUI

extension View {
    func loadImage(path: String, width: CGFloat, height: CGFloat, scale: Double, completion: ((UIImage) -> Void)?) {
        Task(priority: .background) {
            let fileManager = FileManager.default
            let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = directory.appendingPathComponent(path)
            
            do {
                let imageData = try Data(contentsOf: fileURL)
                let image = UIImage(data: imageData)
                let resizedImage = image?.downsample(
                    imageURL: fileURL,
                    to: CGSize(width: width, height: height),
                    scale: scale
                )
                
                DispatchQueue.main.async {
                    guard let resizedImage else { return }
                    completion?(resizedImage)
                }
            } catch {
                print("❌ Error loading image: \(error)")
            }
        }
    }
}
