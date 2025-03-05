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
    @Query(filter: #Predicate<LaundryImage> { $0.isChecked })
    var laundry: [LaundryImage]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    if laundry.isEmpty {
                        EmptyView()
                    } else {
                        GridView(items: laundry) { item in
                            toggleSelection(item: item)
                        } deleteAction: { item in
                            deleteItem(item: item)
                        }
                    }
                }
            }
            .navigationTitle("Laundry")
        }
        .toolbar(.visible, for: .tabBar)
    }
    
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
}

//#Preview {
//    ContentView()
//        .modelContainer(for: LaundryImage.self, inMemory: true)
//}
