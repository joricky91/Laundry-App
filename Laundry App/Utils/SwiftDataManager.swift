//
//  SwiftDataManager.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 05/03/25.
//

import SwiftData
import SwiftUI

class SwiftDataManager {
    
    static let shared = SwiftDataManager()
    
    func addToLocal(context: ModelContext, item: LaundryImage) {
        do {
            context.insert(item)
            try context.save()
        } catch {
            print("❌ Failed to save image paths in SwiftData: \(error)")
        }
    }
    
    func updateItem(context: ModelContext, action: (() -> Void)?) {
        action?()
        
        do {
            try context.save()
        } catch {
            print("❌ Failed to update item: \(error)")
        }
    }
    
    func deleteItem(context: ModelContext, item: LaundryImage) {
        withAnimation {
            context.delete(item)
        }
        
        do {
            try context.save()
        } catch {
            print("❌ Failed to delete item: \(error)")
        }
    }
    
}
