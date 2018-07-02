//
//  User.swift
//  AuthController
//
//  Created by ysoftware on 27.06.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

public protocol AuthControllerUser {

	var isProfileComplete:Bool { get }
	
	var id:String { get }
}
