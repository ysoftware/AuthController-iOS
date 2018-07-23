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
open class AuthNetworking<U:AuthControllerUser> {

	public init() {}

	open func getUserId() -> String? {
		fatalError("override AuthNetworking.getUserId()")
	}

	open func observeUser(id:String, _ block: @escaping (U?)->Void) -> UserObserver {
		fatalError("override observeUser(id:_:")
	}

	open func onAuthStateChanged(_ block: @escaping ()->Void) {
		fatalError("override onAuthStateChanged(_:)")
	}

	open func signOut() {
		fatalError("override signOut()")
	}

	open func updateLocation(_ location:CLLocation) {}

	open func updateVersionCode() {}

	open func updateLastSeen() {}

	open func updateToken() {}

	open func removeToken() {}
}

public protocol UserObserver {
	
	func remove()
}
