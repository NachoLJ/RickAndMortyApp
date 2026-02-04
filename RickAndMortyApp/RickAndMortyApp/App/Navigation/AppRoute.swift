//
//  AppRoute.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import Foundation

/// Defines all possible navigation destinations in the app
enum AppRoute: Hashable {
    case characterDetail(id: Int)
}
