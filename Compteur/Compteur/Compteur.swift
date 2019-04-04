//
//  Compteur.swift
//  Compteur
//
//  Created by Lucas Stoebner on 14/03/2019.
//  Copyright © 2019 LucasStbnr. All rights reserved.
//

import UIKit
import os.log

class Compteur : NSObject, NSCoding{
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(name, forKey: PropertyKey.name)
		aCoder.encode(value, forKey: PropertyKey.value)
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else{
			os_log("Unable to decode the name for Compteur Object", log:OSLog.default, type:.debug)
			return nil
		}
		guard let value = aDecoder.decodeInteger(forKey: PropertyKey.value) as Int? else{
			os_log("Unable to decode the value for Compteur Object", log:OSLog.default, type:.debug)
			return nil
		}
		self.init(name: name, value: value)
	}
	
	struct PropertyKey{
		static let name = "name"
		static let value = "value"
	}
	
	static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
	static let archiveURL = DocumentsDirectory.appendingPathComponent("compteurs")
	var name: String
	var value: Int
	
	//MARK: Initialization
	init?(name: String, value: Int) {
		// Initialize stored properties
		self.name = name
		self.value = value
	}
}
