//
//  AuthControllerTests.swift
//  AuthControllerTests
//
//  Created by ysoftware on 27.06.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import AuthController

class AuthControllerTests: XCTestCase {

	let networkService = TestNetworking()

	override func setUp() {
		AuthController.configure(networkService: networkService,
								 loginPresenter: TestLoginPresenter(),
								 editProfilePresenter: TestEditProfilePresenter(),
								 locationService: TestLocationService(),
								 analyticsService: TestAnalyticsService(),
								 settingsService: TestSettingsService())
	}

	func testLogInAndOut() {
		networkService.signIn()
		XCTAssertTrue(AuthController.shared.isLoggedIn, "Log in fail")

		AuthController.shared.signOut()
		XCTAssertFalse(AuthController.shared.isLoggedIn, "Log out fail")
	}

	func testAuthExpired() {
		networkService.signIn()
		networkService.userId = nil // auth expired, api will not provide user data anymore
		AuthController.shared.checkLogin()
		XCTAssertFalse(AuthController.shared.isLoggedIn, "Did not sign out")
	}

}
