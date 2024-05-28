# ``EventProducer``

This module is only intended for internal use at TIDAL, but feel free to look at the code.

Event Producer is an events transportation layer of the TIDAL Event Platform (TEP). Its responsibility is to make sure that events get transported to the backend as fast, secure, and reliable as possible.

## Features
* Sending events in batches.
* Filtering events based on the provided blocked consent categories list.
* Collecting and sending monitoring data about dropped events.
* Notifying about the Outage.
 
## Documentation

* Read the [documentation](https://github.com/tidal-music/tidal-sdk/blob/main/EventProducer.md) for a detailed overview of the player functionality.
* Check the [API documentation](https://tidal-music.github.io/tidal-sdk-ios/documentation/eventproducer/) for the module classes and methods.
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
3. When `"Choose Package Products for tidal-sdk-ios"` appears, make sure to add the EventProducer libary to your target.

### Initialization

The [EventSender](https://github.com/tidal-music/tidal-sdk-ios/blob/main/Sources/EventProducer/Events/Logic/EventSender.swift) role exposes functionality for sending events and monitoring the status of the transportation layer. It is exposed through it's `shared` singleton instance and is setup by providing appropriate configuration and [CredentialsProvider](https://github.com/tidal-music/tidal-sdk-ios/blob/main/Sources/Auth/CredentialsProvider.swift).

```swift
let config: EventSenderConfig = .init(
    authProvider: authProvider,
    maxDiskUsageBytes: 1000000,
    blockedConsentCategories: [ConsentCategory.performance]
)

let eventSender = EventSender.shared
eventSender.setupConfiguration(config: config)
eventSender.start()
``` 

### Sending events

```swift
eventSender.sendEvent(
    name: "click_button",
    consentCategory: ConsentCategory.performance,
    headers: ["client-id": "45678"]
    payload: "{'buttonId':'123'}",
)
```  

### Updating `blockedConsentCategories` on the fly

```swift
eventSender.setBlockedConsentCategories([ConsentCategory.targeting])
```  

### Receiving outage notifications

Not yet implemented
