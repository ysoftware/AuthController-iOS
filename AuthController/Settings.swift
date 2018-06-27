//
//  Settings.swift
//  AuthController
//
//  Created by ysoftware on 27.06.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public protocol SettingsService {

	func clear()
	var shouldAccessLocation:Bool { get }
}

// MARK: - Test Implementation

class TestSettingsService: SettingsService {

	var shouldAccessLocation: Bool = true

	func clear() {
		shouldAccessLocation = true
	}
}

// MARK: - Default Implementation

public struct DefaultSettingsService: SettingsService {

	public init() { }
	
	let defaults:UserDefaults = .standard

	public func clear() {
		let domain = Bundle.main.bundleIdentifier!
		defaults.removePersistentDomain(forName: domain)
		defaults.synchronize()
	}

	// MARK: - Location

	public var shouldAccessLocation:Bool {
		return defaults.value(forKey: Keys.shouldUseLocation) as? Bool ?? true
	}

	func set(shouldUseLocation location:Bool) {
		defaults.set(location, forKey: Keys.shouldUseLocation)
	}
}

extension DefaultSettingsService {
	
	struct Keys {
		static let shouldUseLocation = "shouldUseLocation"
	}
}
