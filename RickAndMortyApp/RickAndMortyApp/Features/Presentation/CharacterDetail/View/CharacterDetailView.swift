//
//  CharacterDetailView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import SwiftUI
import Combine

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
            Text("Cargando personaje...")
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
                
                // Status & Species
                HStack(spacing: 16) {
                    statusBadge(character.status)
                    Text(character.species)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                
                // Details
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(label: "Género", value: character.gender.displayName)
                    DetailRow(label: "Estado", value: character.status.displayName)
                    DetailRow(label: "Especie", value: character.species)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
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
            
            Text("Error al cargar")
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
                Label("Reintentar", systemImage: "arrow.clockwise")
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
}

// MARK: - Supporting Views

private struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
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
            return "Vivo"
        case .dead:
            return "Muerto"
        case .unknown:
            return "Desconocido"
        }
    }
}

private extension CharacterGender {
    var displayName: String {
        switch self {
        case .male:
            return "Masculino"
        case .female:
            return "Femenino"
        case .genderless:
            return "Sin género"
        case .unknown:
            return "Desconocido"
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
            imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!
        )
    }
}
