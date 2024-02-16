//
//  ContentView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 15/02/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<LaundryImage> { laundry in
        laundry.isChecked
    }) var laundry: [LaundryImage]
    
    @Query private var items: [LaundryImage]
    
    @State private var selectedImages: [PhotosPickerItem] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    LaundryGridView(laundry: laundry, emptyContentData: EmptyContentData(title: "Empty Laundry", systemImageName: "washer.fill", description: "No clothes currently in laundry"))
                    
                    Text("Clothes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    LaundryGridView(laundry: items, emptyContentData: EmptyContentData(title: "Empty Clothes", systemImageName: "tshirt.fill", description: "There are no clothes in your list. Start by uploading your clothes images!"))
                    
                    PhotosPicker(selection: $selectedImages, photoLibrary: .shared()) {
                        PhotosPickerLabel()
                    }
                }
                .onChange(of: selectedImages) {
                    Task {
                        for item in selectedImages {
                            if let imageData = try? await item.loadTransferable(type: Data.self) {
                                addItem(data: [imageData])
                            } else {
                                print("Failed")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Laundry")
        }
    }

    private func addItem(data: [Data]) {
        withAnimation {
            let newItem = LaundryImage(image: data)
            modelContext.insert(newItem)
        }
    }
    
    private func updateItem(item: LaundryImage) {
        withAnimation {
            item.isChecked.toggle()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LaundryImage.self, inMemory: true)
}
