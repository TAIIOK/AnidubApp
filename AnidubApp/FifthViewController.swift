//
//  FifthViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 03.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import MessageUI
import Firebase

let providers: [FUIAuthProvider] = [
    FUIGoogleAuth(),
    FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!)
]

var customPicker: FUIAuthPickerViewController?

class FifthViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var ButtonInCell: UIButton!

    @IBOutlet weak var ImageProfile: UIImageView!

    @IBOutlet weak var switcher_outlet: UISwitch!

    @IBAction func Switcher_Action(_ sender: Any) {

        if let selectedTheme = Theme(rawValue: true == switcher_outlet.isOn ? 1 : 0) {
            ThemeManager.applyTheme(theme: selectedTheme)
            self.tabBarController?.tabBar.barStyle =  selectedTheme.barStyle
            self.navigationController?.navigationBar.barStyle = selectedTheme.barStyle
            view.backgroundColor = ThemeManager.currentTheme().backgroundColor
            tableView.separatorColor = ThemeManager.currentTheme().secondaryColor
            tableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
            tableView.reloadData()

        }

    }

    var imagePicker = UIImagePickerController()
    var download = false

    override func viewDidLoad() {
        super.viewDidLoad()

        ImageProfile.layer.borderWidth = 1
        ImageProfile.layer.masksToBounds = false
        ImageProfile.layer.borderColor = UIColor.clear.cgColor
        ImageProfile.layer.cornerRadius = ImageProfile.frame.height/2
        ImageProfile.clipsToBounds = true

        self.navigationItem.title = "Профиль"
       ButtonInCell.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
   
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = ThemeManager.currentTheme().backgroundCellColor
        cell.textLabel?.textColor = ThemeManager.currentTheme().TextCellColor
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if(indexPath.row == 0 && indexPath.section == 1) {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.keepSynced(true)
            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (_) in
            ref.child("users/\(userID!)/recent/").removeValue()
            })

            var alert: UIAlertController=UIAlertController(title: "Успех", message: "Список недавних тайтлов очищен", preferredStyle: UIAlertControllerStyle.alert)
            let Action = UIAlertAction(title: "Хорошо", style: UIAlertActionStyle.default) {
                    _ in
                }

                alert.addAction(Action)
                if let popoverPresentationController = alert.popoverPresentationController {
                    popoverPresentationController.sourceView = self.view
                    popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                }
                self.present(alert, animated: true, completion: nil)
            }
            }}

        if(indexPath.row == 1 && indexPath.section == 1) {

            var alert: UIAlertController=UIAlertController(title: "Успех", message: "Кэш картинок очищен", preferredStyle: UIAlertControllerStyle.alert)
            let Action = UIAlertAction(title: "Хорошо", style: UIAlertActionStyle.default) {
                _ in
            }
            alert.addAction(Action)
            SDImageCache.shared().clearDisk(onCompletion: nil)
            SDImageCache.shared().clearMemory()
            if let popoverPresentationController = alert.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            self.present(alert, animated: true, completion: nil)

        }

        if(indexPath.row == 1 && indexPath.section == 0) {
            var alert: UIAlertController=UIAlertController(title: "Выберете изображение", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let cameraAction = UIAlertAction(title: "Камера", style: UIAlertActionStyle.default) {
                _ in
                self.openCamera()
            }
            let gallaryAction = UIAlertAction(title: "Галерея", style: UIAlertActionStyle.default) {
                _ in
                self.openGallary()
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel) {
                _ in
            }

            // Add the actions
            imagePicker.delegate = self
            alert.addAction(cameraAction)
            alert.addAction(gallaryAction)
            alert.addAction(cancelAction)

            if let popoverPresentationController = alert.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            }
            self.present(alert, animated: true, completion: nil)
        }

        if(indexPath.row == 0 && indexPath.section == 2) {
            if(MFMailComposeViewController.canSendMail()) {
            let composeVC = MFMailComposeViewController()
            composeVC.delegate = self
            composeVC.mailComposeDelegate = self

            // Configure the fields of the interface.
            composeVC.setToRecipients(["bolobolbfmv@gmail.com"])

            self.present(composeVC, animated: true, completion: nil)
            } else {

                UIApplication.shared.open(URL(string: "mailto:bolobolbfmv@gmail.com")!, options: [String: Any](), completionHandler: nil)
            }
        }

        if(indexPath.row == 2 && indexPath.section == 2) {

            var alert: UIAlertController=UIAlertController(title: "Предупреждение", message: "Для удачного переноса перелогиньтесь в приложении", preferredStyle: UIAlertControllerStyle.alert)
            let Action = UIAlertAction(title: "Перелогинился", style: UIAlertActionStyle.default) {
                _ in

                Auth.auth().addStateDidChangeListener { _, user in
                    if let user = user {

                        get_favorites(u_id: "test", completion: {result in
                            for title in result {
                                add_fav_new(User_id: user.uid, Title_id: String(title.ID), Remove: 0, is_anilibria: 0)
                            }
                        })

                    }

                }
            }
            let ActionCancel = UIAlertAction(title: "Нет", style: UIAlertActionStyle.default) {
                _ in
            }

            alert.addAction(Action)
            alert.addAction(ActionCancel)

            self.present(alert, animated: true, completion: nil)

        }
        
        if(indexPath.row == 3 && indexPath.section == 2) {
            
            var alert: UIAlertController=UIAlertController(title: "Предупреждение", message: "Для удачного переноса перелогиньтесь в приложении", preferredStyle: UIAlertControllerStyle.alert)
            
                alert.addTextField { (pTextField) in
                pTextField.placeholder = "Промокод"
                pTextField.clearButtonMode = .whileEditing
                pTextField.borderStyle = .none
                }
            
            var success: UIAlertController = UIAlertController(title: "Ура вы активировали код", message: "Для удачного применения кода перезапустите приложение", preferredStyle: UIAlertControllerStyle.alert)
            success.addAction(UIAlertAction(title: "Закрыть", style: UIAlertActionStyle.default))
            var error: UIAlertController = UIAlertController(title: "Ошибка", message: "Код не найден", preferredStyle: UIAlertControllerStyle.alert)
            error.addAction(UIAlertAction(title: "Закрыть", style: UIAlertActionStyle.default))
            
            let Action = UIAlertAction(title: "Активировать", style: UIAlertActionStyle.default) {
                _ in
                
                if (alert.textFields?.first?.text == "xxx1488xxx"){
                    UserDefaults.standard.setValue(1, forKey: "SourceUnlock")
                    UserDefaults.standard.synchronize()
                    
                    self.present(success, animated: true, completion: nil)
                
                }
                
                if(alert.textFields?.first?.text == "advTEST"){
                    UserDefaults.standard.setValue(1, forKey: "ADBLOCK")
                    UserDefaults.standard.synchronize()
                    
                    self.present(success, animated: true, completion: nil)
                }
    
                self.present(error, animated: true, completion: nil)
                
                
            }
            let ActionCancel = UIAlertAction(title: "Отменить", style: UIAlertActionStyle.default) {
                _ in
            }
            
            alert.addAction(Action)
            alert.addAction(ActionCancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }

    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {

            let alertWarning = UIAlertController(title: "Ошибка", message: "У вас нет доступа к камере", preferredStyle: UIAlertControllerStyle.actionSheet)

            let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel) {
                _ in
            }
            alertWarning.addAction(cancelAction)
            self.present(alertWarning, animated: true, completion: nil)

        }
    }
    func openGallary() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        ImageProfile.image=info[UIImagePickerControllerOriginalImage] as? UIImage

        // Data in memory
        let data = UIImagePNGRepresentation(ImageProfile.image!) as! Data
        let storageRef = Storage.storage().reference()
        // Create a reference to the file you want to upload
        let userID = Auth.auth().currentUser?.uid

        let riversRef = storageRef.child("\(userID)/images/logo.jpg")

        SDImageCache.shared().removeImage(forKey: riversRef.fullPath)
        // Upload the file to the path "images/rivers.jpg"
       var  task = riversRef.putData(data, metadata: nil)

        download = true
        task.observe(.success) { _ in
            self.download = false
        }

        task.observe(.failure) { _ in
            self.download = false
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func buttonAction(sender: UIButton!) {
        if(Auth.auth().currentUser != nil) {
        add_device(Device_id: global_fcmToken, User_id: Auth.auth().currentUser!.uid, Remove: 1)
        }
        if(ButtonInCell.titleLabel?.text == "Войти") {
            let auth = FUIAuth.defaultAuthUI()
            auth?.providers = providers
            
            if let bundlePath = Bundle.main.path(forResource: "FirebaseAuthUI", ofType: "strings") {
                let bundle = Bundle(path: bundlePath)
                auth?.customStringsBundle = bundle
            }
            auth?.delegate = self
            auth?.shouldAutoUpgradeAnonymousUsers = true

            let authViewController = auth?.authViewController()
            present(authViewController!, animated: true)
        } else {
           try! Auth.auth().signOut()
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        view.backgroundColor = ThemeManager.currentTheme().backgroundTableColor
        tableView.separatorColor = ThemeManager.currentTheme().secondaryColor
        tableView.backgroundColor = ThemeManager.currentTheme().backgroundTableColor
        self.tabBarController?.tabBar.barStyle =  ThemeManager.currentTheme().barStyle
        self.navigationController?.navigationBar.barStyle = ThemeManager.currentTheme().barStyle

        if(ThemeManager.currentTheme() == .Dark) {
            switcher_outlet.isOn = true
        } else {
            switcher_outlet.isOn = false
        }

        Auth.auth().addStateDidChangeListener { auth, user in
             var res = get_news_list(page: 1)
            if let user = user {

                print("User is signed in.")

                if(!self.download) {
                    add_user(User_id: Auth.auth().currentUser!.uid)
                let storageRef = Storage.storage().reference()

                // Create a reference to the file you want to upload
                let userID = Auth.auth().currentUser?.uid

                let reference = storageRef.child("\(userID)/images/logo.jpg")

                //self.ImageProfile.sd_setImage(with: reference)
                self.ImageProfile.sd_setImage(with: reference, placeholderImage: UIImage(named: "avatar"))
                }

                if(!user.isAnonymous) {
                self.ButtonInCell.setTitle("Выйти", for: .normal)
                } else {
                    self.ButtonInCell.setTitle("Войти", for: .normal)
                }
            } else {
                print("User is signed out.")
                self.ButtonInCell.setTitle("Войти", for: .normal)
            }
        }
    }

}

extension FifthViewController: FUIAuthDelegate {

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        // handle user (`authDataResult.user`) and error as necessary
        if let error = error as NSError?,
            error.code == FUIAuthErrorCode.mergeConflict.rawValue {
            // Merge conflict error, discard the anonymous user and login as the existing
            // non-anonymous user.
            guard let credential = error.userInfo[FUIAuthCredentialKey] as? AuthCredential else {
                print("Received merge conflict error without auth credential!")
                return
            }

            Auth.auth().signInAndRetrieveData(with: credential) { (_, error) in
                if let error = error as NSError? {
                    print("Failed to re-login: \(error)")
                    return
                }
                self.ButtonInCell.setTitle("Выйти", for: .normal)
                 add_device(Device_id: global_fcmToken, User_id: Auth.auth().currentUser!.uid, Remove: 0)
                // Handle successful login
            }
        } else if let error = error {
            // Some non-merge conflict error happened.
            print("Failed to log in: \(error)")
            return
        }
    }
    /*
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
                if(username == "" ){

                      ref.child("users/\((user?.uid)!)/username").setValue("Default")
                }

                // ...
            }) { (error) in
                print(error.localizedDescription)
            }

            UserDefaults.standard.setValue(Auth.auth().currentUser?.uid, forKey: "uid")
            self.dismiss(animated: false, completion: nil)
            
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
 */

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

/*
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return customPicker!
    }
     
     
*/

}
