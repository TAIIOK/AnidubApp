//
//  InfoViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 04.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//


import UIKit
import PopupDialog
import WebKit
import Firebase

var listEpisodes = [[episodes]]()

class InfoViewController: ArticleViewController {


    var is_in_bookmark = false;

    var bookmarks = [String]()

    override func viewDidLoad() {

        
        self.tabBarController?.tabBar.isHidden = true
        autoColored = false
        imageView.image = ImageCache[(currentTitle.first?.ID)!]

        imageView.image = ImageCache[(currentTitle.first?.ID)!]
        headline = (currentTitle.first?.Title.Russian)!
        self.navigationItem.title = (currentTitle.first?.Title.Russian)!
        author = (currentTitle.first?.Information.Dubbers)! + " " + (currentTitle.first?.Information.Studio)! + " " + (currentTitle.first?.Information.Country)!
        date = NSDate() as Date
        body =  (currentTitle.first?.Information.Description)!
        //autoColored = false

        videoWebview = WKWebView()
        videoWebview.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.size.width, height: 200)

        load_episodes()


        print("PUSH2")

        view.backgroundColor = UIColor.white
        super.viewDidLoad()
         if(UserDefaults.standard.value(forKey: "uid") != nil && Database.database().reference().child(byAppendingPath: "users").child(byAppendingPath: UserDefaults.standard.value(forKey: "uid") as! String) != nil){
            get_favorites(u_id: "test", completion: {result in

                self.bookmarks = result
               // self.bookmarkButton.setTitle(self.inbookmark(),for: .normal)
            })
        }


        // Do any additional setup after loading the view, typically from a nib.
    }


    @objc func changeEpisode()
    {

        // Create a custom view controller
        let ratingVC = RequestViewController(nibName: "RequestViewController", bundle: nil)

        ratingVC.Listepisodes = listEpisodes
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)

        // Create first button

        let buttonOne = CancelButton(title: "Отменить", height: 60) {

        }

        // Create second button
        let buttonTwo = DefaultButton(title: "Выбрать", height: 60) {

         
            if(ratingVC.TypePicker.selectedRow(inComponent: 0) == 0)
            {
                self.loadRequest(urls: (listEpisodes.first?[ratingVC.SubjectPicker.selectedRow(inComponent: 0)].Url)!)

            }else{
                self.loadRequest(urls: (listEpisodes.last?[ratingVC.SubjectPicker.selectedRow(inComponent: 0)].Url)!)
            }
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])

        // Present dialog


        self.present(popup, animated: true, completion: nil)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(_ animated: Bool) {
        currentTitle.removeAll()
        print("Deleted")
        print(currentTitle.count)
        listEpisodes.removeAll()
    }

    func load_episodes() {

        let group = DispatchGroup()
        group.enter()

        DispatchQueue.global(qos:.background).async {
            listEpisodes = getTitles_episodes(id: (currentTitle.first?.ID)!)
            self.EpisodesList = listEpisodes
            group.leave()
        }

      
        group.notify(queue: .main) {
            self.loadRequest(urls: (listEpisodes.first?[0].Url)!)
        }
/*
        DispatchQueue.global(qos: .background).async {

        DispatchQueue.main.async {
            listEpisodes = getTitles_episodes(id: (currentTitle.first?.ID)!)
            self.loadRequest(urls: (listEpisodes.first?[0].Url)!)
        }
        }
 */
    }


    func isbookmark() -> Bool{


        if(bookmarks.contains(String((currentTitle.first?.ID)!)))
        {
            is_in_bookmark = true
        }

        //flag = is_fav(ID:(currentTitle.first?.ID)!,login:student.ID,password:student.password)

        return is_in_bookmark

    }

    func inbookmark() -> String
    {
        if(!isbookmark()){
            return "Добавить в закладки"
        }
        return "Убрать из закладок"
    }

    @objc func bookmark(){

            if(is_in_bookmark){

           // remove_fav(ID:(currentTitle.first?.ID)!,login:student.ID,password:student.password)
                bookmarks.remove(at: bookmarks.index(of: String((currentTitle.first?.ID)!))!)
                update_favorites(u_id:"test",appendFav:bookmarks.joined(separator:"/"))

                is_in_bookmark = false
                bookmarkButton.setTitle("Добавить в закладки",for: .normal)
            }else{
                is_in_bookmark = true
                bookmarks.append(String((currentTitle.first?.ID)!))
                update_favorites(u_id:"test",appendFav:bookmarks.joined(separator:"/"))
             //   add_fav(ID:(currentTitle.first?.ID)!,login:student.ID,password:student.password)
                bookmarkButton.setTitle("Убрать из закладок",for: .normal)
            }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        UIApplication.shared.isStatusBarHidden = false
    }

     func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.portrait.rawValue)
    }

}

