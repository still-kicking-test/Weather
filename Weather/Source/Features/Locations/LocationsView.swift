//
//  LocationsView.swift
//  Weather
//
//  Created by jonathan saville on 29/04/2024.
//

import SwiftUI

enum DisplayItem: Hashable, Identifiable {
    var id: Self { self }

    case search
    case showCurrentLocation
    case showVideo
    case location(CDLocation)
    
    var isStatic: Bool {
        switch self {
        case .location(_):
            return false
        default: return true
        }
    }
    static var staticCount = 3 // this must match with isStatic
}

struct LocationsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.injected) private var injected: InteractorContainer
    @Environment(\.dismiss) var dismiss

    @State private var showCurrentLocation: Bool = false
    @State private var showVideo: Bool = false
    @State private var displayItems: [DisplayItem] = []
    @State private var showingSearchAlert = false
    
    private let backgroundColor = Color.navbarBackground

    var body: some View {
        
        NavigationStack() {
            ZStack {
                backgroundColor.ignoresSafeArea()

                List() {
                    ForEach(displayItems, id: \.self) { displayItem in
                        Group {
                            switch displayItem {
                            case .search:
                                HStack() {
                                    Image(systemName: "magnifyingglass")
                                        .font(.defaultFont)
                                    Text("Search & save your places")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.defaultText.opacity(0.6))
                                        .alert(isPresented:$showingSearchAlert) {
                                            Alert(
                                                title: Text("Information"),
                                                message: Text("Location search is not yet implemented. Do you wish to update your locations with the set of test locations?"),
                                                primaryButton: .destructive(Text("Update locations")) {
                                                    injected.interactors.locationsInteractor.loadTestData()
                                                },
                                                secondaryButton: .cancel()
                                            )
                                        }
                                }
                                .background(Color.backgroundPrimary) // ensures onTapGesture is triggered for the whole HStack
                                .onTapGesture { showingSearchAlert = true }
                                
                            case .showCurrentLocation:
                                HStack() {
                                    Toggle(isOn: $showCurrentLocation) {
                                        Text(CommonStrings.currentLocation)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .onChange(of: showCurrentLocation) { _, newValue in
                                        injected.interactors.locationsInteractor.shouldShowCurrentLocation(newValue)
                                    }
                                }
                                
                            case .showVideo:
                                HStack() {
                                    Toggle(isOn: $showVideo) {
                                        Text("UK video forecast")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .onChange(of: showVideo) { _, newValue in
                                        injected.interactors.locationsInteractor.shouldShowVideo(newValue)
                                    }
                                }

                            case .location(let location):
                                HStack(spacing: 12) {
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(.defaultText.opacity(0.6))
                                        .padding(.leading, 4)
                                    Text(location.name)
                                    Spacer()
                                    Image(systemName: "minus.circle.fill")
                                        .padding(.trailing, 12)
                                        .symbolRenderingMode(.multicolor)
                                        .onTapGesture {
                                            injected.interactors.locationsInteractor.deleteLocationFor(location.uuid)
                                        }
                                }
                            }
                        }
                        .tint(.accentColor)
                        .font(.largeFont)
                        .foregroundColor(.defaultText)
                        .padding([.leading, .trailing], 12)
                        .frame(height: 50)
                        .listRowBackground(Color.backgroundGradientTo)// (Color.red)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top:0, leading: 0, bottom: 16, trailing: 0))
                        .displayAsCard()
                        .moveDisabled(displayItem.isStatic)
                    }
                    .onMove { from, to in
                        guard let from = from.first else { return }
                        injected.interactors.locationsInteractor.moveLocationFrom(from - DisplayItem.staticCount,
                                                                                  to: to - DisplayItem.staticCount)
                    }
                }
                .listStyle(.plain)
                .contentMargins(0, for: .scrollContent)
                .scrollContentBackground(.hidden)
                .padding(.top, 8)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbarBackground(backgroundColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        NavBarTitleView()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { dismiss() }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .onAppear() {
                    showVideo = appState.showVideo
                    showCurrentLocation = appState.showCurrentLocation
                    displayItems = appState.displayItems
                }
                .onChange(of: appState.locations) { _, newValue in
                    displayItems = appState.displayItems
                }
            }
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static let appState = AppState()
    
    static var previews: some View {
        LocationsView()
        .preferredColorScheme(.dark)
        .environmentObject(appState)
   }
}

private extension AppState {
    var displayItems: [DisplayItem] {
        var items = [DisplayItem]()
        items.append(.search)
        items.append(.showVideo)
        items.append(.showCurrentLocation)
        locations.forEach { location in
            items.append(.location(location))
        }
        return items
    }
}
