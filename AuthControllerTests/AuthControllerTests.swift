//
//  AuthControllerTests.swift
//  AuthControllerTests
//
//  Created by ysoftware on 27.06.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import AuthController

final class AuthControllerTests: XCTestCase {

	let authController = AuthController<TestUser>()
	let networkService = TestNetworking()
	let loginPresenter = TestLoginPresenter()
	let settingsService = TestSettingsService()
	let locationService = TestLocationService()
	let editProfilePresenter = TestEditProfilePresenter()

	override func setUp() {

		// Default configuration with faster times
		var configuration = Configuration()
		configuration.locationUpdateInterval = 1
		configuration.onlineStatusUpdateInterval = 1

		authController.configure(configuration: configuration,
								 networkService: networkService,
								 loginPresenter: loginPresenter,
								 editProfilePresenter: editProfilePresenter,
								 locationService: locationService,
								 analyticsService: TestAnalyticsService(),
								 settingsService: settingsService)
	}

	func testLogInAndOut() {
		networkService.signIn()
		XCTAssertTrue(authController.isLoggedIn, "Log in fail")
		XCTAssertNotNil(authController.userId)
		XCTAssertTrue(authController.checkLogin())

		authController.signOut()
		XCTAssertFalse(authController.isLoggedIn, "Log out fail")
		XCTAssertNil(authController.userId)
	}

	func testUserFail() {
		networkService.signIn()
		// user data fail
		networkService.fail()
		// check if signed out
		XCTAssertFalse(authController.isLoggedIn, "Did not sign out")
		XCTAssertNil(authController.userId)
	}

	func testCheckLogin() {
		networkService.signIn()
		networkService.user = nil // network service fail, but did not push data
		authController.checkLogin()
		XCTAssertFalse(authController.isLoggedIn, "Did not sign out")
		XCTAssertNil(authController.userId)
	}

	func testEditProfileOpened() {
		networkService.signIn()
		networkService.loseData()
		XCTAssertTrue(editProfilePresenter.didPresent, "Did not present edit profile")
	}

	func testTimers() {
		networkService.signIn()
		// check updates
		let expectation = XCTestExpectation(description: "Did not update location and last seen")
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
			if self.networkService.didUpdateOnline && self.networkService.didUpdateLocation {
				expectation.fulfill()
			}
		}
		wait(for: [expectation], timeout: 1)
	}

	func testOpenLogin() {
		authController.signOut()
		XCTAssertTrue(loginPresenter.isShowingLogin, "Login did not open")
	}
}
