//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import SwiftUI

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    @EnvironmentObject private var container: AppContainer
    
    init(viewModel: CharacterDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadCharacter()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .loaded(let character):
            loadedView(character: character)
        case .error(let message):
            errorView(message: message)
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
            Text("Loading character...")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
        }
    }
    
    private func loadedView(character: CharacterEntity) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // Image
                RemoteImageView(loader: container.makeImageLoader(url: character.imageURL))
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8)
                    .padding(.horizontal)
                
                // Name
                Text(character.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                // Status
                statusBadge(character.status)
                
                // Details
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(label: "Species", value: character.species)
                    DetailRow(label: "Gender", value: character.gender.displayName)
                    Divider()
                    DetailRow(label: "Origin", value: character.origin)
                    DetailRow(label: "Last location", value: character.location)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
                // Episodes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Episodes (\(character.episodes.count))")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    episodesGrid(episodes: character.episodes)
                }
                .padding(.bottom)
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
    
    private func statusBadge(_ status: CharacterStatus) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(status.color)
                .frame(width: 8, height: 8)
            
            Text(status.displayName)
                .font(.headline)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(status.color.opacity(0.2))
        .clipShape(Capsule())
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundStyle(.orange)
            
            Text("Error loading")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                Task {
                    await viewModel.retry()
                }
            }) {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func episodesGrid(episodes: [Int]) -> some View {
        let columns = [
            GridItem(.adaptive(minimum: 60), spacing: 8)
        ]
        
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(episodes, id: \.self) { episodeNumber in
                Text("E\(episodeNumber)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Extensions

private extension CharacterStatus {
    var color: Color {
        switch self {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .gray
        }
    }
    
    var displayName: String {
        switch self {
        case .alive:
            return "Alive"
        case .dead:
            return "Dead"
        case .unknown:
            return "Unknown"
        }
    }
}

private extension CharacterGender {
    var displayName: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .genderless:
            return "Genderless"
        case .unknown:
            return "Unknown"
        }
    }
}

#Preview {
    let mockRepo = PreviewCharacterDetailRepository()
    let useCase = FetchCharacterByIdUseCase(repository: mockRepo)
    let viewModel = CharacterDetailViewModel(characterId: 1, fetchCharacterUseCase: useCase)
    
    return NavigationStack {
        CharacterDetailView(viewModel: viewModel)
            .environmentObject(AppContainer())
    }
}

private struct PreviewCharacterDetailRepository: CharacterDetailRepositoryProtocol {
    func fetchCharacter(id: Int) async throws -> CharacterEntity {
        CharacterEntity(
            id: id,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            gender: .male,
            origin: "Earth (C-137)",
            location: "Citadel of Ricks",
            episodes: Array(1...51),
            imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
        )
    }
}
