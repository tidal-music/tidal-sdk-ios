# TIDAL iOS SDK 

This is the repository for TIDAL SDK modules for iOS development.

## Available modules

- [auth](./Sources/Auth/README.md)
- [common](./Sources/Common/README.md)
- [eventproducer](./Sources/EventProducer/README.md)
- [player](./Sources/Player/README.md)

## Getting started
1. Clone the repository
2. Run `./local-setup.sh`
3. All done!

## How to create a new module
Run the `generate-module.sh` script. It will prompt you to enter a module name using [PascalCase](https://pl.wikipedia.org/wiki/PascalCase).
After confirming the name, a new directory will be created with the basic module setup. Open this in your IDE and start working.

## SPM Installation
1. Navigate to the project inside the project navigator
2. Select "Package Dependencies" tab
3. Tap the plus button
4. Inside the search, paste the following link: https://github.com/tidal-open-source/tidal-sdk-ios
5. Select the packages you wish to import

note: make sure to select the latest version or a desired branch when importing the SPM

## How to preview documentation locally

Using Xcode
- Go to `Product > Build documentation`

Using the command line
- To generate a preview of the documentation from the command line, you first need to set the environment variable `$INCLUDE_DOCC_PLUGIN=true`
- Then, run the following command for the desired module you want to preview documentation

```
swift package --disable-sandbox preview-documentation --target Module
```

### Creating a module release
1. Bump the version stored in `version.txt` in the repo root directory to the desired value. Follow [Semantic Versioning](https://semver.org/). Also, you cannot downgrade - the CI/CD pipeline will refuse to work with downgrades.

2. Open a Pull Request with your version bump, get it approved and merge it. A release draft will be created for the module you changed.

3. Find your draft in the [releases list](https://github.com/tidal-music/tidal-sdk-ios/releases) and add some meaningful sentences about the release, changelog style (Note: This paragraph is temporary, as we will automate and regulate changelog creation, but for now, you are free to just type)

4. Check in with your teammates, lead, the module's owner etc. to make sure the release is ready to go.

5. Click `Publish` at the bottom of your draft release. This will trigger a workflow to tag the release commit.
