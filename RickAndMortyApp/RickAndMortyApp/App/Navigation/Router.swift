//
//  Router.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import SwiftUI
import Combine

/// Centralized navigation manager using NavigationStack's path
@MainActor
final class Router: ObservableObject {
    
    /// Navigation path that drives the NavigationStack
    @Published var path = NavigationPath()
    
    // MARK: - Navigation Actions
    
    /// Navigate to a new route (push)
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    /// Go back one screen (pop)
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Go back to root screen (pop to root)
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Replace current screen with a new route
    func replace(with route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
    
    /// Navigate to a specific route, removing all others
    func setRoot(_ route: AppRoute) {
        popToRoot()
        push(route)
    }
}
