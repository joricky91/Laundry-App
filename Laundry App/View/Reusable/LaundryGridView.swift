//
//  LaundryGridView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 16/02/24.
//

import SwiftUI

struct EmptyContentData {
    var title: String
    var systemImageName: String
    var description: String
}

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
                        updateItem(item: laundry)
                        action?()
                    }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        Task {
            if let uiImage = UIImage(data: laundry.image) {
                let resizedImage = await uiImage.downsample(to: CGSize(width: (UIScreen.main.bounds.width / 3) - 16, height: (UIScreen.main.bounds.width / 2.5)), scale: 0.7)
                loadedImage = resizedImage
            }
        }
    }
    
    private func updateItem(item: LaundryImage) {
        withAnimation {
            item.isChecked.toggle()
        }
    }
}


//#Preview {
//    LaundryGridView()
//}
