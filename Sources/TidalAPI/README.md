# TidalApi

This module provides easy access to the TIDAL Open API. Read more about it [here](https://developer.tidal.com/apiref?spec=catalogue-v2&ref=get-single-album&at=THIRD_PARTY).

## Features
* Easy access to TIDAL Open API (Catalog data, Search, User, etc)
* Handling of network calls and data parsing
* Automatic generation of TIDAL Open API specs

## Documentation
* Read the [documentation](https://github.com/tidal-music/tidal-sdk/) for a detailed overview of the TIDAL SDK functionalities.
* Check the [API documentation](https://developer.tidal.com/apiref?spec=catalogue-v2&ref=get-single-album&at=THIRD_PARTY) for the list of available endpoints.
* Visit our [TIDAL Developer Platform](https://developer.tidal.com/) for more information and getting started. 

## Usage

### Install via Swift Package file

Add the dependency to your existing `Package.swift` file.
```Swift
dependencies: [
    .package(url: "https://tidal-music.github.io/tidal-sdk-ios", from: "<VERSION>"))
]
```

### Install via Swift Package Manager with Xcode

1. Select `"File » Add Packages Dependencies..."` and enter the repository URL `https://github.com/tidal-music/tidal-sdk-ios` into the search bar (top right).
2. Set the Dependency Rule to `"Up to next major"`, and the version number to that you want. 
3. When `"Choose Package Products for tidal-sdk-ios"` appears, make sure to at least add `TidalAPI` and `Auth` to your target.

### Fetching a TIDAL album example

The TidalAPI depends on the [Auth](https://github.com/tidal-music/tidal-sdk-ios/blob/main/auth/README.md) module for authentication and providing a `CredentialsProvider`. For detailed instructions on how to set it up, please refer to its guide.

> [!NOTE] 
Different TIDAL API endpoints require different level of authentication. For endpoints where user data is accessed, a user authentication is required following the [Authorization Code Flow](https://github.com/tidal-music/tidal-sdk-ios/tree/main/Sources/Auth#authorization-code-flow-user-login). For others, such as catalog access, [Client Credentials Flow](https://github.com/tidal-music/tidal-sdk-ios/tree/main/Sources/Auth#client-credentials) is enough. 

Here's how to setup the TidalAPI with `Client Credientials` flow and fetch a TIDAL album:

1. Initialise and configure `TidalAuth`.

```Swift
import Auth
import TidalAPI

let auth = TidalAuth.shared
auth.config(
    config: AuthConfig(
        clientId: "YOUR_CLIENT_ID",
        clientSecret: "YOUR_CLIENT_SECRET",
        credentialsKey: "YOUR_CREDENTIALS_KEY"
    )
)
```

2. Connect the `CredentialsProvider` to `OpenAPIClientAPI`.

```Swift
let credentialsProvider: CredentialsProvider = auth
OpenAPIClientAPI.credentialsProvider = credentialsProvider
```

3. Fetch an album.

```Swift
let result = try await AlbumsAPITidal.getAlbumById(id: "ALBUM_ID", countryCode: "COUNTRY_CODE")
print(result)

/*
AlbumsSingleDataDocument(
	data: Optional(
		TidalAPI.AlbumsResource(
			attributes: Optional(
				TidalAPI.AlbumsAttributes(
					title: "Gold", 
					barcodeId: "00602435565811", 
					numberOfVolumes: 1, 
					numberOfItems: 16, 
					duration: "PT57M31S", 
					explicit: true, 
					releaseDate: Optional(2022-08-12 00:00:00 +0000),
					...
			)
		)
	)
)
*/
```

For other supported APIs, please refer [here](https://github.com/tidal-music/tidal-sdk-ios/tree/main/Sources/TidalAPI/Generated/OpenAPIClient/Classes/OpenAPIs/APIs).
