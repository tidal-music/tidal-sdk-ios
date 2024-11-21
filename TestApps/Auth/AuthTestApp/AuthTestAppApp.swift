import SwiftUI

@main
struct AuthTestAppApp: App {
	var body: some Scene {
		WindowGroup {
			NavigationView {
				HomeView()
			}
			.environment(\.colorScheme, .dark)
		}
	}
}
