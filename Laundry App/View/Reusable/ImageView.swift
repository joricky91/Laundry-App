//
//  ImageView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 15/02/24.
//

import SwiftUI

struct ImageView: View {
    var image: UIImage
    var isChecked: Bool
    var action: (() -> Void)
    
    var body: some View {
        VStack(spacing: 8) {
            Image(uiImage: image)
                .resizable()
                .frame(height: (UIScreen.main.bounds.width / 2) - 20)
                .cornerRadius(8)
            
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isChecked ? .blue : .white)
                .onTapGesture {
                    action()
                }
        }
    }
}

//#Preview {
//    ImageView()
//}
