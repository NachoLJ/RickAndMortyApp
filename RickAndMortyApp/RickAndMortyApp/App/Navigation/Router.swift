//
//  Router.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import SwiftUI
import Combine

@MainActor
protocol RouterProtocol: AnyObject {
    func push(_ route: AppRoute)
    func pop()
    func popToRoot()
    func replace(with route: AppRoute)
    func setRoot(_ route: AppRoute)
}

/// Manages app navigation stack
@MainActor
final class Router: ObservableObject, RouterProtocol {
    @Published var path = NavigationPath()
    
    // MARK: - Navigation
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Replaces current route with new one
    func replace(with route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
    
    /// Resets to root and pushes new route
    func setRoot(_ route: AppRoute) {
        popToRoot()
        push(route)
    }
}
