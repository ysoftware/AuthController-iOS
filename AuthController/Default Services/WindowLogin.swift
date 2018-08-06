//
//  WindowLogin.swift
//  AuthController
//
//  Created by ysoftware on 06.08.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public struct WindowLoginPresenter: AuthLogin {

	private var block:()->UIViewController

	private weak var mainWindow: UIWindow!

	private var loginWindow: UIWindow!

	public init(_ block: @escaping ()->UIViewController) {
		mainWindow = UIApplication.shared.windows.first
		loginWindow = UIWindow(frame: UIScreen.main.bounds)
		self.block = block
	}

	public func showLogin() {
		if !isShowingLogin {
			loginWindow.rootViewController = block()
			loginWindow.makeKeyAndVisible()
		}
	}

	public func hideLogin() {
		if isShowingLogin {
			mainWindow.makeKeyAndVisible()
			loginWindow.rootViewController = nil
		}
	}

	public var isShowingLogin: Bool {
		return loginWindow.isKeyWindow
	}
}
