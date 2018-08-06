//
//  UserDefaultsSettingsTest.swift
//  AuthControllerTests
//
//  Created by ysoftware on 06.08.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import AuthController

final class UserDefaultsSettingsTest: XCTestCase {

	func testAll() {

		let service = UserDefaultsSettingsService()

		service.clear()
		XCTAssertTrue(service.shouldAccessLocation)

		service.set(shouldAccessLocation: true)
		XCTAssertTrue(service.shouldAccessLocation)

		service.set(shouldAccessLocation: false)
		XCTAssertFalse(service.shouldAccessLocation)

		service.set(shouldAccessLocation: true)
		XCTAssertTrue(service.shouldAccessLocation)

		service.clear()
		XCTAssertTrue(service.shouldAccessLocation)
	}
}
