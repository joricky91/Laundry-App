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
    @Query private var items: [LaundryImage]
    
    @State private var avatarItem: PhotosPickerItem?
    
    let gridItems: [GridItem] = Array.init(repeating: GridItem(.flexible(minimum: (UIScreen.main.bounds.width / 2) - 20, maximum: (UIScreen.main.bounds.width / 2) - 20)), count: 2)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    LazyVGrid(columns: gridItems, spacing: 20) {
                        ForEach(items) { item in
                            if let image = UIImage(data: item.image) {
                                ImageView(image: image, isChecked: item.isChecked) {
                                    updateItem(item: item)
                                }
                            } else {
                                ContentUnavailableView("No saved images yet", systemImage: "heart")
                            }
                        }
                    }
                    
                    PhotosPicker(selection: $avatarItem, photoLibrary: .shared()) {
                        HStack {
                            Spacer()
                            
                            Text("Upload Image")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                                .padding(.vertical, 8)
                            
                            Spacer()
                        }
                        .background(Color.blue)
                        .cornerRadius(4)
                        .padding(.horizontal)
                    }
                }
                .onChange(of: avatarItem) {
                    Task {
                        if let imageData = try? await avatarItem?.loadTransferable(type: Data.self) {
                            addItem(data: imageData)
                        } else {
                            print("Failed")
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
