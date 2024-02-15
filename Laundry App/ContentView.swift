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

    var body: some View {
        VStack {
            PhotosPicker(selection: $avatarItem, photoLibrary: .shared()) {
                Text("Select a Picture")
            }
            
            ForEach(items) { item in
                if let image = UIImage(data: item.image) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: (UIScreen.main.bounds.width / 2))
                        .padding()
                } else {
                    ContentUnavailableView("No saved images yet", systemImage: "heart")
                }
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

    private func addItem(data: Data) {
        withAnimation {
            let newItem = LaundryImage(image: data)
            modelContext.insert(newItem)
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
