//
//  AuthControllerOtherTests.swift
//  AuthControllerTests
//
//  Created by ysoftware on 06.08.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import AuthController

final class AuthControllerOtherTests: XCTestCase {

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
		configuration.shouldUpdateLocation = false
		configuration.shouldUpdateOnlineStatus = false

		authController.configure(configuration: configuration,
								 networkService: networkService,
								 loginPresenter: loginPresenter,
								 editProfilePresenter: editProfilePresenter,
								 locationService: locationService,
								 analyticsService: TestAnalyticsService(),
								 settingsService: settingsService)
	}


	func testTimersNotFire() {
		networkService.signIn()
		// check updates
		let expectation = XCTestExpectation(description: "Did not update location and last seen")
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
			if !self.networkService.didUpdateOnline && !self.networkService.didUpdateLocation {
				expectation.fulfill()
			}
		}
		wait(for: [expectation], timeout: 1)
	}



}
