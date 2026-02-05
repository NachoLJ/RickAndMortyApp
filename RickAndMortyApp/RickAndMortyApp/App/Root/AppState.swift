//
//  AppState.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import Foundation
import Combine

/// Global state that defines which flow the app should show.
@MainActor
final class AppState: ObservableObject {
    enum AppFlow: Equatable {
        case splash
        case main
    }
    
    @Published var flow: AppFlow = .splash
}
