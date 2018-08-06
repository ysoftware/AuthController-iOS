//
//  UserDefaultsSettingsService.swift
//  AuthController
//
//  Created by ysoftware on 06.08.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

public struct UserDefaultsSettingsService: AuthSettings {

	public init(userDefaults:UserDefaults = .standard) {
		defaults = userDefaults
	}

	private let defaults:UserDefaults

	public func clear() {
		defaults.removeObject(forKey: Keys.shouldAccessLocation)
		defaults.synchronize()
	}

	public var shouldAccessLocation:Bool {
		return defaults.value(forKey: Keys.shouldAccessLocation) as? Bool ?? true
	}

	public func set(shouldAccessLocation location:Bool) {
		defaults.set(location, forKey: Keys.shouldAccessLocation)
	}
}

extension UserDefaultsSettingsService {

	struct Keys {

		static let shouldAccessLocation = "ShouldAccessLocation"
	}
}
