//
//  LaundryGridView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 16/02/24.
//

import SwiftUI

struct LaundryGridView: View {
    @Bindable var laundry: LaundryImage
    var action: (() -> Void)?
    
    @State private var loadedImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 8) {
            if let image = loadedImage {
                NavigationLink(destination: DetailView(item: laundry)) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(height: (UIScreen.main.bounds.width / 3.5))
                        .cornerRadius(8)
                }
                
                Image(systemName: laundry.isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(laundry.isChecked ? .blue : .white)
                    .onTapGesture {
                        action?()
                    }
            } else {
                ProgressView()
                    .task {
                        loadImage(path: laundry.imagePath,
                                  width: UIScreen.main.bounds.width / 3,
                                  height: UIScreen.main.bounds.width / 3,
                                  scale: 0.7) { image in
                            self.loadedImage = image
                        }
                    }
            }
        }
    }
}


//#Preview {
//    LaundryGridView()
//}
