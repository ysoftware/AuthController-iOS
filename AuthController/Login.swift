//
//  AC+Windows.swift
//  iOSBeer
//
//  Created by ysoftware on 23.06.2018.
//  Copyright © 2018 Eugene. All rights reserved.
//

import UIKit

public protocol AuthLogin {

	func showLogin()

	func hideLogin()
	
	var isShowingLogin:Bool { get }
}

// MARK: - Default Windowed Implementation

public struct WindowLoginPresenter:AuthLogin {

	var block:()->UIViewController

	weak var mainWindow: UIWindow!
	var loginWindow: UIWindow!

	init(_ block: @escaping ()->UIViewController) {
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
