//
//  ContentView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 15/02/24.
//

import SwiftUI
import SwiftData
import PhotosUI

@ModelActor
actor CachedDataHandler {
    func persist(items: [LaundryImage]) {
        items.forEach { modelContext.insert($0) }
        try? modelContext.save()
    }
    
    func updateItem(item: LaundryImage) {
        withAnimation {
            item.isChecked.toggle()
        }
    }
    
    func fetchChecked() -> [LaundryImage] {
        let fetchRequest = FetchDescriptor<LaundryImage>(predicate: #Predicate { item in
            item.isChecked
        })
        var data: [LaundryImage] = []
        
        if let fetched = try? modelContext.fetch(fetchRequest) {
            data = fetched
            return data
        }
        
        return []
    }
    
    func fetch() -> [LaundryImage] {
        let fetchRequest = FetchDescriptor<LaundryImage>()
        var data: [LaundryImage] = []
        
        if let fetched = try? modelContext.fetch(fetchRequest) {
            data = fetched
            return data
        }
        
        return []
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
            let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
            let format = imageRendererFormat
            format.opaque = isOpaque
            return UIGraphicsImageRenderer(size: canvas, format: format).image {
                _ in draw(in: CGRect(origin: .zero, size: canvas))
            }
        }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var laundry: [LaundryImage] = []
    
    let gridItems: [GridItem] = Array.init(repeating: GridItem(.flexible(minimum: (UIScreen.main.bounds.width / 3) - 16, maximum: (UIScreen.main.bounds.width / 3) - 16)), count: 3)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
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
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LaundryImage.self, inMemory: true)
}
