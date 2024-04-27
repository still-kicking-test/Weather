import SwiftUI

struct LocationsWrapperView: View {

    @Environment(\.injected) private var injected: InteractorContainer
    @Environment(\.dismiss) var dismiss

    init() {
        UISwitch.appearance().onTintColor = UIColor(Color.accentColor)
    }

    var body: some View {

        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.backgroundGradientFrom,
                                                           .backgroundGradientTo]), startPoint: .bottom, endPoint: .top)
                .edgesIgnoringSafeArea(.bottom)

                LocationsView()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(Color.navbarBackground, for: .navigationBar)
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
            }
        }
    }
}
