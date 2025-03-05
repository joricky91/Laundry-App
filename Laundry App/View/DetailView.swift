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
    @State private var isFirstImageLoaded: Bool = false
    
    var body: some View {
        VStack {
            TabView {
                if !loadedImage.isEmpty {
                    ForEach(loadedImage, id: \.self) { item in
                        Image(uiImage: item)
                            .resizable()
                            .frame(height: UIScreen.main.bounds.height / 1.6)
                            .cornerRadius(12)
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
                await handleSelectedImages()
                displayImage()
            }
        }
        .navigationTitle("Clothes Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            displayImage()
        }
    }
    
    func displayImage() {
        if !isFirstImageLoaded {
            loadImage(path: item.imagePath)
            isFirstImageLoaded = true
        }
        
        if let imagesData = item.otherImages {
            imagesData.forEach { item in
                loadImage(path: item.imageData.imagePath,
                          firstImage: false)
            }
        }
    }
    
    internal func handleSelectedImages() async {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory,
                                         in: .userDomainMask).first!
        
        for item in selectedImages {
            if let imageData = try? await item.loadTransferable(type: Data.self) {
                let filename = UUID().uuidString + ".jpg"
                let fileURL = directory.appendingPathComponent(filename)
                
                do {
                    try imageData.write(to: fileURL)
                    let newItem = LaundryData(imageData: LaundryImage(imagePath: filename,
                                                                      isMainImage: true))
                    self.item.otherImages?.append(newItem)
                    save()
                } catch {
                    print("❌ Failed to save image: \(error)")
                }
            } else {
                print("❌ Failed to load image data")
            }
        }
        
        selectedImages.removeAll()
    }
    
    internal func save() {
        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to save image paths in SwiftData: \(error)")
        }
    }

    private func loadImage(path: String, firstImage: Bool = true) {
        Task(priority: .background) {
            let fileManager = FileManager.default
            let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = directory.appendingPathComponent(path)
            
            do {
                let imageData = try Data(contentsOf: fileURL)
                let image = UIImage(data: imageData)
                let width = UIScreen.main.bounds.width / (firstImage ? 1 : 3)
                let height = UIScreen.main.bounds.height / (firstImage ? 1 : 3)
                let resizedImage = image?.downsample(
                    imageURL: fileURL,
                    to: CGSize(width: width, height: height),
                    scale: 1.0
                )
                
                DispatchQueue.main.async {
                    guard let resizedImage else { return }
                    loadedImage.append(resizedImage)
                }
            } catch {
                print("❌ Error loading image: \(error)")
            }
        }
    }
}

//#Preview {
//    DetailView()
//}

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
