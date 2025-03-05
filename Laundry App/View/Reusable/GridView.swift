//
//  GridView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 05/03/25.
//

import SwiftUI

struct GridView: View {
    let items: [LaundryImage]
    var buttonAction: ((LaundryImage) -> Void)?
    var deleteAction: ((LaundryImage) -> Void)?
    
    var body: some View {
        LazyVGrid(columns: GridItem.gridItems(), spacing: 20) {
            ForEach(items) { item in
                if item.isMainImage {
                    LaundryGridView(laundry: item) {
                        buttonAction?(item)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            deleteAction?(item)
                        } label: {
                            Label("Delete Cloth", systemImage: "trash")
                        }
                    }
                } else {
                    LaundryGridView(laundry: item) {
                        buttonAction?(item)
                    }
                }
            }
        }
    }
}

//#Preview {
//    GridView()
//}
