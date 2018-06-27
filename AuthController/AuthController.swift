//
//  AuthController.swift
//  ProfitProjects
//
//  Created by Ярослав Ерохин on 19.12.16.
//  Copyright © 2017 ProfitProjects. All rights reserved.
//

import Foundation

/// Класс, который хранит в себе и обновляет информацию о текущем пользователе
/// и следит за его статусом.
/// Автоматически открывает окно логина/заполнения необходимой информации
/// о пользователя по необходимости.
///
/// **Примеры использования**
/// ```
/// Получение текущего пользователя
/// guard let user = AuthController.shared.user else { return }
///
/// Выход из системы
/// AuthController.shared.signOut()
/// ```
///
/// - important: `AuthController` - синглтон. Доступ к нему происходит только через `shared`.
/// Точка входа для настройки - `AppDelegate.configure(...)`
final public class AuthController {

	/// Получение основного объекта `AuthController`.
	public static let shared = AuthController()

    // MARK: - Properties

	/// Объект конфигурации.
	private var configuration = Configuration()

	/// Сервисы, предоставляющие AuthController необходимый функционал.
	private var locationService:LocationDataSource?
	private var analyticsService:AuthControllerAnalytics?
	private var loginPresenter:AuthControllerLoginPresenter!
	private var editProfilePresenter:EditProfilePresenter!
	private var networkService:AuthNetworking!
	private var settingsService:SettingsService!

    /// Таймер для периодического обновления данных о пользователе.
    private var onlineStatusTimer:Timer?
	private var locationTimer:Timer?

    /// Указатель подписки на события изменения данных пользователя в базе данных.
	private var handle:UserObserver?

	///	Объект текущего пользователя.
	/// - important: Может быть `nil` при отсутствии и вплоть до завершения процесса логина.
	public private(set) var user:AuthControllerUser?
    
    // MARK: - Methods

	/// Основная инициализация с указанием настроек и объектов конфигурации.
	public static func configure(with configuration:Configuration = .default,
								 networkService:AuthNetworking,
								 loginPresenter:AuthControllerLoginPresenter,
								 editProfilePresenter: EditProfilePresenter,
								 locationService:LocationDataSource? = nil,
								 analyticsService:AuthControllerAnalytics? = nil,
								 settingsService:SettingsService = DefaultSettingsService()) {

		shared.configuration = configuration
		shared.loginPresenter = loginPresenter
		shared.editProfilePresenter = editProfilePresenter
		shared.locationService = locationService
		shared.networkService = networkService
		shared.analyticsService = analyticsService
		shared.settingsService = settingsService
		shared.setup()
		shared.checkLogin()
    }

    /// Совершить выход пользователя из системы.
    public func signOut() {
        stopObserving()
		if user != nil {
			networkService.removeToken()
		}
        networkService.signOut()
		if configuration.requiresAuthentication {
        	showLogin()
		}
		NotificationCenter.default.post(name: .AuthControllerSignOut, object: self)
		settingsService.clear()
    }

	/// Проверить, совершена ли аутенфикация пользователя.
	public var isLoggedIn:Bool {
		return user != nil
	}

	/// Показать окно логина.
	public func showLogin() {
		loginPresenter.showLogin()
	}

	/// Показать основное окно приложения.
	public func hideLogin() {
		loginPresenter.hideLogin()
	}

	/// Выполнить проверку на наличии аутенфикации.
    /// Если пользователя нет, происходит насильный выход
	/// и в соответствиями с настройками, открывается окно логина.
    @discardableResult
    public func checkLogin() -> Bool {
        if networkService.userId == nil {
            signOut()
            return false
        }
        else {
            startObserving()
            return true
        }
    }

	// MARK: - Private

	private init() { }

	private func setup() {
        startObserving()
		networkService.onAuthStateChanged {
            self.checkLogin()
        }
        
        if configuration.shouldUpdateOnlineStatus {
            onlineStatusTimer = Timer.scheduledTimer(timeInterval: 60,
                                                     target: self,
                                                     selector: #selector(updateUserOnline(_:)),
                                                     userInfo: nil,
                                                     repeats: true)
        }
        
        if configuration.shouldUpdateLocation {
            locationTimer = Timer.scheduledTimer(timeInterval: 120,
                                                 target: self,
                                                 selector: #selector(updateLocation(_:)),
                                                 userInfo: nil,
                                                 repeats: true)
        }
    }

	private func updateUser(_ newValue:AuthControllerUser?) {
		guard let newValue = newValue else {
			return signOut()
		}

		if user != nil { // data update
			user = newValue
			NotificationCenter.default.post(name: .AuthControllerUpdate, object: self)
		}
		else { // just logged in
			user = newValue
			hideLogin()
			setupTrackingFor(user)

			locationTimer?.fire()
			onlineStatusTimer?.fire()
			NotificationCenter.default.post(name: .AuthControllerSignIn, object: self)

			networkService.updateToken()
			networkService.updateVersionCode()
		}

		if !newValue.isProfileComplete {
			editProfilePresenter.present()
		}
	}

    /// Начать отслеживать изменения информации юзера в базе данных.
    private func startObserving() {
        guard let currentUserId = networkService.userId else {
            return signOut()
        }
        if handle == nil {
			handle = networkService.observeUser(id: currentUserId, updateUser)
        }
    }

    /// Прекратить отслеживать изменения информации юзера в базе данных.
    private func stopObserving() {
        handle?.remove()
        user = nil
        handle = nil
        
        onlineStatusTimer?.invalidate()
        locationTimer?.invalidate()
        setupTrackingFor(nil)
    }

	private func setupTrackingFor(_ user:AuthControllerUser?) {
		analyticsService?.setUser(user)
	}

    // MARK: - Таймеры
    
    /// Обновить данные о последнем нахождении пользователя в сети.
    @objc func updateUserOnline(_ timer:Timer) {
        guard configuration.shouldUpdateOnlineStatus else { return }
        networkService.updateLastSeen()
    }

    /// Обновить данные о местоположении пользователя.
    @objc func updateLocation(_ timer:Timer) {
        guard configuration.shouldUpdateLocation,
			settingsService.shouldAccessLocation else { return }

		locationService?.requestLocation { location in
			if let location = location {
				self.networkService.updateLocation(location)
			}
		}
    }
}

// MARK: - Уведомления

extension Notification.Name {
	public static let AuthControllerUpdate = Notification.Name("AuthControllerUpdate")
	public static let AuthControllerSignIn = Notification.Name("AuthControllerSignIn")
	public static let AuthControllerSignOut = Notification.Name("AuthControllerSignOut")
}
