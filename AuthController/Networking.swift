//
//  AC+Networking.swift
//  iOSBeer
//
//  Created by ysoftware on 23.06.2018.
//  Copyright © 2018 Eugene. All rights reserved.
//

import CoreLocation

/// Когда пользователь входит в систему, класс сетевого протокола
/// должен вызвать onAuthStateChanged(_:) после того как данные пользователя готовы.
public class AuthNetworking<U:AuthControllerUser> {

	func getUser() -> U? {
		fatalError("override")
	}

	func observeUser(id:String, _ block: @escaping (U?)->Void) -> UserObserver {
		fatalError("override")
	}

	func onAuthStateChanged(_ block: @escaping ()->Void) {
		fatalError("override")
	}

	func signOut() {
		fatalError("override")
	}

	func updateLocation(_ location:CLLocation) {}

	func updateVersionCode() {}

	func updateLastSeen() {}

	func updateToken() {}

	func removeToken() {}
}

public protocol UserObserver {
	
	func remove()
}

// MARK: - Test Implementation

class TestUser:AuthControllerUser {

	var isProfileComplete: Bool = false

	var id: String = "test"

	var isBanned: Bool = false

	func completeProfile() {
		isProfileComplete = true
	}
}

struct TestUserObserver: UserObserver {

	func remove() {
	}
}

class TestNetworking: AuthNetworking<TestUser> {

	// MARK: - Test code

	var shouldLogIn:Bool = true
	var user:TestUser?
	var observeBlock:((TestUser?)->Void)?
	var authStateChangeBlock:(()->Void)?

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
	}

	override func updateVersionCode() {
	}

	override func updateLastSeen() {
	}

	override func updateToken() {
	}

	override func removeToken() {
	}
}
