//
//  FilterSortView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import SwiftUI

struct FilterSortView: View {
    var body: some View {
        NavigationStack {
            Text("Filter & Sort")
                .navigationTitle("Filter & Sort")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FilterSortView()
}
