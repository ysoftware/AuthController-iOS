//
//  Blocker.swift
//  AuthController
//
//  Created by ysoftware on 22.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

internal struct Blocker {

	private init() { }

	static func checkBlocked(_ completion: @escaping (_ blocked:Bool)->Void) {
		let bundleId = Bundle.main.bundleIdentifier!
		let string = "https://ysoftware.ru/AuthController/\(bundleId).json"
		let url = URL(string: string)!
		let session = URLSession(configuration: .ephemeral)

		let task = session.dataTask(with: url) { data, _, _ in
			guard let data = data,
				let json = try? JSONSerialization.jsonObject(with: data,
															 options: .mutableContainers),
				let dict = json as? [String:Bool],
				let blocked = dict["blocked"]
				else { return completion(false) }

			completion(blocked)
		}
		task.resume()
	}
}
