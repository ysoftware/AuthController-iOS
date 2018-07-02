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

	let authController = AuthController<TestUser>()
	let networkService = TestNetworking()

	override func setUp() {
		authController.configure(networkService: networkService,
								 loginPresenter: TestLoginPresenter(),
								 editProfilePresenter: TestEditProfilePresenter(),
								 locationService: TestLocationService(),
								 analyticsService: TestAnalyticsService(),
								 settingsService: TestSettingsService())
	}

	func testLogInAndOut() {
		networkService.signIn()
		XCTAssertTrue(authController.isLoggedIn, "Log in fail")

		authController.signOut()
		XCTAssertFalse(authController.isLoggedIn, "Log out fail")
	}

	func testAuthExpired() {
		networkService.signIn()
		networkService.user = nil // auth expired, api will not provide user data anymore
		authController.checkLogin()
		XCTAssertFalse(authController.isLoggedIn, "Did not sign out")
	}

}
