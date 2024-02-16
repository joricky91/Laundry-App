//
//  PhotosPickerLabel.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 16/02/24.
//

import SwiftUI

struct PhotosPickerLabel: View {
    var body: some View {
        HStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Text("Upload Image")
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                    .padding(.vertical, 12)
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width / 2.3)
            .background(Color.blue)
            .cornerRadius(8)
            
            Spacer()
        }
    }
}

#Preview {
    PhotosPickerLabel()
}
