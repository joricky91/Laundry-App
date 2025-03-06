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
    
    let manager = SwiftDataManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    if laundry.isEmpty {
                        EmptyView()
                    } else {
                        GridView(items: laundry) { item in
                            manager.updateItem(context: modelContext) {
                                withAnimation {
                                    item.isChecked.toggle()
                                }
                            }
                        } deleteAction: { item in
                            manager.deleteItem(context: modelContext,
                                               item: item)
                        }
                    }
                }
            }
            .navigationTitle("Laundry")
        }
        .toolbar(.visible, for: .tabBar)
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: LaundryImage.self, inMemory: true)
//}
