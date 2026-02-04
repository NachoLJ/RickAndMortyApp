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
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                appState.flow = .main
            }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState())
}
