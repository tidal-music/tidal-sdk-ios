# ``Player``

The TIDAL Player client for iOS.

The Player module encapsulates the playback functionality of TIDAL media products. The implementation uses Apple's `AVPlayer` as the media player. Check [AVPlayer](https://developer.apple.com/documentation/avfoundation/avplayer). 

## Features
* Streaming and playing TIDAL catalog content.
* Core playback functionality.
* Media streaming, caching and error handling. 
* Automatic management of playback session event reporting.
 
## Documentation

* Read the [documentation](https://github.com/tidal-music/tidal-sdk/blob/main/Player.md) for a detailed overview of the player functionality.
* Check the [API documentation](https://tidal-music.github.io/tidal-sdk-ios/player/index.html) for the module classes and methods.
* Visit our [TIDAL Developer Platform](https://developer.tidal.com/) for more information and getting started. 

## Usage

### Install via Swift Package file

Add the dependency to your existing `Package.swift` file.
```swift
dependencies: [
    .package(url: "https://tidal-music.github.io/tidal-sdk-ios", from: "<VERSION>"))
]
```

### Install via Swift Package Manager with Xcode

1. Select `"File » Add Packages Dependencies..."` and enter the repository URL `https://github.com/tidal-music/tidal-sdk-ios` into the search bar (top right).
2. Set the Dependency Rule to `"Up to next major"`, and the version number to that you want.
3. When `"Choose Package Products for tidal-sdk-ios"` appears, make sure to add Player, Auth and EventProducer at least to your target.

### Playing a TIDAL Track

The Player depends on the [Auth](https://github.com/tidal-music/tidal-sdk-ios/blob/main/auth/README.md) and [EventProducer](https://github.com/tidal-music/tidal-sdk-ios/tree/main/Sources/EventProducer) modules for authentication and event reporting handling. For detailed instructions on how to set them up, please refer to their guide. 

Here's how to setup the Player and play a TIDAL track:

1. Initialise the Player which depends on a `CredentialsProvider` from the Auth module and an `EventSender` from the EventProducer module.

```Swift
let player = Player.bootstrap(
	listener: self,
	credentialsProvider: TidalAuth.shared,
	eventSender: TidalEventSender.shared
)
```

2. Load and play a `MediaProduct` track.
```Swift
player.load(
	MediaProduct(
		productType: ProductType.TRACK,
		productId: "PRODUCT_ID"
	)
)
player.play()
```

3. The listener passed in the bootstrap process will receive the [player events](https://github.com/tidal-music/tidal-sdk-ios/blob/main/Sources/Player/Common/Event/PlayerListener.swift) callbacks for the `PlayerListener` delegate.
```swift
let player = Player.bootstrap(
    ..
    listener: self,
    ..
)

extension ViewModel: PlayerListener {
	func stateChanged(to state: State) {
		print("New player state: \(state)")
	}
}
```

## Running the Test App
The player module includes a [test app](https://github.com/tidal-music/tidal-sdk-ios/tree/main/TestsApps/Player) that demonstrates how to setup the player and showcases its different functionalities.

As a prerequisite for the player to work, the client is required to be authenticated. You can learn more about the authentication flows in the [Auth module](https://github.com/tidal-music/tidal-sdk-ios/blob/main/Sources/Auth#client-credentials). Note that currently only the `Client Credentials` flow is publicly supported. This enables the test app to play 30-second tracks previews. Full length playback is only enabled when the client is authenticated through `Device Login` or `Authorization Code Flow`.

In order to run the test app, please declare your client credentials in the `PlayerViewModel` class:

```swift
private let CLIENT_ID = "YOUR_CLIENT_ID"
private let CLIENT_SECRET = "YOUR_CLIENT_SECRET"
```

**Note**: you can obtain the `client id` and `client secret` after signing up and creating an application in the [TIDAL Developer Platform](https://developer.tidal.com/). 


## Topics

### Player

- ``Player``
- ``Configuration``
