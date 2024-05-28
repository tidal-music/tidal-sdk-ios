import SwiftUI

// MARK: - HomeView

struct HomeView: View {
	var body: some View {
		VStack {
			Image("tidal", bundle: .main)
				.resizable()
				.frame(width: 100.0, height: 100.0)
				.padding()

			NavigationLink {
				AuthView()
			} label: {
				Text("Sign In")
					.padding()
			}
		}
		.navigationTitle("Auth App")
	}
}

#Preview {
	HomeView()
}

extension UINavigationController {
	override open func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		navigationBar.topItem?.backButtonDisplayMode = .minimal
	}
}
