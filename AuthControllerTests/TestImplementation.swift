//
//  TestImplementation.swift
//  AuthControllerTests
//
//  Created by ysoftware on 03.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import CoreLocation
@testable import AuthController

// MARK: - Networking

class TestUser:AuthControllerUser {

	var isProfileComplete: Bool = true

	var id: String = "test"

	var isBanned: Bool = false

	func loseData() {
		isProfileComplete = false
	}
}

struct TestUserObserver: UserObserver {

	func remove() {
	}
}

class TestNetworking: AuthNetworking<TestUser> {

	// MARK: - Test code

	var didUpdateOnline = false
	var didUpdateLocation = false

	var shouldLogIn:Bool = true
	var user:TestUser?
	var observeBlock:((TestUser?)->Void)?
	var authStateChangeBlock:(()->Void)?

	func loseData() {
		user?.loseData()
		observeBlock?(user)
	}

	func fail() {
		user = nil
		observeBlock?(user)
	}

	func signIn() {
		user = shouldLogIn ? TestUser() : nil
		authStateChangeBlock?()
		observeBlock?(user)
	}

	// MARK: - Fake networking

	override func observeUser(id: String,
							  _ block: @escaping (TestUser?)->Void) -> UserObserver {
		observeBlock = block
		return TestUserObserver()
	}

	override func getUser() -> TestUser? {
		return user
	}

	override func onAuthStateChanged(_ block: @escaping ()->Void) {
		authStateChangeBlock = block
	}

	override func signOut() {
		user = nil
	}

	// MARK: - Other

	override func updateLocation(_ location: CLLocation) {
		didUpdateLocation = true
	}

	override func updateVersionCode() {
	}

	override func updateLastSeen() {
		didUpdateOnline = true
	}

	override func updateToken() {
	}

	override func removeToken() {
	}
}

// MARK: - Edit Profile

class TestEditProfilePresenter: EditProfilePresenter {

	var didPresent = false

	func present() {
		didPresent = true
	}
}

// MARK: - Default Implementation with block (can also be used in Unit Tests)

public struct DefaultEditProfilePresenter: EditProfilePresenter {

	var block:()->Void

	init(_ block: @escaping ()->Void) {
		self.block = block
	}

	public func present() {
		return block()
	}
}

// MARK: - Location

struct TestLocationService: LocationDataSource {

	var shouldReturnLocation = true

	func requestLocation(_ block: @escaping (CLLocation?) -> Void) {
		block(shouldReturnLocation ? CLLocation(latitude: 55, longitude: 55) : nil)
	}
}

// MARK: - Analytics

class TestAnalyticsService: AuthControllerAnalytics<TestUser> {

	override func setUser(_ user: TestUser?) {
		// doing nothing for now
	}
}

// MARK: - Settings

class TestSettingsService: SettingsService {

	var shouldAccessLocation: Bool = true

	func clear() {
		shouldAccessLocation = true
	}
}
