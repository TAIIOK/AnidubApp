//
//  InfoViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 04.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//


import UIKit
import PopupDialog
import MRArticleViewController
import WebKit

var listEpisodes = [[episodes]]()

class InfoViewController: ArticleViewController {

    override func viewDidLoad() {

        autoColored = false
        imageView.image = ImageCache[(currentTitle.first?.ID)!]
        let choosebutton = UIButton(type: UIButtonType.system)
        choosebutton.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        choosebutton.setTitle("Выберите серию", for: UIControlState.normal)
        choosebutton.addTarget(self,action: #selector(changeEpisode),for: .touchUpInside)
        choosebutton.tag = 1

         episodeButton = choosebutton

        imageView.image = ImageCache[(currentTitle.first?.ID)!]
        headline = (currentTitle.first?.Title.Russian)!
        author = (currentTitle.first?.Information.Dubbers)! + (currentTitle.first?.Information.Studio)! + (currentTitle.first?.Information.Country)!
        date = NSDate() as Date
        body =  (currentTitle.first?.Information.Description)!
        //autoColored = false

        videoWebview = WKWebView()
        videoWebview.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.size.width, height: 200)

        load_episodes()


        print("PUSH2")

        view.backgroundColor = UIColor.white
        super.viewDidLoad()




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

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        UIApplication.shared.isStatusBarHidden = false
    }

     func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.portrait.rawValue)
    }

}

