//
//  LaundryGridView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 16/02/24.
//

import SwiftUI

struct EmptyContentData {
    var title: String
    var systemImageName: String
    var description: String
}

struct LaundryGridView: View {
    var laundry: [LaundryImage]
    var emptyContentData: EmptyContentData
    
    let gridItems: [GridItem] = Array.init(repeating: GridItem(.flexible(minimum: (UIScreen.main.bounds.width / 2) - 20, maximum: (UIScreen.main.bounds.width / 2) - 20)), count: 2)
    
    var body: some View {
        if laundry.isEmpty {
            ContentUnavailableView(emptyContentData.title, systemImage: emptyContentData.systemImageName, description: Text(emptyContentData.description))
        } else {
            LazyVGrid(columns: gridItems, spacing: 20) {
                ForEach(laundry) { item in
                    if let image = UIImage(data: item.image) {
                        VStack(spacing: 8) {
                            NavigationLink(destination: DetailView(item: item)) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(height: (UIScreen.main.bounds.width / 2) - 20)
                                    .cornerRadius(8)
                            }
                            
                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(item.isChecked ? .blue : .white)
                                .onTapGesture {
                                    updateItem(item: item)
                                }
                        }
                    }
                }
            }
        }
    }
    
    private func updateItem(item: LaundryImage) {
        withAnimation {
            item.isChecked.toggle()
        }
    }
}

//#Preview {
//    LaundryGridView()
//}
