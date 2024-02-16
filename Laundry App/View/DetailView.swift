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
    @State var laundryData: LaundryImage?
    
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var selectedImage: Data?
    
    var body: some View {
        VStack {
            if let selectedImage, let image = UIImage(data: selectedImage) {
                Image(uiImage: image)
                    .resizable()
                    .cornerRadius(12)
                    .padding()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    if let image = laundryData?.image {
                        ForEach(image, id: \.self) { item in
                            if let imageView = UIImage(data: item)?.jpegData(compressionQuality: 0.2) {
                                Image(uiImage: UIImage(data: imageView)!)
                                    .resizable()
                                    .frame(width: 130, height: 90)
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        selectedImage = item
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
            Task {
                for item in selectedImages {
                    if let imageData = try? await item.loadTransferable(type: Data.self) {
                        laundryData?.image.append(imageData)
                    } else {
                        print("Failed")
                    }
                }
            }
        }
        .navigationTitle("Clothes Detail")
        .navigationBarTitleDisplayMode(.inline)
        .tabViewStyle(.page)
        .onAppear {
            let fetchDescriptor = FetchDescriptor<LaundryImage>()

            do {
                let laundry = try modelContext.fetch(fetchDescriptor)
                laundryData = laundry.first(where: { $0 == item })
                selectedImage = laundryData?.image[0]
            } catch {
                print("Failed to load Laundry model.")
            }
        }
    }
}

//#Preview {
//    DetailView()
//}
