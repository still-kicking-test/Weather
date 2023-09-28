//
//  SettingsView.swift
//  Weather
//
//  Created by jonathan saville on 13/09/2023.
//

import SwiftUI

enum SettingsRow: Int {
    case notifications
    case customise
    case advertisements
    case acknowledgements
    case privacy
    case email
    case call
    case contact
    case footer
    
    var description: String {
        switch self {
        case .notifications: return "Notifications"
        case .customise: return "Customize your view"
        case .advertisements: return "Remove ads"
        case .acknowledgements: return "Acknowledgements"
        case .privacy: return "Manage your privacy settings"
        case .email: return "Email us"
        case .call: return "Call us"
        case .contact: return "Weather is not supported by a 24-hour helpline. If you would like to let us know about any issues you are experiencing with the app, or provide us with feedback, please do not contact us."
        case .footer: return "Privacy policy"
        }
    }

    var imageName: String? {
        switch self {
        case .notifications: return "bell.fill"
        case .customise: return "thermometer.medium"
        case .advertisements: return "star.circle"
        case .privacy: return "slider.horizontal.3"
        case .email: return "envelope.fill"
        case .call: return "phone.fill"
        case .acknowledgements, .contact, .footer: return nil
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var pathStore = PathStore()

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let rows: [SettingsRow] = [.notifications, .customise, .advertisements, .acknowledgements, .privacy, .email, .call, .contact, .footer]
    
    var body: some View {

        NavigationStack(path: $pathStore.path) {
            ZStack {
                Color.black.ignoresSafeArea()
                
                List(rows, id: \.self) { row in
                    switch row {
                    case .notifications, .customise, .advertisements, .acknowledgements:
                        NavigationLink(value: row.rawValue) {
                            SettingsRowView(row: row)
                        }
                        .settingsRowModifier()
                        
                    case .privacy, .email, .call:
                        SettingsRowView(row: row)
                        .settingsRowModifier(foregroundColor: Color(UIColor.button(for: .highlighted)))
                    
                    case .contact:
                        SettingsRowView(row: row)
                        .settingsRowModifier(separatorTint: .clear)
                        
                    case .footer:
                        HStack {
                            Text("Version \(appVersion ?? "")")
                            Spacer()
                            Text(row.description)
                                .foregroundColor(Color(UIColor.button(for: .highlighted)))
                                .overlay(NavigationLink(value: row.rawValue) { EmptyView() })
                        }
                        .settingsRowModifier(font: .footnote, separatorTint: .clear)
                    }
                }
                .navigationDestination(for: Int.self) { i in
                    switch i {
                    case SettingsRow.notifications.rawValue: NotificationsView().environmentObject(pathStore)
                    case SettingsRow.customise.rawValue: CustomizeView().environmentObject(pathStore)
                    case SettingsRow.advertisements.rawValue: RemoveAdsView().environmentObject(pathStore)
                    case SettingsRow.acknowledgements.rawValue: AcknowledgementsView().environmentObject(pathStore)
                    case SettingsRow.footer.rawValue: PrivacyPolicyView().environmentObject(pathStore)
                    default: EmptyView()
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.inset)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Settings")
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close", role: .cancel) {
                        dismiss()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}

// Still working on the usage of this
class PathStore: ObservableObject {
    @Published var path = [Int]() // { didSet { print("set path \(path)") } }
}
