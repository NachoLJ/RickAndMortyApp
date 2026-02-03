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
    @EnvironmentObject private var container: AppContainer
    
    var body: some View {
        ZStack(alignment: .bottom) {

            RemoteImageView(loader: container.makeImageLoader(url: item.imageURL), contentMode: .fill)
            overlay
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 4, y: 2)
        .onTapGesture { onTap() }
    }

    private var overlay: some View {
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

