//
//  Settings.swift
//  AuthController
//
//  Created by ysoftware on 27.06.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public protocol AuthSettings {

	func clear()
	
	var shouldAccessLocation:Bool { get }
}
