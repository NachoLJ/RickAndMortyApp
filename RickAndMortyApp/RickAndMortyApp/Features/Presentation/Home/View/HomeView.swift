//
//  HomeView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel
    @EnvironmentObject private var container: AppContainer
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // DI initializer (for tests, previews, container)
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .navigationTitle(viewModel.state.title)
            .toolbar { toolbarContent() }
            .alert(item: $viewModel.alertError) { alertError in
                Alert(
                    title: Text(alertError.title),
                    message: Text(alertError.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .task {
                viewModel.onAppear()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state.content {
        case .loading:
            loadingView
        case .loaded(let items):
            loadedView(items: items)
        case .error(let message):
            errorView(message: message)
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadedView(items: [CharacterRowModel]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    characterCell(item: item)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
    
    private func characterCell(item: CharacterRowModel) -> some View {
        CharacterGridCellView(
            item: item,
            imageLoader: container.makeImageLoader(url: item.imageURL),
            onTap: {
                viewModel.didSelectCharacter(id: item.id)
            }
        )
        .aspectRatio(0.75, contentMode: .fill)
        .clipped()
        .onAppear {
            viewModel.loadNextPageIfNeeded(currentItemID: item.id)
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Button("Retry") {
                viewModel.retry()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // TODO: filter/sort
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .accessibilityLabel("Filter and sort")
        }
    }
}

#Preview {
    let router = Router()
    return NavigationStack {
        HomeView(viewModel: HomeViewModel(fetchCharactersUseCase: PreviewFetchCharactersUseCase(), router: router))
            .environmentObject(AppContainer())
    }
}

private struct PreviewFetchCharactersUseCase: FetchCharactersUseCaseProtocol {
    func execute(query: CharactersQuery) async throws -> CharactersPageEntity {
        CharactersPageEntity(
            items: [
                CharacterEntity(
                    id: 1,
                    name: "Rick Sanchez",
                    status: .alive,
                    species: "Human",
                    gender: .male,
                    imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
                ),
                CharacterEntity(
                    id: 2,
                    name: "Morty Smith",
                    status: .alive,
                    species: "Human",
                    gender: .male,
                    imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")!
                )
            ],
            nextPage: 2
        )
    }
}
