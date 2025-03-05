//
//  EmptyView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 05/03/25.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        ContentUnavailableView("Empty Clothes",
                               systemImage: "tshirt.fill",
                               description: Text("There are no clothes in your list. Start by uploading your clothes images!"))
    }
}

//#Preview {
//    EmptyView()
//}
