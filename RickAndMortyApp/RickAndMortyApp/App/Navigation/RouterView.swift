//
//  RouterView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import SwiftUI

/// View builder that maps AppRoute to actual SwiftUI views
struct RouterView: View {
    let route: AppRoute
    @EnvironmentObject private var container: AppContainer
    
    var body: some View {
        switch route {
        case .characterDetail(let id):
            CharacterDetailView(
                viewModel: container.makeCharacterDetailViewModel(characterId: id)
            )
        }
    }
}
