import SwiftUI

@main
struct AuthTestAppApp: App {
	var body: some Scene {
		WindowGroup {
			NavigationStack {
				HomeView()
			}
			.environment(\.colorScheme, .dark)
		}
	}
}
