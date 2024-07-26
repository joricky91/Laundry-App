//
//  CachedDataHandler.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 25/03/24.
//

import SwiftUI
import SwiftData

@MainActor
class CachedDataHandler {
    
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func persist(items: [LaundryImage]) async {
        // Ensure all operations on modelContext are within this method.
        for item in items {
            modelContext.insert(item)
        }
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func updateItem(item: LaundryImage) async {
        item.isChecked.toggle()
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func deleteItem(item: LaundryImage) async {
        modelContext.delete(item)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func fetchChecked() async -> [LaundryImage] {
        let fetchRequest = FetchDescriptor<LaundryImage>(predicate: #Predicate { $0.isChecked })
        do {
            return try modelContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch checked items: \(error)")
            return []
        }
    }

    func fetch() async -> [LaundryImage] {
        let fetchRequest = FetchDescriptor<LaundryImage>()
        do {
            return try modelContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch items: \(error)")
            return []
        }
    }
}
