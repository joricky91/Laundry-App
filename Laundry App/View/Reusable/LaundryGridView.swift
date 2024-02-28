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
    @Bindable var laundry: LaundryImage

    let gridItems: [GridItem] = Array.init(repeating: GridItem(.flexible(minimum: (UIScreen.main.bounds.width / 3) - 16, maximum: (UIScreen.main.bounds.width / 3) - 16)), count: 3)
    var action: (() -> Void)?
    
    var body: some View {
        if let image = UIImage(data: laundry.image)?.resized(withPercentage: 0.3) {
            VStack(spacing: 8) {
                NavigationLink(destination: DetailView(item: laundry)) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(height: (UIScreen.main.bounds.width / 3) - 16)
                        .cornerRadius(8)
                }
                
                Image(systemName: laundry.isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(laundry.isChecked ? .blue : .white)
                    .onTapGesture {
                        updateItem(item: laundry)
                        action?()
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
