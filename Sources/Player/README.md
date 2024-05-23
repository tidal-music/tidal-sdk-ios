# Player

The TIDAL Player client for iOS.

The Player module encapsulates the playback functionality of TIDAL media products. The implementation uses Apple's `AVPlayer` as the media player. Check [AVPlayer](https://developer.apple.com/documentation/avfoundation/avplayer).
 
## Features
* Streaming and playing TIDAL catalog content.
* Core playback functionality.
* Media streaming, caching and error handling. 
* Automatic management of playback session event reporting.
 
## Documentation

* Read the [documentation](https://github.com/tidal-music/tidal-sdk/blob/main/Player.md) for a detailed overview of the player functionality.
* Check the [API documentation](https://tidal-music.github.io/tidal-sdk-ios/documentation/player/) for the module classes and methods.
* Visit our [TIDAL Developer Platform](https://developer.tidal.com/) for more information and getting started. 

## Usage

### Install via Swift Package file

Add the dependency to your existing `Package.swift` file.
```Swift
dependencies: [
    .package(url: "https://tidal-music.github.io/tidal-sdk-ios", from: "1.0.0"))
]
```

### Install via Swift Package Manager with Xcode

1. Select `"File » Add Packages Dependencies..."` and enter the repository URL `https://github.com/tidal-music/tidal-sdk-ios` into the search bar (top right).
2. Set the Dependency Rule to `"Up to next major"`, and the version number to that you want. 
3. When `"Choose Package Products for tidal-sdk-ios"` appears, make sure to add both Player and Auth at least to your target.

### Playing a TIDAL Track

The Player depends on the [Auth](https://github.com/tidal-music/tidal-sdk-ios/blob/main/auth/README.md) module for authentication. For detailed instructions on how to set it up, please refer to its guide. 

Here's how to setup the Player and play a TIDAL track:

1. The Player needs a `TidalAuth` instance from the Auth module in its bootstrapping process. It is required that the client is authenticated in order to start playing. 
In the case of the [Client Credentials](https://github.com/tidal-music/tidal-sdk-ios/blob/main/Sources/Auth#client-credentials) authentication flow, this can be done by configuring an `AuthConfig` object, and calling `config(authConfig)` on the `TidalAuth` instance.

```Swift
let authConfig = AuthConfig(
    clientId: CLIENT_ID,
    clientSecret: CLIENT_SECRET,
    credentialsKey: "storage",
    scopes: Scopes(),
    enableCertificatePinning: false
)

do {
  try auth.config(config: authConfig)
} catch {
  print("Error configuring auth, error=\(error)")
}
```

2. Create the Player and start playing.
```Swift
var player = Player.bootstrap(
    accessTokenProvider: DefaultAccessTokenProvider(),
    clientToken: CLIENT_ID,
    listener: self,
    listenerQueue: DispatchQueue.main,
    featureFlagProvider: FeatureFlagProvider(isStallWhenTransitionFromEndedToBufferingEnabled: { return true }),
    authProvider: auth
)

var mediaProduct = MediaProduct(ProductType.TRACK, "PRODUCT_ID")
player.load(mediaProduct)
player.play()
```

3. The listener passed in the bootstrap process will receive the [player events](https://github.com/tidal-music/tidal-sdk-ios/blob/main/Sources/Player/Common/Event/PlayerListener.swift) callbacks for the `PlayerListener` delegate.
```Swift
var player = Player.bootstrap(
    ..
    listener: self,
    listenerQueue: DispatchQueue.main,
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

```
private let CLIENT_ID = "YOUR_CLIENT_ID"
private let CLIENT_SECRET = "YOUR_CLIENT_SECRET"
```

> [!NOTE]  
> You can obtain the `CLIENT_ID` and `CLIENT_SECRET` after signing up and creating an application in the [TIDAL Developer Platform](https://developer.tidal.com/).
