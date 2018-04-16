//
//  DataService.swift
//  AnidubApp
//
//  Created by Roman Efimov on 16.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()

    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _JOKE_REF = Firebase(url: "\(BASE_URL)/jokes")

    var BASE_REF: Firebase {
        return _BASE_REF
    }

    var USER_REF: Firebase {
        return _USER_REF
    }

    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String

        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)

        return currentUser!
    }

    var JOKE_REF: Firebase {
        return _JOKE_REF
    }
}
