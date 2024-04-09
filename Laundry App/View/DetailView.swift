//
//  DetailView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 16/02/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    var item: LaundryImage
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State var images: [Data] = []
    
    @State private var loadedImage: [UIImage] = []
    
    var body: some View {
        VStack {
            TabView {
                if !loadedImage.isEmpty {
                    ForEach(loadedImage, id: \.self) { item in
                        Image(uiImage: item)
                            .resizable()
                            .frame(height: UIScreen.main.bounds.height / 1.6)
                            .cornerRadius(12)
//                                .overlay {
//                                    VStack {
//                                        HStack {
//                                            Spacer()
//
//                                            Image(systemName: "minus.circle.fill")
//                                                .foregroundStyle(.red)
//                                        }
//
//                                        Spacer()
//                                    }
//                                }
                            .padding(.bottom, 32)
                    }
                } else {
                    ProgressView()
                }
            }
            .tabViewStyle(.page)
            .padding()
            .padding(.bottom)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                PhotosPicker(selection: $selectedImages, photoLibrary: .shared()) {
                    Image(systemName: "plus")
                }
            }
        }
        .onChange(of: selectedImages) {
            Task(priority: .background) {
                for item in selectedImages {
                    if let imageData = try? await item.loadTransferable(type: Data.self) {
                        var image = LaundryData(imageData: LaundryImage(image: imageData))
                        self.item.otherImages?.append(image)
                        self.images.append(imageData)
                    } else {
                        print("Failed")
                    }
                }
            }
        }
        .navigationTitle("Clothes Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            images.removeAll()
            addToImage(image: item.image)
            
            if let imagesData = item.otherImages {
                imagesData.forEach { item in
                    addToImage(image: item.imageData.image)
                }
            }
            
            images.forEach { image in
                loadImage(data: image)
            }
        }
    }
    
    private func loadImage(data: Data) {
        Task {
            if let uiImage = UIImage(data: data) {
                let resizedImage = await uiImage.downsample(to: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), scale: 0.7)
                loadedImage.append(resizedImage!)
            }
        }
    }
    
    func addToImage(image: Data) {
        images.append(image)
    }
}

//#Preview {
//    DetailView()
//}

struct ImageSelectedView: View {
    @Binding var selectedImage: Data
    
    var body: some View {
        if let image = UIImage(data: selectedImage), let resized = image.downsample(to: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), scale: 0.8) {
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
            ContentUnavailableView("No Images yet", systemImage: "plus.rectangle.on.folder.fill", description: Text("Please add some images to serve as your clothes prove."))
        }
    }
}
