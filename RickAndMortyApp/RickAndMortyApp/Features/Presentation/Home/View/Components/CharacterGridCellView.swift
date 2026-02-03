//
//  CharacterGridCellView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import SwiftUI

struct CharacterGridCellView: View {
    
    let item: CharacterRowModel
    let onTap: () -> Void
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Imagen
            RemoteImageView(url: item.imageURL)
            
            // Overlay nombre
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.55),
                        Color.black.opacity(0.0)
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .foregroundStyle(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onTapGesture { onTap() }
        .shadow(radius: 4, y: 2)
    }
}

#Preview {
    CharacterGridCellView(
        item: .init(
            id: 1,
            name: "Rick Sanchez",
            statusText: "Alive",
            speciesText: "Human",
            imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        ),
        onTap: {}
    )
    .frame(width: 170, height: 240)
    .padding()
}
