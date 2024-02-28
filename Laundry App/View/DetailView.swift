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

    @State var selectedImag: [LaundryImage] = []
    var item: LaundryImage
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedImage: Data?
    
    var body: some View {
        VStack {
            if let selected = Binding<Data>($selectedImage) {
                ImageSelectedView(selectedImage: selected)
            }
            
            ScrollView(.horizontal) {
                HStack {
                    if let imagesData = item.otherImages {
                        ForEach(imagesData) { item in
                            if let imageView = UIImage(data: item.imageData.image)?.jpegData(compressionQuality: 0.2) {
                                Image(uiImage: UIImage(data: imageView)!)
                                    .resizable()
                                    .frame(width: 130, height: 90)
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        selectedImage = item.imageData.image
                                    }
                            }
                        }
                    }
                }
            }
            .padding(.leading)
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
                    } else {
                        print("Failed")
                    }
                }
            }
        }
        .navigationTitle("Clothes Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedImage = item.image
        }
    }
}

//#Preview {
//    DetailView()
//}

struct ImageSelectedView: View {
    @Binding var selectedImage: Data
    
    var body: some View {
        if let image = UIImage(data: selectedImage)?.resized(withPercentage: 0.5) {
            Image(uiImage: image)
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
