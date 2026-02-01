//
//  AppRootView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import SwiftUI

struct AppRootView: View {
    
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        Group {
            switch appState.flow {
            case .splash:
                SplashView()
            case .main:
                MainFlowView()
            }
        }
    }
}

#Preview {
    AppRootView()
}
