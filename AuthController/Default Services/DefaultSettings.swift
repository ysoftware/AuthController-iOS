//
//  DefaultSettingsService.swift
//  AuthController
//
//  Created by ysoftware on 06.08.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

public struct DefaultSettingsService: AuthSettings {

	public init(userDefaults:UserDefaults = .standard) {
		defaults = userDefaults
	}

	private let defaults:UserDefaults

	public func clear() {
		let domain = Bundle.main.bundleIdentifier!
		defaults.removePersistentDomain(forName: domain)
		defaults.synchronize()
	}

	public var shouldAccessLocation:Bool {
		return defaults.value(forKey: Keys.shouldAccessLocation) as? Bool ?? true
	}

	func set(shouldUseLocation location:Bool) {
		defaults.set(location, forKey: Keys.shouldAccessLocation)
	}
}

extension DefaultSettingsService {

	struct Keys {

		static let shouldAccessLocation = "ShouldAccessLocation"
	}
}
