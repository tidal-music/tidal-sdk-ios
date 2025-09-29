import AVFAudio

// MARK: - AudioInfoProvider

struct AudioInfoProvider {
    var isBluetoothOutputRoute: () -> Bool
    var isAirPlayOutputRoute: () -> Bool
    var isCarPlayOutputRoute: () -> Bool
    var currentOutputPortName: () -> String?
}

extension AudioInfoProvider {
	#if !os(macOS)
    static let live = AudioInfoProvider(
        isBluetoothOutputRoute: {
            let outputs = AVAudioSession.sharedInstance().currentRoute.outputs
            return outputs.contains { output in
                output.portType == .bluetoothA2DP ||
                output.portType == .bluetoothLE ||
                output.portType == .bluetoothHFP
            }
        },
        isAirPlayOutputRoute: {
            !AVAudioSession.sharedInstance().currentRoute.outputs.filter { $0.portType == .airPlay }.isEmpty
        },
        isCarPlayOutputRoute: {
            !AVAudioSession.sharedInstance().currentRoute.outputs.filter { $0.portType == .carAudio }.isEmpty
        },
        currentOutputPortName: {
            let audioSession = AVAudioSession.sharedInstance()
            return audioSession.standarisedNameForPortType(audioSession.currentRoute.outputs.first?.portType)
        }
    )
#else
    static let live = AudioInfoProvider(
        isBluetoothOutputRoute: { false },
        isAirPlayOutputRoute: { false },
        isCarPlayOutputRoute: { false },
        currentOutputPortName: { "" }
    )
#endif
}

#if !os(macOS)
	private extension AVAudioSession {
		// swiftlint:disable cyclomatic_complexity
		func standarisedNameForPortType(_ portType: AVAudioSession.Port?) -> String? {
			guard let portType else {
				return "NA"
			}

			switch portType {
			// Output only ports
			case Port.airPlay:
				return "AIRPLAY"
			case Port.bluetoothA2DP:
				return "BLUETOOTH"
			case Port.bluetoothLE:
				return "BLUETOOTH_LE"
			case Port.builtInReceiver:
				return "BUILT_IN_RECEIVER"
			case Port.builtInSpeaker:
				return "BUILT_IN_SPEAKER"
			case Port.headphones:
				return "HEADPHONES"
			case Port.lineOut:
				return "LINE_OUT"
			// Input-Output ports
			case Port.bluetoothHFP:
				return "BLUETOOTH_HANDS_FREE"
			case Port.carAudio:
				return "CAR_AUDIO"
			case Port.usbAudio:
				return "USB_AUDIO"
			default:
				if #available(iOS 14.0, *) {
					switch portType {
					// Output only ports
					case Port.HDMI:
						return "HDMI"
					// Input-Output ports
					case Port.AVB:
						return "AVB_DEVICE"
					case Port.displayPort:
						return "DISPLAY_PORT"
					case Port.PCI:
						return "PCI"
					case Port.fireWire:
						return "FIREWIRE"
					case Port.thunderbolt:
						return "THUNDERBOLT"
					case Port.virtual:
						return "VIRTUAL"
					default:
						return portType.rawValue
					}
				} else {
					return portType.rawValue
				}
			}
		}
		// swiftlint:enable cyclomatic_complexity
	}
#endif
