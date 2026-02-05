//
//  FilterSheetView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 4/2/26.
//

import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var filters: CharactersFilters
    @State private var localFilters = CharactersFilters()

    let onApply: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Status") {
                    statusPicker
                }
                
                Section("Gender") {
                    genderPicker
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        filters = localFilters
                        onApply()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .safeAreaInset(edge: .bottom) {
                resetButton
            }
        }
        .onAppear {
            localFilters = filters
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Components
    
    private var statusPicker: some View {
        Picker("Status", selection: $localFilters.status) {
            Text("All").tag(nil as CharacterStatus?)
            ForEach(CharacterStatus.allCases, id: \.self) { status in
                Text(status.rawValue.capitalized).tag(status as CharacterStatus?)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var genderPicker: some View {
        Picker("Gender", selection: $localFilters.gender) {
            Text("All").tag(nil as CharacterGender?)
            ForEach(CharacterGender.allCases, id: \.self) { gender in
                Text(gender.rawValue.capitalized).tag(gender as CharacterGender?)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var resetButton: some View {
        Button(action: {
            localFilters.resetFilters()
            filters = localFilters
            onApply()
            dismiss()
        }) {
            Text("Reset Filters")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6).opacity(0.5))
                .foregroundStyle(.primary)
                .cornerRadius(16)
        }
        .padding()
        .disabled(!localFilters.hasFilters)
    }
}

// MARK: - Preview

#Preview {
    FilterSheetView(
        filters: .constant(CharactersFilters()),
        onApply: {}
    )
}
