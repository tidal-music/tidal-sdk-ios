// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import class Foundation.ProcessInfo
import PackageDescription

/// Only add DocC Plugin when building docs, so that clients of this library won't
/// unnecessarily also get the DocC Plugin
let environmentVariables = ProcessInfo.processInfo.environment
let shouldIncludeDocCPlugin = environmentVariables["INCLUDE_DOCC_PLUGIN"] == "true"

let package = Package(
	name: "tidal-sdk-ios",
	platforms: [
		.iOS(.v15),
		.macOS(.v12),
		.tvOS(.v15),
		.watchOS(.v7),
	],
	products: [
		.library(
			name: "Template",
			targets: ["Template"]
		),
		.library(
			name: "Common",
			targets: ["Common"]
		),
		.library(
			name: "EventProducer",
			targets: ["EventProducer"]
		),
		.library(
			name: "Auth",
			targets: ["Auth"]
		),
		.library(
			name: "Player",
			targets: ["Player"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/groue/GRDB.swift.git", from: "6.27.0"),
		.package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "7.0.2"),
		.package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
		.package(url: "https://github.com/MobileNativeFoundation/Kronos.git", exact: "4.2.2"),
		.package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.54.0"),
	] + (shouldIncludeDocCPlugin ? [.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")] : []),
	targets: [
		.target(
			name: "Template",
			plugins: [
				.plugin(name: "SwiftLint", package: "SwiftLintPlugin"),
			]
		),
		.testTarget(
			name: "TemplateTests",
			dependencies: [
				.template,
			]
		),
		.target(
			name: "Common",
			plugins: [
				.plugin(name: "SwiftLint", package: "SwiftLintPlugin"),
			]
		),
		.testTarget(
			name: "CommonTests",
			dependencies: [
				.common,
			]
		),
		.target(
			name: "EventProducer",
			dependencies: [
				.common,
				.GRDB,
				.SWXMLHash,
			],
			plugins: [
				.plugin(name: "SwiftLint", package: "SwiftLintPlugin"),
			]
		),
		.testTarget(
			name: "EventProducerTests",
			dependencies: [
				.eventProducer,
			]
		),
		.target(
			name: "Auth",
			dependencies: [
				.common,
				.KeychainAccess,
			],
			plugins: [
				.plugin(name: "SwiftLint", package: "SwiftLintPlugin"),
			]
		),
		.testTarget(
			name: "AuthTests",
			dependencies: [
				.auth,
			]
		),
		.target(
			name: "Player",
			dependencies: [
				.common,
				.Kronos,
				.auth,
				.eventProducer,
			],
			resources: [
				.process("README.md"),
			],
			plugins: [
				.plugin(name: "SwiftLint", package: "SwiftLintPlugin"),
			]
		),
		.testTarget(
			name: "PlayerTests",
			dependencies: [
				.player,
				.auth,
			],
			resources: [
				.process("PlayLog/AudioFiles/test_1min.m4a"),
				.process("PlayLog/AudioFiles/test_5sec.m4a"),
			],
			plugins: [
				.plugin(name: "SwiftLint", package: "SwiftLintPlugin"),
			]
		),
	]
)

extension Target.Dependency {
	/// Local
	static let template = byName(name: "Template")
	static let eventProducer = byName(name: "EventProducer")
	static let common = byName(name: "Common")
	static let auth = byName(name: "Auth")
	static let player = byName(name: "Player")
	/// External
	static let GRDB = product(name: "GRDB", package: "GRDB.swift")
	static let SWXMLHash = product(name: "SWXMLHash", package: "SWXMLHash")
	static let KeychainAccess = product(name: "KeychainAccess", package: "KeychainAccess")
	static let Kronos = product(name: "Kronos", package: "Kronos")
}
