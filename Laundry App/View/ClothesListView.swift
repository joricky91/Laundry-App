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
    @Query var items: [LaundryImage]
    
    @State var presentPhotoPicker: Bool = false
    @State private var selectedImages: [PhotosPickerItem] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if items.isEmpty {
                        EmptyView()
                    } else {
                        GridView(items: items) { item in
                            toggleSelection(item: item)
                        } deleteAction: { item in
                            deleteItem(item: item)
                        }
                    }
                }
                .onChange(of: selectedImages) {
                    Task(priority: .background) {
                        await handleSelectedImages()
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
            .photosPicker(isPresented: $presentPhotoPicker,
                          selection: $selectedImages,
                          photoLibrary: .shared())
        }
        .toolbar(.visible, for: .tabBar)
    }
}

//#Preview {
//    ClothesListView()
//}

extension ClothesListView {
    
    internal func toggleSelection(item: LaundryImage) {
        withAnimation {
            item.isChecked.toggle()
        }
        
        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to save toggle state: \(error)")
        }
    }
    
    internal func deleteItem(item: LaundryImage) {
        withAnimation {
            modelContext.delete(item)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("❌ Failed to delete item: \(error)")
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
                    let newItem = LaundryImage(imagePath: filename,
                                               isMainImage: true)
                    saveToLocal(item: newItem)
                } catch {
                    print("❌ Failed to save image: \(error)")
                }
            } else {
                print("❌ Failed to load image data")
            }
        }
        
        selectedImages.removeAll()
    }
    
    internal func saveToLocal(item: LaundryImage) {
        do {
            modelContext.insert(item)
            try modelContext.save()
        } catch {
            print("❌ Failed to save image paths in SwiftData: \(error)")
        }
    }
    
}
