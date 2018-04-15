//
//  FifthViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 03.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

import UIKit
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebasePhoneAuthUI

let providers: [FUIAuthProvider] = [
    FUIGoogleAuth(),
    FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
]

var customPicker: FUIAuthPickerViewController? = nil


class FifthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()



        let auth = FUIAuth.defaultAuthUI()
        auth?.delegate = self
        auth?.providers = providers

/*
        customPicker = FUIAuthPickerViewController(authUI: auth!)
        customPicker?.view.backgroundColor = UIColor(red:0.20, green:0.27, blue:0.31, alpha:1.0)
*/

        let authViewController = auth?.authViewController()
        present(authViewController!, animated: true)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

extension FifthViewController: FUIAuthDelegate {

    // Implement the required protocol method for FIRAuthUIDelegate
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let authError = error else { return }

        let errorCode = UInt((authError as NSError).code)

        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }

/*
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return customPicker!
    }
*/

}
