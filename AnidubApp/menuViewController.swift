//
//  menuViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    
    var sections = ["Каталог","Списки"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ManuNameArray = ["Новые серии","Случайный тайтл","Тэги","История","Загрузки","Закладки","Новинки для меня","Хочу посмотреть","Список прочитанного","Мое избранное"]
        iconArray = [UIImage(named:"home")!,UIImage(named:"message")!,UIImage(named:"map")!,UIImage(named:"setting")!]
        
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor.cyan.cgColor
        imgProfile.layer.cornerRadius = 50
        
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true
        
        let rowToSelect:IndexPath = IndexPath(row: 0, section: 0) //slecting 0th row with 0th section
        self.tblTableView.selectRow(at: rowToSelect, animated: false, scrollPosition: .none)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
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
        cell.imgIcon.image = iconArray[3]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        
        switch indexPath.row {
        case 0:
            pushFrontViewController(identifer: "firstViewController")
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
