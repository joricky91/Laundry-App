//
//  DetailView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 16/02/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    var item: LaundryImage
    @State var laundryData: [LaundryImage] = []
    
    var body: some View {
        VStack {
            TabView {
                ForEach(laundryData, id: \.id) { item in
                    if let image = UIImage(data: item.image) {
                        Image(uiImage: image)
                            .resizable()
                            .cornerRadius(12)
                            .padding()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
            }
        }
        .navigationTitle("Clothes Detail")
        .navigationBarTitleDisplayMode(.inline)
        .tabViewStyle(.page)
        .onAppear {
            let fetchDescriptor = FetchDescriptor<LaundryImage>()

            do {
                let laundry = try modelContext.fetch(fetchDescriptor)
                laundryData = laundry.filter { $0 == item }
            } catch {
                print("Failed to load Laundry model.")
            }
        }
    }
}

//#Preview {
//    DetailView()
//}
