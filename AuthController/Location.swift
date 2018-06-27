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

public protocol LocationDataSource {
	
	func requestLocation(_ block: @escaping (CLLocation?)->Void)
}

// MARK: - Test Implementation

struct TestLocationService: LocationDataSource {

	var shouldReturnLocation = true

	func requestLocation(_ block: @escaping (CLLocation?) -> Void) {
		block(shouldReturnLocation ? CLLocation(latitude: 55, longitude: 55) : nil)
	}
}
