//
//  RemoteImageView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 3/2/26.
//

import SwiftUI

struct RemoteImageView: View {

    @StateObject private var loader: ImageLoader
    let contentMode: ContentMode

    init(loader: @autoclosure @escaping () -> ImageLoader, contentMode: ContentMode = .fill) {
        _loader = StateObject(wrappedValue: loader())
        self.contentMode = contentMode
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = loader.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()

                } else if loader.isLoading {
                    Color.secondary.opacity(0.10)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    ProgressView()

                } else {
                    Color.secondary.opacity(0.12)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    Image(systemName: loader.error == nil ? "photo" : "photo.badge.exclamationmark")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .clipped()
        .onAppear { loader.load() }
        .onDisappear { loader.cancel() }
    }
}

#Preview {
    let mockRepository = PreviewImageRepository()
    let mockLoader = ImageLoader(
        url: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"),
        repository: mockRepository
    )
    
    return RemoteImageView(loader: mockLoader)
        .frame(width: 160, height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding()
}

// Mock repository for previews
private struct PreviewImageRepository: ImageRepositoryProtocol {
    func fetchImageData(from url: URL) async throws -> Data {
        Data()
    }
}
