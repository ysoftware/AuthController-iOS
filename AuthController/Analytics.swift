//
//  AC+Analytics.swift
//  iOSBeer
//
//  Created by ysoftware on 23.06.2018.
//  Copyright © 2018 Eugene. All rights reserved.
//

import Foundation

public protocol AuthControllerAnalytics {

	func setUser(_ user:AuthControllerUser?)
}

// MARK: - Test Implementation

struct TestAnalyticsService: AuthControllerAnalytics {
	
	func setUser(_ user: AuthControllerUser?) {
		// doing nothing for now
	}
}
