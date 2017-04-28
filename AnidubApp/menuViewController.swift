//
//  menuViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
import PopupDialog

var state = 0

class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var usernamelabel: UILabel!
    
    @IBOutlet weak var loginbuttonoutlet: UIButton!

    @IBAction func loginbuttonaction(_ sender: Any) {
        
        if(loginbuttonoutlet.titleLabel?.text == "Выйти")
        {
            removeUser()
            usernamelabel.text = "Гость"
            loginbuttonoutlet.setTitle("Войти",for: .normal)
            return
        }
        
        
        // Create a custom view controller
        let ratingVC = LoginViewController(nibName: "loginviewcontroller", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        
        let buttonOne = CancelButton(title: "Отменить", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Выбрать", height: 60) {
            
            DispatchQueue.global(qos: .background).async {
                
                
          if let user = User_login(login: ratingVC.loginlabel.text!, password: ratingVC.passwordlabel.text!)
          {
           saveUser(value: user)
           self.usernamelabel.text = user.username
           self.loginbuttonoutlet.setTitle("Выйти",for: .normal)
           self.available = true
          }
          else{
            // create the alert
            let alert = UIAlertController(title: "Упс", message: "Логин или пароль не верен.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            }
            
             
            }
            
            
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        
        present(popup, animated: true, completion: nil)
        
        
    }

    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    
    var sections = ["Каталог","Списки"]
    
    var available  = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let  student = loadUser() as? user {
            available = true
            usernamelabel.text = student.username
            loginbuttonoutlet.setTitle("Выйти",for: .normal)
        }else{
        usernamelabel.text = "Гость"
        }
        
        ManuNameArray = ["Новые серии","Случайный тайтл","Тэги","История","Загрузки","Закладки","Новинки для меня","Список просмотренного"]
        iconArray = [UIImage(named:"home")!,UIImage(named:"message")!,UIImage(named:"map")!,UIImage(named:"setting")!]
        
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor(red: 239.0/255.0, green: 83.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor//UIColor.cyan.cgColor rgb(239, 83, 80)
        imgProfile.layer.cornerRadius = 50
        
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuViewController.singleTapping(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        
        usernamelabel.addGestureRecognizer(tapGesture)
        imgProfile.addGestureRecognizer(tapGesture)

        self.tblTableView.backgroundColor = UIColor(red: 55.0/255, green: 71.0/255, blue: 79.0/255, alpha: 1)
        
        
        let rowToSelect:IndexPath = IndexPath(row: 0, section: 0) //slecting 0th row with 0th section
        self.tblTableView.selectRow(at: rowToSelect, animated: false, scrollPosition: .none)
        // Do any additional setup after loading the view.
    }

    func singleTapping(gesture: UIGestureRecognizer) {
        print("image clicked")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 5}
        
        return 3
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        if(indexPath.section > 0 )
        {
            cell.lblMenuname.text! = ManuNameArray[indexPath.row + 5]
        }
        else{
        cell.lblMenuname.text! = ManuNameArray[indexPath.row]
        }
        cell.backgroundColor = UIColor.clear
        cell.imgIcon.image = iconArray[3]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            pushFrontViewController(identifer: "firstViewController")
            state = 0
        case (0,1):
            pushFrontViewController(identifer: "firstViewController")
            state = 1
        case (1,0):
            if(available){
            pushFrontViewController(identifer: "firstViewController")
            state = 5
            }else
            {
                // create the alert
                let alert = UIAlertController(title: "Упс", message: "Вы должны залогиниться в свой профиль.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        case (1,1):
            if(available){
               // pushFrontViewController(identifer: "firstViewController")
            }else
            {
                // create the alert
                let alert = UIAlertController(title: "Упс", message: "Вы должны залогиниться в свой профиль.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        case (1,2):
            if(available){
                pushFrontViewController(identifer: "firstViewController")
            }else
            {
                // create the alert
                let alert = UIAlertController(title: "Упс", message: "Вы должны залогиниться в свой профиль.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]

    }
    
    private func pushFrontViewController(identifer: String) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: identifer) as? UINavigationController
        self.revealViewController().pushFrontViewController(controller, animated: true)
    }


}
