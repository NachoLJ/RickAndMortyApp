//
//  MainFlowView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import SwiftUI

struct MainFlowView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject private var router = Router()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView(viewModel: container.makeHomeViewModel(router: router))
                .navigationDestination(for: AppRoute.self) { route in
                    RouterView(route: route)
                }
        }
        .environmentObject(router)
    }
}

// MARK: - Preview

#Preview {
    MainFlowView()
        .environmentObject(AppContainer())
}
