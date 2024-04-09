//
//  CachedDataHandler.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 25/03/24.
//

import SwiftUI
import SwiftData

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
