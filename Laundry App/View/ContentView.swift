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
    @State var laundry: [LaundryImage] = []
    
    let gridItems: [GridItem] = Array.init(repeating: GridItem(.flexible(minimum: (UIScreen.main.bounds.width / 3) - 16, maximum: (UIScreen.main.bounds.width / 3) - 16)), count: 3)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    if laundry.isEmpty {
                        ContentUnavailableView("Empty Clothes", systemImage: "tshirt.fill", description: Text("There are no clothes in your list. Start by uploading your clothes images!"))
                    } else {
                        LazyVGrid(columns: gridItems, spacing: 20) {
                            ForEach(laundry) { item in
                                LaundryGridView(laundry: item) {
                                    Task(priority: .background) {
                                        let cache = CachedDataHandler(modelContainer: modelContext.container)
                                        laundry = await cache.fetchChecked()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Laundry")
            .task(priority: .background) {
                let cache = CachedDataHandler(modelContainer: modelContext.container)
                laundry = await cache.fetchChecked()
            }
        }
        .toolbar(.visible, for: .tabBar)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LaundryImage.self, inMemory: true)
}
