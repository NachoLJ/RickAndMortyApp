//
//  SplashView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        Image("SplashImage")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                appState.flow = .main
            }
    }
}

// MARK: - Preview

#Preview {
    SplashView()
        .environmentObject(AppState())
}
