//
//  AC+Windows.swift
//  iOSBeer
//
//  Created by ysoftware on 23.06.2018.
//  Copyright © 2018 Eugene. All rights reserved.
//

import Foundation

public protocol AuthLogin {

	func showLogin()

	func hideLogin()
	
	var isShowingLogin:Bool { get }
}
