//
//  SearchBarView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    let placeholder: String
    let onClear: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.primary)
            
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onClear()
                    isFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Color(.systemGray6)
                .opacity(0.8)
        )
        .cornerRadius(50)
    }
}

#Preview {
    VStack {
        SearchBarView(
            text: .constant(""),
            placeholder: "Search by name",
            onClear: {}
        )
        
        SearchBarView(
            text: .constant("Rick"),
            placeholder: "Search by name",
            onClear: {}
        )
    }
    .padding()
}
