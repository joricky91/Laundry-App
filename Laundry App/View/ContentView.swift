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
    
    @State private var avatarItem: [PhotosPickerItem] = []
    
    let gridItems: [GridItem] = Array.init(repeating: GridItem(.flexible(minimum: (UIScreen.main.bounds.width / 2) - 20, maximum: (UIScreen.main.bounds.width / 2) - 20)), count: 2)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if laundry.isEmpty {
                        ContentUnavailableView("Empty Laundry", systemImage: "washer.fill", description: Text("No clothes currently in laundry"))
                    } else {
                        LazyVGrid(columns: gridItems, spacing: 20) {
                            ForEach(laundry) { item in
                                if let image = UIImage(data: item.image) {
                                    ImageView(image: image, isChecked: item.isChecked) {
                                        updateItem(item: item)
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("Clothes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    if items.isEmpty {
                        ContentUnavailableView("Empty Clothes", systemImage: "tshirt.fill", description: Text("There are no clothes in your list. Start by uploading your clothes images!"))
                    } else {
                        LazyVGrid(columns: gridItems, spacing: 20) {
                            ForEach(items) { item in
                                if let image = UIImage(data: item.image) {
                                    ImageView(image: image, isChecked: item.isChecked) {
                                        updateItem(item: item)
                                    }
                                }
                            }
                        }
                    }
                    
                    PhotosPicker(selection: $avatarItem, photoLibrary: .shared()) {
                        HStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Text("Upload Image")
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 12)
                                
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width / 2.3)
                            .background(Color.blue)
                            .cornerRadius(8)
                            
                            Spacer()
                        }
                    }
                }
                .onChange(of: avatarItem) {
                    Task {
                        for item in avatarItem {
                            if let imageData = try? await item.loadTransferable(type: Data.self) {
                                addItem(data: imageData)
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

    private func addItem(data: Data) {
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
