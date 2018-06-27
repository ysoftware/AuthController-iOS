//
//  AC+EditProfile.swift
//  iOSBeer
//
//  Created by ysoftware on 23.06.2018.
//  Copyright © 2018 Eugene. All rights reserved.
//

import Foundation

public protocol EditProfilePresenter {
	
	func present()->Void
}

// MARK: - Test Implementation

struct TestEditProfilePresenter: EditProfilePresenter {

	func present() {
	}
}

// MARK: - Default Implementation with block (can also be used in Unit Tests)

public struct DefaultEditProfilePresenter: EditProfilePresenter {

	var block:()->Void

	init(_ block: @escaping ()->Void) {
		self.block = block
	}

	public func present() {
		return block()
	}
}
