//
//  AuthCustomViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 15.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

import Foundation

import UIKit
import FirebaseAuthUI
import FirebaseAuth

class AuthCustomViewController: FUIAuthPickerViewController {

    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = UIColor(displayP3Red: 56, green: 68, blue: 78, alpha: 1)
    }

}
