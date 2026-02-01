//
//  HomeView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Home")
            .navigationTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: button action
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    .accessibilityLabel("Filter and sort")
                }
            }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
