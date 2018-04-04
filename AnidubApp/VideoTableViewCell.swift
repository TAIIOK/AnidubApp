//
//  VideoTableViewCell.swift
//  VideoListSwift
//
//  Created by 张建军 on 16/9/7.
//  Copyright © 2016年 张建军. All rights reserved.
//

import UIKit
import PopupDialog

// 创建结构体
struct video {
    
    let image: String
    let title: String
    let source: String
    
}

class VideoTableViewCell: UIView {


    var videoWebview = UIWebView()
    let SCREEN_WITH = UIScreen.main.bounds.size.width
    let SCTREEN_HIEGTH = UIScreen.main.bounds.size.height
    var firstlist = [[episodes]]()
    var titleID = 0
    var flag = false

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func isbookmark() -> Bool{
        
        if let  student = loadUser() as? user {
            
          //  flag = is_fav(ID:(currentTitle.first?.ID)!,login:student.ID,password:student.password, userHash: "hash")
        }

        flag = false
        return flag
    
    }

    func inbookmark() -> String
    {
        if(!isbookmark()){
        return "Добавить в закладки"
        }
        return "Убрать из закладок"
    }
    
    @objc func bookmark(){
        
        var button = self.viewWithTag(2) as! UIButton
        if var  student = loadUser() as? user {
            removeUser()

        if(flag){
            student.favCount = student.favCount - 1
            //remove_fav(ID:(currentTitle.first?.ID)!,login:student.ID,password:student.password, userHash: "someHash")
            flag = false
            button.setTitle("Добавить в закладки",for: .normal)
        }else{
            student.favCount = student.favCount - 1
            flag = true
           // add_fav(ID:(currentTitle.first?.ID)!,login:student.ID,password:student.password, userHash: "someHash")
            button.setTitle("Убрать из закладки",for: .normal)
        }
            saveUser(value: student)
        }
    }

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let choosebutton = UIButton(type: UIButtonType.system)
        choosebutton.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        choosebutton.setTitle("Выберите серию", for: UIControlState.normal)
        choosebutton.addTarget(self,action: #selector(changeEpisode),for: .touchUpInside)
        choosebutton.tag = 1
        self.addSubview(choosebutton)
        let bookmarkbutton = UIButton(type: UIButtonType.system)
        bookmarkbutton.frame = CGRect(x: 155, y: 0, width: 175, height: 40)
        bookmarkbutton.setTitle(inbookmark(), for: UIControlState.normal)
        bookmarkbutton.addTarget(self,action: #selector(bookmark),for: .touchUpInside)
        bookmarkbutton.tag = 2
        self.addSubview(bookmarkbutton)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
        {
        videoWebview.frame = CGRect(x: 0 , y: 40, width: SCREEN_WITH, height: 400)
        }
        else
        {
        videoWebview.frame = CGRect(x: 0, y: 40, width: SCREEN_WITH, height: 200)
        }

        self.addSubview(videoWebview)// 背景视图

    }


    @objc func changeEpisode()
    {
        
        // Create a custom view controller
        let ratingVC = RequestViewController(nibName: "RequestViewController", bundle: nil)
        
        ratingVC.Listepisodes = firstlist
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        
        let buttonOne = CancelButton(title: "Отменить", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Выбрать", height: 60) {
            
            if(ratingVC.TypePicker.selectedRow(inComponent: 0) == 0)
            {
            self.videoWebview.loadRequest(URLRequest(url: URL(string: (self.firstlist.first?[ratingVC.SubjectPicker.selectedRow(inComponent: 0)].Url)!)!))
            }else{
            self.videoWebview.loadRequest(URLRequest(url: URL(string: (self.firstlist.last?[ratingVC.SubjectPicker.selectedRow(inComponent: 0)].Url)!)!))
            }
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
    
       self.window?.rootViewController?.present(popup, animated: true, completion: nil)
        
    }
    


}
