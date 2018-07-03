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
		fatalError("override getUser()")
	}

	func observeUser(id:String, _ block: @escaping (U?)->Void) -> UserObserver {
		fatalError("override observeUser(id:_:")
	}

	func onAuthStateChanged(_ block: @escaping ()->Void) {
		fatalError("override onAuthStateChanged(_:)")
	}

	func signOut() {
		fatalError("override signOut()")
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
