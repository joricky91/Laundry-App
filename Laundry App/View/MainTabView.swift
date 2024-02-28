//
//  MainTabView.swift
//  Laundry App
//
//  Created by Jonathan Ricky Sandjaja on 19/02/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Laundry", systemImage: "washer")
                }
            
            ClothesListView()
                .tabItem {
                    Label("Clothes", systemImage: "tshirt")
                }
        }
    }
}

#Preview {
    MainTabView()
}
