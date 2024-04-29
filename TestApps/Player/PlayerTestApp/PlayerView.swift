import SwiftUI

struct PlayerView: View {
	@ObservedObject var viewModel = PlayerViewModel()

	var body: some View {
		VStack {
			Text("Player state = \(viewModel.playerState.rawValue)")
			Button("Play", action: {
				viewModel.play()
			}).padding()
				.disabled(viewModel.playerState == PlayerState.PLAYING)
		}
		.alert(isPresented: $viewModel.showAlert, error: viewModel.error) {
			Button("OK") {
				viewModel.showAlert = false
			}
		}
		.padding()
	}
}

#Preview {
	PlayerView()
}
