import AVFoundation
import Foundation

protocol VideoPlayer {
	func renderVideo(in view: AVPlayerLayer)
}
