//
//  Configuration.swift
//  AuthController
//
//  Created by ysoftware on 27.06.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Настройки аутенфикации для приложения

public class Configuration {
	public init() { }

	public static var `default`:Configuration = .init()

	/// Требуется ли автоматически обновлять информацию о последнем входе пользователя.
	public var shouldUpdateOnlineStatus = true

	/// Требуется ли автоматически обновлять местоположение пользователя.
	public var shouldUpdateLocation = true

	/// Требуется ли автоматически обновлять местоположение пользователя.
	public var requiresAuthentication = true
}
