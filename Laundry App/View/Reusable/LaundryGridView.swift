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
                        action?()
                    }
            } else {
                ProgressView()
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    private func loadImage() async {
        Task(priority: .background) {
            let fileManager = FileManager.default
            let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = directory.appendingPathComponent(laundry.imagePath)
            
            do {
                let imageData = try Data(contentsOf: fileURL)
                let image = UIImage(data: imageData)
                let resizedImage = image?.downsample(
                    imageURL: fileURL,
                    to: CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3),
                    scale: 0.7
                )
                
                DispatchQueue.main.async {
                    loadedImage = resizedImage
                }
            } catch {
                print("❌ Error loading image: \(error)")
            }
        }
    }
}


//#Preview {
//    LaundryGridView()
//}
