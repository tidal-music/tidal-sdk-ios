# Auth

Auth module handles Authentication and Authorization when interacting with the TIDAL API or other TIDAL SDK modules.
It provides easy to use authentication to interact with TIDAL's oAuth2 server endpoints.

## Features
* User Login and Sign up handling (through login.tidal.com)
* Automatic session refresh (refreshing oAuthTokens)
* Secure and encrypted storage of your tokens

## Documentation
* Read the [documentation](https://github.com/tidal-music/tidal-sdk/blob/main/Auth.md) for a detailed overview of the auth functionality.
* Check the [API documentation](https://tidal-music.github.io/tidal-sdk-ios/documentation/auth/) for the module classes and methods.
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
3. When `"Choose Package Products for tidal-sdk-ios"` appears, make sure to at least add Auth to your target.

### Client Credentials

This authentication method uses `clientId` and `clientSecret`, e.g. when utilizing the [TIDAL API](https://developer.tidal.com/documentation/api/api-overview). Follow these steps in order to get an oAuth token.

1. Initiate the process by initialising [TIDALAuth](./auth.swift) by providing an [AuthConfig](./Model/AuthConfig.swift) with `clientId` and `clientSecret`.
```swift
let credentialsKey = "YOUR_CREDENTIALS_KEY"
let clientId = "YOUR_CLIENT_ID"
let clientUniqueKey = "YOUR_CLIENT_UNIQUE_KEY"
let clientSecret = "YOUR_CLIENT_SECRET"

let authConfig = AuthConfig(
	clientId: clientId,
	clientUniqueKey: clientUniqueKey,
	clientSecret: clientSecret,
	credentialsKey: credentialsKey
)

TidalAuth.shared.config(config: authConfig)
```
2. `TidalAuth` conforms to the protocols `Auth` and `CredentialsProvider`. `CredentialsProvider` is responsible for getting [Credentials](./Model/Credentials.swift) and `Auth` is responsible for different authorization operations. 
```swift
let credentialsProvider: CredentialsProvider = TidalAuth.shared
let auth: Auth = TidalAuth.shared
```  
   
3. Obtain credentials by calling `credentialsProvider.getCredentials`, which when successfully executed, returns credentials containing a `token`, `expires` and other properties.
```swift
let credentials = try await credentialsProvider.getCredentials()
let token: String? = credentials.token
let expires: Date? = credentials.expires
```  
  
4. Make API calls to your desired endpoint and include `Authentication: Bearer YOUR_TOKEN` as a header.

### Authorization Code Flow (user login)
(Only available for TIDAL internally developed applications for now)

To implement the login redirect flow, follow these steps or refer to our [Demo app](https://github.com/tidal-music/tidal-sdk-ios/tree/main/TestApps/AuthTestApp) implementation.

1. Initiate the process by initialising [TIDALAuth](./auth.swift).
2. For the first login use `initializeLogin` function, which returns the login URL. Open this URL in a webview, `SFSafariViewController` or invoke `ASWebAuthenticationSession`. By loading this URL, the user will be able to log in by either using their username/password or selecting one of the social logins.
```swift
let loginConfig = LoginConfig()
let redirectUri = "YOUR_REDIRECT_URI"

guard let loginURL = auth.initializeLogin(redirectUri: redirectUri, loginConfig: loginConfig) else {
	print("Something is wrong")
	return
}

let safariViewController = SFSafariViewController(url: loginURL)
```
3. Successful login will redirect to an URL which you need to intercept. Here is the example for `SFSafariViewController`:
```swift
func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
	if URL.absoluteString.starts(with: redirectUri) {
		self.redirectURL = URL
	}
}
```
4. After redirection to your app, follow up with a call to `finalizeLogin`, passing in the returned `redirectURL`.
 ```swift
try await auth.finalizeLogin(loginResponseUri: redirectURL.absoluteString)
 ```
5. Once logged in, you can use `credentialsProvider.getCredentials` to obtain `Credentials` for activities like API calls
6. For subsequent logins, when the user returns to your app, simply call `credentialsProvider.getCredentials`. This is sufficient unless the user actively logs out or a token is revoked (e.g., due to a password change).

> [!IMPORTANT] 
> ⚠️ Ensure to invoke `credentialsProvider.getCredentials` each time you need a token and avoid storing it. This approach enables the SDK to manage timeouts, upgrades, or automatic retries seamlessly.

### Device Login
(Only available for TIDAL internally developed applications for now)

For devices with limited input capabilities, such as TVs or Watches, an alternative login method is provided. Follow these steps or refer to our [Demo app](https://github.com/tidal-music/tidal-sdk-ios/tree/main/TestApps/AuthTestApp) implementation.

1. Initiate the process by initialising [TIDALAuth](./auth.swift).
2. Use `initializeDeviceLogin` and await the response.

 ```swift
let response = try await auth.initializeDeviceLogin()
```

3. The response will contain a `userCode`; display it to the user.
 ```swift
let userCode: String = response.userCode
```
4. Instruct the user to visit `link.tidal.com`, log in, and enter the displayed code.
5. Subsequently, call `finalizeDeviceLogin` and pass `deviceCode`, which will continually poll the backend until the user successfully enters the code. Once the operation has completed successfully, you are ready to proceed.
 ```swift
try await auth.finalizeDeviceLogin(deviceCode: response.deviceCode)
```
6. Retrieve a token by calling `credentialsProvider.getCredentials`.

> [!TIP]  
> Many modern apps feature a QR-Code for scanning, which you can also generate. Ensure it includes `verificationUriComplete`, as provided in the response.

