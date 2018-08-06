//
//  Notifications.swift
//  AuthController
//
//  Created by ysoftware on 15.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public extension Notification.Name {

	public static let authControllerDidUpdateUserData = Notification.Name("AuthControllerUser")

	public static let authControllerDidSignIn = Notification.Name("AuthControllerSignIn")

	public static let authControllerDidSignOut = Notification.Name("AuthControllerSignOut")

	public static let authControllerDidUpdateLocation = Notification.Name("AuthControllerLocation")

	public static let authControllerDidShowLogin = Notification.Name("AuthControllerDidShowLogin")

	public static let authControllerDidHideLogin = Notification.Name("AuthControllerDidHideLogin")
}
