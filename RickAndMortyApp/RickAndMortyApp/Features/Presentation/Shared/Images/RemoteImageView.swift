//
//  RemoteImageView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 3/2/26.
//

import SwiftUI

//struct RemoteImageView: View {
//
//    @StateObject private var loader: ImageLoader
//
//    init(loader: @autoclosure @escaping () -> ImageLoader) {
//        _loader = StateObject(wrappedValue: loader())
//    }
//
//    var body: some View {
//        ZStack {
//            if let image = loader.image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFill() // ✅ rellena el frame del padre
//            } else if loader.isLoading {
//                Color.secondary.opacity(0.12)
//                ProgressView()
//            } else {
//                Color.secondary.opacity(0.12)
//                Image(systemName: loader.error == nil ? "photo" : "photo.badge.exclamationmark")
//                    .foregroundStyle(.secondary)
//            }
//        }
////        .frame(maxWidth: .infinity, maxHeight: .infinity) // ✅ importantísimo
//        .clipped()                                        // ✅ recorte correcto
//        .task { loader.load() }
//        .onDisappear { loader.cancel() }
//    }
//}




struct RemoteImageView: View {

    @StateObject private var loader: ImageLoader
    let contentMode: ContentMode

    init (loader: @autoclosure @escaping () -> ImageLoader, contentMode: ContentMode = .fill) {
        _loader = StateObject(wrappedValue: loader())
        self.contentMode = contentMode
    }

    var body: some View {
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode) 
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()

            } else if loader.isLoading {
                Color.secondary.opacity(0.10)
                ProgressView()

            } else {
                Color.secondary.opacity(0.12)
                Image(systemName: loader.error == nil ? "photo" : "photo.badge.exclamationmark")
                    .foregroundStyle(.secondary)
            }
        }
        .clipped()
        .onAppear { loader.load() }
        .onDisappear { loader.cancel() }
    }
}



//import SwiftUI
//
//struct RemoteImageView: View {
//    
//    @StateObject private var loader: ImageLoader
//    let contentMode: ContentMode
//    
//    init(loader: @autoclosure @escaping () -> ImageLoader, contentMode: ContentMode = .fill) {
//        _loader = StateObject(wrappedValue: loader())
//        self.contentMode = contentMode
//    }
//    
//    var body: some View {
//        GeometryReader { proxy in
//            ZStack {
//                if let image = loader.image {
//                    Image(uiImage: image)
//                        .resizable()
//                        .aspectRatio(contentMode: contentMode)
//                        .frame(width: proxy.size.width, height: proxy.size.height)
//                        .clipped()
//                        .transition(.opacity)
//                } else if loader.isLoading {
//                    Color.clear
//                        .frame(width: proxy.size.width, height: proxy.size.height)
//                        .background(Color.secondary.opacity(0.1))
//                        .overlay(
//                            ProgressView()
//                                .progressViewStyle(.circular)
//                                .tint(.secondary)
//                        )
//                } else if loader.error != nil {
//                    Color.secondary.opacity(0.12)
//                        .frame(width: proxy.size.width, height: proxy.size.height)
//                        .overlay(
//                            Image(systemName: "photo")
//                                .imageScale(.large)
//                                .foregroundStyle(.secondary)
//                        )
//                } else {
//                    Color.secondary.opacity(0.12)
//                        .frame(width: proxy.size.width, height: proxy.size.height)
//                }
//            }
//            .frame(width: proxy.size.width, height: proxy.size.height)
//            .clipped()
//        }
//        .onAppear { loader.load() }
//        .onDisappear { loader.cancel() }
//    }
//}
//
//#Preview {
//    RemoteImageView(loader: ImageLoader(url: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"), repository: DefaultImageRepository(networkClient: DefaultNetworkClient())))
//        .frame(width: 160, height: 200)
//        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//        .padding()
//}


