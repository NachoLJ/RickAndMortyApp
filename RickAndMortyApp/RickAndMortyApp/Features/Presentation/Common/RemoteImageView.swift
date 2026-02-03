//
//  RemoteImageView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 3/2/26.
//

import SwiftUI

struct RemoteImageView: View {

    let url: URL?

    @StateObject private var loader = ImageLoader()

    var body: some View {
        content
            .onAppear { loader.load(from: url) }
            .onDisappear { loader.cancel() }
    }

    @ViewBuilder
    private var content: some View {
        switch loader.state {
        case .idle, .loading:
            placeholder

        case .success(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()

        case .failure:
            placeholder
        }
    }

    private var placeholder: some View {
        ZStack {
            Color.secondary.opacity(0.15)
            Text("IMG")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
