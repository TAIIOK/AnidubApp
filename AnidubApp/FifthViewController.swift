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
import FirebaseDatabase

let providers: [FUIAuthProvider] = [
    FUIGoogleAuth(),
    FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
]

var customPicker: FUIAuthPickerViewController? = nil


class FifthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        if(UserDefaults.standard.value(forKey: "uid") == nil || Database.database().reference().child(byAppendingPath: "users").child(byAppendingPath: UserDefaults.standard.value(forKey: "uid") as! String) == nil){

        let auth = FUIAuth.defaultAuthUI()
        auth?.providers = providers
            if let bundlePath = Bundle.main.path(forResource: "FirebaseAuthUI", ofType: "strings") {
                let bundle = Bundle(path: bundlePath)
                auth?.customStringsBundle = bundle;
            }
       auth?.delegate = self
        let authViewController = auth?.authViewController()
        present(authViewController!, animated: true)
        }
        else{
            print(UserDefaults.standard.value(forKey: "uid"))
            print(Database.database().reference().child(byAppendingPath: "users").child(byAppendingPath: UserDefaults.standard.value(forKey: "uid") as! String))

            var kek = [String]()

            get_favorites(u_id: UserDefaults.standard.value(forKey: "uid") as! String, completion: {
                (result: [String]) in
                print("got back: \(result)")
            })
        }

/*
        customPicker = FUIAuthPickerViewController(authUI: auth!)
        customPicker?.view.backgroundColor = UIColor(red:0.20, green:0.27, blue:0.31, alpha:1.0)
*/

       
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
        guard let authError = error else {

            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                let bookmark = value?["bookmarks"] as? String ?? ""
                let recent = value?["recent"] as? String ?? ""
                if(username == "" ){

                      ref.child("users/\((user?.uid)!)/username").setValue("Default")
                      ref.child("users/\((user?.uid)!)/bookmarks").setValue("")
                      ref.child("users/\((user?.uid)!)/recent").setValue("")
                }

                // ...
            }) { (error) in
                print(error.localizedDescription)
            }

            UserDefaults.standard.setValue(Auth.auth().currentUser?.uid, forKey: "uid")

            print("User sign-in");
            return }

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
