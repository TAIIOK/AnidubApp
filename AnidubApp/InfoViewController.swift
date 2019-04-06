//
//  InfoViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 04.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//


import UIKit
import WebKit
import Firebase

var listEpisodes = [[episodes]]()

var showAdv = false

var anilibria_info = [fullTitle]()

class InfoViewController: ArticleViewController ,GADInterstitialDelegate  {


    var is_in_bookmark = false;

    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {

        
        self.tabBarController?.tabBar.isHidden = true
        autoColored = false

        //imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.sd_setImage(with: URL(string: (currentTitle.first?.Poster)!), placeholderImage: nil, options: .highPriority, progress: nil, completed: nil)
        headline = (currentTitle.first?.Title.Russian)!
        self.navigationItem.title = (currentTitle.first?.Title.Russian)!
        author = (currentTitle.first?.Information.Dubbers)! + " " + (currentTitle.first?.Information.Studio)! + " " + (currentTitle.first?.Information.Country)!
        date = NSDate() as Date
        body =  (currentTitle.first?.Information.Description)!
        //autoColored = false
        if((currentTitle.first?.Information.Release.contains("anilibria"))!){
            isAnilibria = true
            
        }
        if(!isAnilibria){
            load_episodes()}
        
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "favorite_border_black_24pt"), style: .plain, target: self, action: #selector(InfoViewController.bookmark))
 
        navigationItem.setRightBarButtonItems([leftBarButtonItem], animated: true)

        print("PUSH2")

        view.backgroundColor = UIColor.white
        super.viewDidLoad()
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-6296201459697561/1732940532")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
  
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
         self.inbookmark()
         DispatchQueue.global(qos: .background).async {
           
        self.episodes_mark =  get_episodes_new(User_id:Auth.auth().currentUser!.uid,Title_id:(currentTitle.first?.ID)!)
        
         DispatchQueue.main.async {
        self.update_table()
        }
        }
        if ((self.isAnilibria && anilibria_info.isEmpty) || (currentTitle.first?.Information.Release.contains("anilibria"))!){
        DispatchQueue.global(qos: .background).async {
            
            if((currentTitle.first?.Information.Release.contains("anilibria"))!){
                anilibria_info = get_currenttitle_anilibria(url: (currentTitle.first?.Information.Release)!)
                }else{
                anilibria_info = get_currenttitle_anilibria(url: (currentTitle.first?.Url)!)
                }
            DispatchQueue.main.async {
                self.update_info()
            }
        }
        }
        
        if showAdv {
             showAdv = false
            interstitial = createAndLoadInterstitial()
        } else {
            print("Ad wasn't ready")
            showAdv = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
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
                self.loadRequest()
        }
    }

    

    func isbookmark() -> Bool{

        for item in bookmarks{
            
            if(item.ID == currentTitle.first?.ID){
                is_in_bookmark = true
                break
            }else{
                is_in_bookmark = false
            }
            
        }

        //flag = is_fav(ID:(currentTitle.first?.ID)!,login:student.ID,password:student.password)

        return is_in_bookmark

    }

    func inbookmark()
    {
        if(isbookmark()){
           navigationItem.rightBarButtonItems?.first?.image = UIImage(named: "favorite_black_24pt")
        }else{
        navigationItem.rightBarButtonItems?.first?.image = UIImage(named: "favorite_border_black_24pt")
        }
    }

    @objc func bookmark(){

    
            if(is_in_bookmark){

           // remove_fav(ID:(currentTitle.first?.ID)!,login:student.ID,password:student.password)
                bookmarks = bookmarks.filter {$0.ID != currentTitle.first?.ID}
                update_favorites(title: currentTitle.first!,update: false)
                if(isAnilibria){
                    add_fav_new(User_id:Auth.auth().currentUser!.uid,Title_id:(currentTitle.first?.Title.Russian)!,Remove:1, is_anilibria: 1)
                }
                if(!isAnilibria){
                    add_fav_new(User_id:Auth.auth().currentUser!.uid,Title_id:String((currentTitle.first?.ID)!),Remove:1, is_anilibria: 0)
                }
                is_in_bookmark = false
                inbookmark()
            }else{
                is_in_bookmark = true
                bookmarks.append(currentTitle.first!)
                update_favorites(title: currentTitle.first!,update: true)
                if(isAnilibria){
                    add_fav_new(User_id:Auth.auth().currentUser!.uid,Title_id:(currentTitle.first?.Title.Russian)!,Remove:0, is_anilibria: 1)
                }
                if(!isAnilibria){
                    add_fav_new(User_id:Auth.auth().currentUser!.uid,Title_id:String((currentTitle.first?.ID)!),Remove:0, is_anilibria: 0)
                }
             //   add_fav(ID:(currentTitle.first?.ID)!,login:student.ID,password:student.password)
                inbookmark()
            }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        UIApplication.shared.isStatusBarHidden = false
    }

    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        ad.present(fromRootViewController: self)
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }

}

