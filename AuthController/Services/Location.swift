//
//  ACProtocols.swift
//  iOSBeer
//
//	Пример реализации сервиса локации с использованием SwiftLocation.
//
//  Created by ysoftware on 23.06.2018.
//  Copyright © 2018 Eugene. All rights reserved.
//

import CoreLocation

public protocol AuthLocation {
	
	func requestLocation(_ block: @escaping (CLLocation?)->Void)
}
