import Auth
import SwiftUI

struct AuthView: View {
	@StateObject var viewModel: AuthViewModel = AuthViewModel()
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

	var body: some View {
		VStack {
			HStack {
				Spacer()
				Toggle("Is Device Logging enabled: ", isOn: $viewModel.isDeviceLoginEnabled)
					.toggleStyle(SwitchToggleStyle(tint: Color("cyanBase", bundle: .main)))
					.padding()
			}
			HStack {
				Spacer()
				Text("**Status:** \(viewModel.isLoggedIn ? "Authorized" : "Not authorized")")
					.padding(.horizontal)
			}
			loginActionButtons
				.padding(.top, 48.0)
		}
		.navigationBarTitle("Sign In", displayMode: .inline)
		.onReceive(timer) { _ in
			viewModel.updateTimer()
		}
	}

	private var loginActionButtons: some View {
		NavigationView {
			VStack(spacing: 20.0) {
				if !viewModel.isLoggedIn, viewModel.isDeviceLoginEnabled {
					if viewModel.userCode.isEmpty {
						Button("Device Login") {
							viewModel.initializeDeviceLogin()
						}
					} else {
						VStack {
							Text(viewModel.userCode)
								.font(.title)
								.foregroundColor(.white)
								.kerning(8)
								.padding(5.0)
							Text("Expires in: \(viewModel.expiresIn)")
								.padding(.bottom, 5.0)
								.font(.system(size: 16, design: .monospaced))
						}
						.padding()
						.background(.white.opacity(0.1))
						.clipShape(.rect(cornerRadius: 16.0))
						.overlay(
							RoundedRectangle(cornerRadius: 16.0)
								.inset(by: 0.5) // inset value should be same as lineWidth in .stroke
								.stroke(.white, lineWidth: 0.5)
						)
					}
				}

				if !viewModel.isLoggedIn, !viewModel.isDeviceLoginEnabled {
					Button("Login") {
						viewModel.initializeLogin()
					}
				}

				if viewModel.isLoggedIn {
					Button("Logout") {
						viewModel.logout()
					}
				}

				Spacer()

				Text(viewModel.errorMessage)
					.font(.title3)
					.foregroundStyle(.red)
			}
		}
	}
}

#Preview {
	AuthView(viewModel: AuthViewModel())
		.environment(\.colorScheme, .dark)
}
