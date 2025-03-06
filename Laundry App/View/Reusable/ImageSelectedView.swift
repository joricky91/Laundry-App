//
//  ImageSelectedView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 06/03/25.
//

import SwiftUI

struct ImageSelectedView: View {
    @Binding var selectedImage: Data
    
    var body: some View {
        if let image = UIImage(data: selectedImage),
            let resized = image.downsample(imageURL: URL(string: "")!, to: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), scale: 0.8) {
            Image(uiImage: resized)
                .resizable()
                .cornerRadius(12)
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(.red)
                        }
                        
                        Spacer()
                    }
                }
                .padding()
        } else {
            ContentUnavailableView("No Images yet",
                                   systemImage: "plus.rectangle.on.folder.fill",
                                   description: Text("Please add some images to serve as your clothes prove."))
        }
    }
}

//#Preview {
//    ImageSelectedView()
//}
