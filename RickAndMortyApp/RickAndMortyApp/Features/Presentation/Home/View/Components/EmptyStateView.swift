//
//  EmptyStateView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import SwiftUI

struct EmptyStateView: View {
    
    let onClearFilters: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No Characters Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("No characters match your current search or filters.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
            
            Button(action: onClearFilters) {
                Label("Clear All Filters", systemImage: "arrow.counterclockwise")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    EmptyStateView(onClearFilters: {})
}
