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
public protocol AuthNetworking {

	var userId: String? { get }

	func observeUser(id:String, _ block: @escaping (AuthControllerUser?)->Void) -> UserObserver

	func onAuthStateChanged(_ block: @escaping ()->Void)

	func updateLocation(_ location:CLLocation)

	func updateVersionCode()

	func updateLastSeen()

	func updateToken()

	func removeToken()

	func signOut()
}

public protocol UserObserver {
	
	func remove()
}

// MARK: - Test Implementation

struct TestUserObserver: UserObserver {

	func remove() {
	}
}

class TestNetworking: AuthNetworking {

	// MARK: - Test code

	var shouldLogIn:Bool = true

	var observeBlock:((AuthControllerUser?)->Void)?
	var authStateChangeBlock:(()->Void)?

	func signIn() {
		let user = shouldLogIn ? TestUser() : nil
		userId = user?.id
		authStateChangeBlock?()
		observeBlock?(user)
	}

	// MARK: - Fake networking

	var userId: String?

	func observeUser(id: String,
					 _ block: @escaping (AuthControllerUser?)->Void) -> UserObserver {
		observeBlock = block
		return TestUserObserver()
	}

	func onAuthStateChanged(_ block: @escaping ()->Void) {
		authStateChangeBlock = block
	}

	func signOut() {
		userId = nil
	}

	// MARK: - Other

	func updateLocation(_ location: CLLocation) {
	}

	func updateVersionCode() {
	}

	func updateLastSeen() {
	}

	func updateToken() {
	}

	func removeToken() {
	}
}
