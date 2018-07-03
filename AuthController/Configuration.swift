//
//  Configuration.swift
//  AuthController
//
//  Created by ysoftware on 27.06.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Уведомления

extension Notification.Name {

	public static let authControllerDidUpdateUserData = Notification.Name("AuthControllerUser")
	public static let authControllerDidSignIn = Notification.Name("AuthControllerSignIn")
	public static let authControllerDidSignOut = Notification.Name("AuthControllerSignOut")
	public static let authControllerDidUpdateLocation = Notification.Name("AuthControllerLocation")
}

// MARK: - Настройки аутенфикации для приложения

public struct Configuration {

	public init() { }

	public static var `default`:Configuration = .init()

	/// Требуется ли автоматически обновлять информацию о последнем входе пользователя.
	public var shouldUpdateOnlineStatus = true

	/// Требуется ли автоматически обновлять местоположение пользователя.
	public var shouldUpdateLocation = true

	/// Требуется ли автоматически обновлять местоположение пользователя.
	public var requiresAuthentication = true

	/// Интервал времени в секундах между отправкой обновлений локации пользователя.
	public var locationUpdateInterval:TimeInterval = 120

	/// Интервал времени в секундах между отправкой обновлений о состоянии онлайн пользователя.
	public var onlineStatusUpdateInterval:TimeInterval = 60
}
