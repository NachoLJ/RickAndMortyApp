//
//  HomeView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 1/2/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel: HomeViewModel
    
    // Default initializer (creates its own VM)
    @MainActor
    init() {
        _viewModel = StateObject(wrappedValue: HomeViewModel())
    }
    
    // DI initializer (for tests, previews, container)
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .navigationTitle(viewModel.state.title)
            .toolbar { toolbarContent() }
            .sheet(
                isPresented: Binding(
                    get: { viewModel.state.isFilterSheetPresented },
                    set: { isPresented in
                        if !isPresented { viewModel.didDismissFilterSheet() }
                    }
                )
            ) {
                FilterSortView()
            }
            .task {
                viewModel.onAppear()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state.content {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let items):
            GeometryReader { geometry in
                let spacing: CGFloat = 14
                let horizontalPadding: CGFloat = 16
                
                let availableWidth = geometry.size.width - (
                    horizontalPadding * 2
                ) - spacing
                let cellWidth = availableWidth / 2
                let cellHeight = cellWidth * 1.35
                
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.fixed(cellWidth), spacing: spacing),
                            GridItem(.fixed(cellWidth), spacing: spacing)
                        ],
                        spacing: spacing
                    ) {
                        ForEach(items) { item in
                            CharacterGridCellView(item: item, onTap: {
                                //TODO: Implementar navegacion
                            })
                            .frame(width: cellWidth, height: cellHeight)
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                }
            }
            
        case .error(let message):
            VStack(spacing: 12) {
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                Button("Retry") {
                    viewModel.retry()
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // TODO: filter/sort
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
            .accessibilityLabel("Filter and sort")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
