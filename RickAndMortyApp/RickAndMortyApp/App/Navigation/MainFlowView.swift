//
//  MainFlowView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import SwiftUI

struct MainFlowView: View {
    
    @EnvironmentObject private var container: AppContainer
    
    var body: some View {
        NavigationStack {
            HomeView(viewModel: container.makeHomeViewModel())
        }
    }
}

#Preview {
    MainFlowView()
}
