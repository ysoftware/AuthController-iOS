//
//  ModalLogin.swift
//  AuthController
//
//  Created by ysoftware on 06.08.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

public class ModalLoginPresenter: AuthLogin {

	private var block:()->UIViewController

	private weak var viewController:UIViewController?

	public init(_ block: @escaping ()->UIViewController) {
		self.block = block
	}

	public func showLogin() {
		if !isShowingLogin {
			let newViewController = block()
			viewController = newViewController
			UIApplication.shared.delegate?.window??.rootViewController?
				.present(newViewController, animated: true)
		}
	}

	public func hideLogin() {
		viewController?.dismiss(animated: true)
	}

	public var isShowingLogin: Bool {
		return viewController != nil
	}
}
