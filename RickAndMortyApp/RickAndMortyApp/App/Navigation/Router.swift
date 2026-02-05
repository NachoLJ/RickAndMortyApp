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
    
    func replace(with route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
    
    func setRoot(_ route: AppRoute) {
        popToRoot()
        push(route)
    }
}
