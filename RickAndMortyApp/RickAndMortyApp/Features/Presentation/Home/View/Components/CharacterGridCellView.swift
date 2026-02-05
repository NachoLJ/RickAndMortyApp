//
//  CharacterGridCellView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 2/2/26.
//

import SwiftUI

struct CharacterGridCellView: View {
    let item: CharacterRowModel
    let imageLoader: ImageLoader
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RemoteImageView(loader: imageLoader, contentMode: .fill)
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

// MARK: - Preview

#Preview {
    let mockRepository = PreviewImageRepository()
    let mockLoader = ImageLoader(
        url: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"),
        repository: mockRepository
    )
    
    return CharacterGridCellView(
        item: .init(
            id: 1,
            name: "Rick Sanchez",
            statusText: "Alive",
            speciesText: "Human",
            imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        ),
        imageLoader: mockLoader,
        onTap: {}
    )
    .frame(width: 170, height: 255)
    .padding()
}

private struct PreviewImageRepository: ImageRepositoryProtocol {
    func fetchImageData(from url: URL) async throws -> Data {
        // Return empty data for preview
        Data()
    }
}

