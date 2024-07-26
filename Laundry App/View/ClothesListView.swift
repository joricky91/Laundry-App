//
//  ClothesListView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 19/02/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ClothesListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var items: [LaundryImage] = []
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var imageDataItems: [LaundryImage] = []
    
    @State var showLoading: Bool = false
    @State var shouldFetch: Bool = true
    @State var presentPhotoPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if showLoading {
                        LazyVStack {
                            ProgressView()
                        }
                    } else {
                        LazyVStack {
                            if items.isEmpty {
                                ContentUnavailableView("Empty Clothes", systemImage: "tshirt.fill", description: Text("There are no clothes in your list. Start by uploading your clothes images!"))
                            } else {
                                GridView(items: $items) { item in
                                    Task(priority: .background) {
                                        let cache = CachedDataHandler(modelContext: modelContext)
                                        await cache.deleteItem(item: item)
                                        items = await cache.fetch()
                                    }
                                }
                            }
                        }
                    }
                }
                .onChange(of: selectedImages) {
                    Task(priority: .background) {
                        await handleSelectedImages()
                        
                        let cache = CachedDataHandler(modelContext: modelContext)
                        await cache.persist(items: imageDataItems)
                        items = await cache.fetch()
                    }
                }
                .task(priority: .background) {
                    if shouldFetch {
                        let cache = CachedDataHandler(modelContext: modelContext)
                        showLoading = true
                        items = await cache.fetch()
                        showLoading = false
                        shouldFetch = false
                    }
                }
            }
            .navigationTitle("Clothes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentPhotoPicker = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .photosPicker(isPresented: $presentPhotoPicker, selection: $selectedImages, photoLibrary: .shared())
        }
        .toolbar(.visible, for: .tabBar)
    }
    
    internal func handleSelectedImages() async {
        for item in selectedImages {
            if let imageData = try? await item.loadTransferable(type: Data.self) {
                let newItem = LaundryImage(image: imageData, isMainImage: true)
                imageDataItems.append(newItem)
            } else {
                print("Failed")
            }
        }
        
        selectedImages.removeAll()
    }
}

//#Preview {
//    ClothesListView()
//}

struct GridView: View {
    let gridItems: [GridItem] = Array.init(repeating: GridItem(.flexible(minimum: (UIScreen.main.bounds.width / 3) - 16, maximum: (UIScreen.main.bounds.width / 3) - 16)), count: 3)
    @Binding var items: [LaundryImage]
    var buttonAction: ((LaundryImage) -> Void)?
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 20) {
            ForEach(items) { item in
                if item.isMainImage {
                    LaundryGridView(laundry: item)
                        .contextMenu {
                            Button {
                                buttonAction?(item)
                            } label: {
                                Text("Delete Cloth")
                            }
                        }
                }
            }
        }
    }
}
