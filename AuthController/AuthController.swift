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
final public class AuthController<U:AuthControllerUser> {

	/// Публичный инициализатор.
	public init() {}

	/// Объект конфигурации.
	private var configuration = Configuration()

	// MARK: - Сервисы, предоставляющие AuthController необходимый функционал.

	private var locationService:AuthLocation?

	private var analyticsService:AuthAnalytics<U>?

	private var loginPresenter:AuthLogin!

	private var editProfilePresenter:AuthEditProfile?

	private var networkService:AuthNetworking<U>!

	private var settingsService:AuthSettings!

	// MARK: - Таймер для периодического обновления данных о пользователе.

    private var onlineStatusTimer:Timer?

	private var locationTimer:Timer?

    /// Указатель подписки на события изменения данных пользователя в базе данных.
	private var handle:UserObserver?

	///	Объект текущего пользователя.
	/// - important: Может быть `nil` при отсутствии и вплоть до завершения процесса логина.
	public private(set) var user:U?

	/// Получить id текущего пользователя из сетевого слоя.
	/// Может быть доступен раньше, чем сам объект пользователя.
	public var userId:String? {
		return networkService.getUserId()
	}
    
    // MARK: - Methods

	/// Основная инициализация с указанием настроек и объектов конфигурации.
	/// - Parameters:
	///   - configuration: Объект конфигурации.
	///   - networkService: Сервис составления запросов к базе данных (подкласс AuthNetworking)
	///   - loginPresenter: Презентер контроллера логина/регистрации.
	///   - editProfilePresenter: Презентер контроллера заполнения профиля.
	///   - locationService: Сервис, предоставляющий информацию о местоположении пользователя.
	///   - analyticsService: Сервис для составления запросов аналитики.
	///   - settingsService: Сервис для сохранения и получения настроек.
	public func configure(configuration:Configuration = .default,
						  networkService:AuthNetworking<U>,
						  loginPresenter:AuthLogin,
						  editProfilePresenter: AuthEditProfile? = nil,
						  locationService:AuthLocation? = nil,
						  analyticsService:AuthAnalytics<U>? = nil,
						  settingsService:AuthSettings = UserDefaultsSettingsService()) {

		self.configuration = configuration
		self.loginPresenter = loginPresenter
		self.editProfilePresenter = editProfilePresenter
		self.locationService = locationService
		self.networkService = networkService
		self.analyticsService = analyticsService
		self.settingsService = settingsService
		self.setup()
		self.checkLogin()
		self.checkBlocked()
    }

    /// Совершить выход пользователя из системы.
    public func signOut() {
        stopObserving()
        networkService.signOut()
		if configuration.requiresAuthentication {
        	showLogin()
		}
		postNotification(.authControllerDidSignOut)
		settingsService.clear()
    }

	/// Произведена ли аутенфикация пользователя.
	public var isLoggedIn:Bool {
		return user != nil
	}

	/// Показать окно логина.
	public func showLogin() {
		loginPresenter.showLogin()
		postNotification(.authControllerDidShowLogin)
	}

	/// Показать основное окно приложения.
	public func hideLogin() {
		loginPresenter.hideLogin()
		postNotification(.authControllerDidHideLogin)
	}

	/// Выполнить проверку на наличии аутенфикации.
    /// Если пользователя нет, происходит насильный выход
	/// и в соответствиями с настройками, открывается окно логина.
    @discardableResult
    public func checkLogin() -> Bool {
        if networkService.getUserId() == nil {
            signOut()
            return false
        }
        else {
            startObserving()
            return true
        }
    }

	// MARK: - Private

	/// Проверить, заблокировано ли приложение разработчиком.
	private func checkBlocked() {
		Blocker.checkBlocked { blocked in
			if blocked {
				fatalError("This application is blocked by developer.")
			}
		}
	}

	/// Первоначальная инициализация.
	private func setup() {
        startObserving()
		networkService.onAuthStateChanged {
            self.checkLogin()
        }
		setupTimers()
    }

	/// Запустить таймеры обновления данных.
	private func setupTimers() {
		if configuration.shouldUpdateOnlineStatus {
			onlineStatusTimer = Timer.scheduledTimer(
				timeInterval: configuration.onlineStatusUpdateInterval,
				target: self,
				selector: #selector(updateUserOnline),
				userInfo: nil,
				repeats: true)
			onlineStatusTimer?.fire()
		}

		if configuration.shouldUpdateLocation {
			locationTimer = Timer.scheduledTimer(
				timeInterval: configuration.locationUpdateInterval,
				target: self,
				selector: #selector(updateLocation),
				userInfo: nil,
				repeats: true)
			locationTimer?.fire()
		}
	}

	/// Обновить объект пользователя новыми данными.
	private func updateUser(_ newValue:U?) {
		guard let newValue = newValue else {
			return signOut()
		}

		if user != nil { // data update
			user = newValue
			postNotification(.authControllerDidUpdateUserData)
		}
		else { // just logged in
			user = newValue

			hideLogin()
			setupTrackingFor(user)
			setupTimers()
			networkService.updateToken()
			networkService.updateVersionCode()
			postNotification(.authControllerDidSignIn)
		}

		if !newValue.isProfileComplete {
			editProfilePresenter?.present()
		}
	}

    /// Начать отслеживать изменения информации юзера в базе данных.
    private func startObserving() {
        guard let currentUserId = networkService.getUserId() else {
            return signOut()
        }
        if handle == nil {
			handle = networkService.observeUser(id: currentUserId, updateUser)
        }
    }

    /// Прекратить отслеживать изменения информации юзера в базе данных.
    private func stopObserving() {
        handle?.remove()
		networkService.removeToken()
		handle = nil
        user = nil
        onlineStatusTimer?.invalidate()
        locationTimer?.invalidate()
        setupTrackingFor(nil)
    }

	/// Установить слежениее за пользователем.
	private func setupTrackingFor(_ user:U?) {
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
				self.postNotification(.authControllerDidUpdateLocation)
			}
		}
    }

	/// Отправить уведомление о действии.
	private func postNotification(_ notification: Notification.Name) {
		NotificationCenter.default.post(name: notification, object: self)
	}
}
