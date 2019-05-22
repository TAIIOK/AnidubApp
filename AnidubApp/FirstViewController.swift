//
//  FirstViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 02.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

import UIKit
import Firebase
import DisplaySwitcher
import GoogleMobileAds
import Material
import GoogleMobileAds

let animationDuration: TimeInterval = 0.3
let listLayoutStaticCellHeight: CGFloat = 200
let gridLayoutStaticCellHeight: CGFloat = 165
var currentTitle = [fullTitle]()
var currentNews = [News]()

class FirstViewController: UICollectionViewController, UISearchBarDelegate, GADBannerViewDelegate, GADInterstitialDelegate, UICollectionViewDelegateFlowLayout {

    var bookmarks = [fullTitle]()
     var tap: UITapGestureRecognizer!
     var isTransitionAvailable = true
    
    var selectedTabIndex = 0
    var listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .list)
     var gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .grid)
     var layoutState: LayoutState = .list

    var adsID = ["ca-app-pub-6296201459697561/4167798079", "ca-app-pub-6296201459697561/5984685895" , "ca-app-pub-6296201459697561/4467180976", "ca-app-pub-6296201459697561/4373534400", "ca-app-pub-6296201459697561/3700894215"]
    var id = 0

    @IBOutlet var source_segment: UISegmentedControl!

    
    var adsToLoad = [GADBannerView]()
    var loadStateForAds = [GADBannerView: Bool]()
    let adUnitID = "ca-app-pub-6296201459697561/2931065032"
    // A banner ad is placed in the UITableView once per `adInterval`. iPads will have a
    // larger ad interval to avoid mutliple ads being on screen at the same time.
    let adInterval = UIDevice.current.userInterfaceIdiom == .pad ? 16 : 8
    // The banner ad height.
    let adViewHeight = CGFloat(100)

     func setupCollectionView() {
       // mycollection.collectionViewLayout = listLayout
        self.collectionView?.register(UserCollectionViewCell.cellNib, forCellWithReuseIdentifier: UserCollectionViewCell.id)

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchflag) {
            return searchtitles.count
        }
        activityView.stopAnimating()
        if(self.source_segment == nil) {
             return   titleslist.count
        }
        if (id == 0) {
          return   titleslist.count
        }else if(id == 1){
            return titleslist_anilibria.count}
        return titleslist.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if(searchflag == false) {
            /*
         if let BannerView = titleslist[indexPath.row] as? GADBannerView {
            preloadNextAd()
            let reusableAdCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerViewCell",
                                                               for: indexPath)
            // Remove previous GADBannerView from the content view before adding a new one.
            for subview in reusableAdCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            reusableAdCell.contentView.addSubview(BannerView as! UIView)
            // Center GADBannerView in the table cell's content view.
            BannerView.center = reusableAdCell.contentView.center
            return reusableAdCell
        }*/
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionViewCell", for: indexPath) as! newUserCollectionViewCell

        if(searchflag == false) {
        if (id == 0 || id == 2) {
        if(indexPath.row > titleslist.count) {
            return cell
            }}
        if (id == 1) {
            if(indexPath.row > titleslist_anilibria.count) {
                return cell
            }
        }
            
        }

        if(searchflag == false) {

            if (id == 0) {
                var temp: String = (titleslist[indexPath.row] as? fullTitle)!.Title.fullName
                let index = temp.index(of: "/") ?? temp.endIndex
                let beginning = temp[..<index]
                if(temp.slice(from: "[", to: "]")! != "") {
                    var tempTitle = (titleslist[indexPath.row] as! fullTitle)
                    tempTitle.Title.Russian = String(beginning)
                    let episodes = temp.slice(from: "[", to: "]")!

                    if(!episodes.contains("из")) {
                         let end = temp[index...]
                        cell.setEpisodes(episodes: String(end).slice(from: "[", to: "]")!)
                    } else {
                        cell.setEpisodes(episodes: temp.slice(from: "[", to: "]")!)
                    }

                    titleslist[indexPath.row]  = tempTitle as AnyObject
                }
            }
            if (id == 1) {
                cell.setEpisodes(episodes: (titleslist_anilibria[indexPath.row] as? fullTitle)!.Information.Episodes)
            }
            if(id == 2){
                cell.setEpisodes(episodes: (titleslist[indexPath.row] as? News)!.Category)
            }
            if (id == 0) {
            cell.setTitle(title: (titleslist[indexPath.row] as? fullTitle)!.Title.Russian)
            cell.setGenres(genres: (titleslist[indexPath.row] as? fullTitle)!.Information.Genres)
            }
            if (id == 1) {
                cell.setTitle(title: (titleslist_anilibria[indexPath.row] as? fullTitle)!.Title.Russian)
                cell.setGenres(genres: (titleslist_anilibria[indexPath.row] as? fullTitle)!.Information.Genres)
            }
            if(id == 2){
                cell.setTitle(title: (titleslist[indexPath.row] as? News)!.Title)
                cell.setGenres(genres: (titleslist[indexPath.row] as? News)!.description)
            }
            if (id == 0) {
            if((titleslist[indexPath.row] as? fullTitle)!.Rating.Grade.contains("%")) {
                var temp_rating: String = (titleslist[indexPath.row] as? fullTitle)!.Rating.Grade
                temp_rating.removeLast()
                cell.setRating(rating: String( format: "%.1f", (5.0*Double(temp_rating)!)/100.0))

            } else {
            cell.setRating(rating: (titleslist[indexPath.row] as? fullTitle)!.Rating.Grade)
            }
            }
            if (id == 1) {
                if((titleslist_anilibria[indexPath.row] as? fullTitle)!.Rating.Grade.contains("%")) {
                    var temp_rating: String = (titleslist_anilibria[indexPath.row] as? fullTitle)!.Rating.Grade
                    temp_rating.removeLast()
                    cell.setRating(rating: String( format: "%.1f", (5.0*Double(temp_rating)!)/100.0))

                } else {
                    cell.setRating(rating: (titleslist_anilibria[indexPath.row] as? fullTitle)!.Rating.Grade)
                }
            }

        } else {

                var temp: String = searchtitles[indexPath.row ].Title.fullName
                let index = temp.index(of: "/") ?? temp.endIndex
                let beginning = temp[..<index]

                searchtitles[indexPath.row ].Title.Russian = String(beginning)
                if(temp.slice(from: "[", to: "]")! != "") {

                    let episodes = temp.slice(from: "[", to: "]")!

                    if(!episodes.contains("из")) {
                        let end = temp[index...]
                        cell.setEpisodes(episodes: String(end).slice(from: "[", to: "]")!)
                    } else {
                        cell.setEpisodes(episodes: temp.slice(from: "[", to: "]")!)

                    }
                    //searchtitles[indexPath.row].Title.Russian += " [" + temp.slice(from: "[", to: "]")! + "]"
                } else {
                    cell.setEpisodes(episodes: searchtitles[indexPath.row].Information.Episodes)
                }

            cell.setTitle(title: searchtitles[indexPath.row ].Title.Russian)
            cell.setGenres(genres: searchtitles[indexPath.row].Information.Genres)
            if(id == 1) {
            cell.setRating(rating: "0")
            } else {
                if(searchtitles[indexPath.row].Rating.Grade.contains("%")) {
                    var temp_rating: String = searchtitles[indexPath.row].Rating.Grade
                    temp_rating.removeLast()
                    cell.setRating(rating: String( format: "%.1f", (5.0*Double(temp_rating)!)/100.0))

                } else {
                    cell.setRating(rating: searchtitles[indexPath.row].Rating.Grade)
                }
            }

        }
        if(searchflag == false) {
            if (id == 0) {
        cell.setImage(image: ((titleslist[indexPath.row] as? fullTitle)?.Poster)!)
            }
            if (id == 1) {
                cell.setImage(image: ((titleslist_anilibria[indexPath.row] as? fullTitle)?.Poster)!)
            }
            if (id == 2){
                cell.setImage(image: (titleslist[indexPath.row] as? News)!.image)
            }
        } else {
           cell.setImage(image: ((searchtitles[indexPath.row] as? fullTitle)?.Poster)!)
        }
        cell.layoutIfNeeded()

        cell.backgroundColor = ThemeManager.currentTheme().backgroundCellColor
        cell.setBackgroundColor(color: ThemeManager.currentTheme().backgroundCellColor)
        cell.setTextColor(color: ThemeManager.currentTheme().TextCellColor)

        if(id == 2){
            cell.removeReting()
            if(cell.Star_view != nil) {
            cell.Star_view.removeFromSuperview()
            cell.currentRating.removeFromSuperview()
            }
            cell.genresLabel.updateConstraints()
     
        }
        return cell

    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let destination = InfoViewController() // Your destination
             if (id == 1) {
                destination.isAnilibria = true
            }
            if (id == 0) {
                destination.isAnilibria = false
            }
        
        if (id == 2){
            destination.isNews = true
        }
        
        destination.bookmarks = bookmarks
        
        navigationController?.pushViewController(destination, animated: true)

        if(searchflag==false) {
            if (id == 0) {
              currentTitle.append((titleslist[indexPath.row ] as! fullTitle))
            }
            if (id == 1) {
                currentTitle.append((titleslist_anilibria[indexPath.row ] as! fullTitle))
            }
            if(id == 2){
                currentNews.append(titleslist[indexPath.row] as! News)
            }
        } else {
            currentTitle.append(searchtitles[indexPath.row])
        }

    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(!searchflag) {

        if (self.id == 0) {
        if (indexPath.item == (titleslist.count - 7) && searchflag == false && selectedTabIndex == 0) {
                loadTitles()
           // addBannerAds()
        }
        }
        else if (self.id == 1) {
            if (indexPath.item == (titleslist_anilibria.count - 10) && searchflag == false && selectedTabIndex == 0) {
                loadTitles()
                // addBannerAds()
            }
        }
        else if(self.id == 2){
            if (indexPath.item == (titleslist.count - 7)) {
                loadNews()
                // addBannerAds()
            }
            }
            
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath) as! CollectionviewSearch
            
            
            if(selectedTabIndex != 0){
                headerView.search(status: false)
            }
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            searchflag = true
            self.collectionView?.reloadData()
            let title = searchBar.text!
            DispatchQueue.global(qos: .background).async {
                if (self.id == 0) {
                    self.searchtitles = search_string(name: title, page: 0)
                }
                if (self.id == 1) {
                    self.searchtitles = search_anilibria(mytitle: title)
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.updateViewConstraints()
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
  //          searchflag = false
   //         self.collectionView?.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchflag = false
        self.collectionView?.reloadData()
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if (UIDevice.current.userInterfaceIdiom == .pad) {
            return CGSize(width: (self.collectionView?.frame.size.width)!/2.05, height: 219 )}

        return CGSize(width: (self.collectionView?.frame.size.width)!, height: 219 )

    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTransitionAvailable = false
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isTransitionAvailable = true
    }


    @IBOutlet weak var mycollection: UICollectionView! {
    didSet {

   // mycollection.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        }

    }

    var searchflag = false
    var mytitle = "Главная"
    var titleslist = [AnyObject]()
    var titleslist_anilibria = [AnyObject]()
    //var AdvItems = [AnyObject]()
    var searchtitles = [fullTitle]()
    var page = 0
    var page_anilibria = 0
    var activityIndicatorView: UIActivityIndicatorView!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewDidAppear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = false
        print("selected Index:", selectedTabIndex)
        switch selectedTabIndex {
        case 0: print("0"); source_segment.isHidden = false; loadBookmarks(replace: false); loadTitles(); break  // Customize ViewController for tab 1
        case 1: print("1");source_segment.isHidden = true; self.navigationItem.title = "Закладки"; titleslist.removeAll(); loadBookmarks(replace: true) ;break  // Customize ViewController for tab 2
        case 2: print("2"); source_segment.isHidden = true; if(page == 0){self.page = 1}; loadNews(); break  // Customize ViewController for tab 3
        default: print("default"); break
        }

        currentTitle.removeAll()
        listEpisodes.removeAll()
        anilibria_info.removeAll()
        currentNews.removeAll()

        self.collectionView?.backgroundColor = ThemeManager.currentTheme().backgroundTableColor

        self.tabBarController?.tabBar.barStyle =  ThemeManager.currentTheme().barStyle
        self.navigationController?.navigationBar.barStyle = ThemeManager.currentTheme().barStyle

    }

    @objc func myFun() {
        self.view.viewWithTag(1)?.removeFromSuperview()
        self.view.viewWithTag(2)?.removeFromSuperview()
        self.navigationController?.isNavigationBarHidden = false
        UserDefaults.standard.setValue(0, forKey: "FirstLunch")
        UserDefaults.standard.synchronize()
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        if((UserDefaults.standard.value(forKey: "FirstLunch") as AnyObject).integerValue == nil){
            
            self.navigationController?.isNavigationBarHidden = true
            var preview =  UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            var Imageview = UIImageView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height/8, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/1.5))
            Imageview.image = UIImage(named: "Gestures_Flick")
            Imageview.alpha = 2
            Imageview.contentScaleFactor = 0
            Imageview.layer.cornerRadius = 8.0
            Imageview.clipsToBounds = true
            Imageview.tag = 1
            preview.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            preview.tag = 2
            self.view.addSubview(preview)
            self.view.addSubview(Imageview)
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(myFun), userInfo: nil, repeats: true)
        }


        navigationController?.navigationBar.isTranslucent = true
/*
        var rightSearchBarButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(FirstViewController.searchTapped))
        navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
*/
       // mycollection.delegate = self
       // mycollection.dataSource = self

        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        let refreshControlView = UIRefreshControl()
        self.collectionView?.alwaysBounceVertical = true
        refreshControlView.tintColor = UIColor.red
        refreshControlView.addTarget(self, action: #selector(myRefreshMethod), for: .valueChanged)
       // refreshControlView.addTarget(self, action: (myRefreshMethod), for: .ValueChanged)

        if #available(iOS 11.0, *) {
            self.collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
      //  source_segment.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        /*
        // add activity to main view
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        // start animating activity view
        activityView.startAnimating()
 */
        self.collectionView?.refreshControl = refreshControlView
        self.collectionView?.register(UINib(nibName: "Empty", bundle: nil), forCellWithReuseIdentifier: "BannerViewCell")
        setupCollectionView()
        
         if(((UserDefaults.standard.value(forKey: "ADBLOCK") as AnyObject).integerValue) == 0){
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.adUnitID = adsID[Int.random(in: 0 ... 4)]
        // bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test
        addBannerViewToView(bannerView)
        var test = GADRequest()
        bannerView.load(test)
        }
        
    
 
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
           id = source_segment.selectedSegmentIndex
            loadTitles()
            self.collectionView?.reloadData()
    }

    @objc func myRefreshMethod() {
        if (id == 0) {
        titleslist.removeAll()
        }
        if (id == 1) {
        titleslist_anilibria.removeAll()
        }
        self.collectionView?.reloadData()
        if(selectedTabIndex == 0) {
        loadTitles()
           if (id == 0) {
        page = 0
            }
            if (id == 1) {
            page_anilibria = 0
            }

        } else if(selectedTabIndex == 1) {
            loadBookmarks(replace: true)
        } else if(selectedTabIndex == 2) {
        loadNews()
        }
        self.collectionView?.refreshControl?.endRefreshing()

    }
/*
    @objc func hideSearchBar() {
        var rightSearchBarButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(FirstViewController.searchTapped))

        searchflag = false

        self.navigationItem.titleView = source_segment
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        self.collectionView?.refreshControl?.isEnabled = true
        self.collectionView?.reloadData()
        self.updateViewConstraints()

        let nav = UINavigationController()
        self.navigationController?.navigationBar.frame = nav.navigationBar.frame

    }

    @objc func searchTapped() {

        if(source_segment.selectedSegmentIndex == 0) {
        var rightSearchBarButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(FirstViewController.hideSearchBar))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)

        var searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Поиск тайтла"

        self.navigationItem.titleView = searchBar
        self.collectionView?.refreshControl?.isEnabled = false
        searchBar.delegate = self
        searchBar.sizeToFit()
        } else {
            var rightSearchBarButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(FirstViewController.hideSearchBar))
            self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)

            var searchBar: UISearchBar = UISearchBar()
            searchBar.placeholder = "Поиск тайтла"

            self.navigationItem.titleView = searchBar
            self.collectionView?.refreshControl?.isEnabled = false
            searchBar.delegate = self
            searchBar.sizeToFit()
        }

    }
 */
/*
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchflag = true
        self.collectionView?.reloadData()
        let title = searchBar.text!
        DispatchQueue.global(qos: .background).async {
            if (self.id == 0) {
        self.searchtitles = search_string(name: title, page: 0)
            }
            if (self.id == 1) {
                self.searchtitles = search_anilibria(mytitle: title)
            }
            DispatchQueue.main.async {
        self.collectionView?.reloadData()
          self.updateViewConstraints()
        searchBar.resignFirstResponder()
            }
        }
    }
*/
    func loadTitles() {

        DispatchQueue.global(qos: .background).async {
            var input: [fullTitle] = [fullTitle]()

            if (self.id == 0) {
             input  = getTitle_list(page: self.page )
            }
            if (self.id == 1) {

                input  = get_title_anilibria(page: self.page_anilibria)
            }
            for title in input {
                var res = -1
                if(self.id == 0) {
                for item in self.titleslist {
                    if (item is fullTitle) {
                        if( (item as? fullTitle)!.ID == title.ID) {
                           res = title.ID
                            break
                        }
                    }
                }
                }
                if(self.id == 1) {
                    for item in self.titleslist_anilibria {
                        if (item is fullTitle) {
                            if((item as? fullTitle)!.Title.Russian == title.Title.Russian) {
                                res = title.ID
                                break
                            }
                        }
                    }
                }

                if( res == -1 ) {
                    if (self.id == 0) {
                        self.titleslist.append(title as AnyObject)

                    }
                    if (self.id == 1) {
                        self.titleslist_anilibria.append(title as AnyObject)
                    }
                }
            }

            if (self.id == 0) {
            self.page = self.page + 1
            }
            if (self.id == 1) {
                self.page_anilibria = self.page_anilibria + 1
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    func loadBookmarks(replace: Bool) {
        if(selectedTabIndex == 1) {
            if (id == 0) {
                self.titleslist = bookmarks as [AnyObject]
            }
            if (id == 1) {
                self.titleslist_anilibria = bookmarks as [AnyObject]
            }
        }

        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {

                DispatchQueue.global(qos: .background).async {

                    self.bookmarks = get_fav_new(User_id: user.uid)
                    if(replace && self.selectedTabIndex == 1) {
                        if (self.id == 0) {
                            self.titleslist = self.bookmarks as [AnyObject]
                        }
                        if (self.id  == 1) {
                            self.titleslist_anilibria = self.bookmarks as [AnyObject]
                        }
                    }
                    /*
                    get_favorites(u_id: "test", completion: {result in
                        self.bookmarks = result
                        if(replace){
                        self.titleslist = result as [AnyObject]
                        self.mycollection.reloadData()
                        }
                    })
                     */
                    DispatchQueue.main.async {
                        if(replace) {
                        self.collectionView?.reloadData()
                        }
                    }
                }
            } else {
                print("User is signed out.")
                if(replace) {
                DispatchQueue.main.async {
                    if (self.id == 0) {
                        self.titleslist.removeAll()
                    }
                    if (self.id == 1) {
                        self.titleslist_anilibria.removeAll()
                    }

                    self.collectionView?.reloadData()

                }
                }
            }
        }

    }

    func loadNews() {
        DispatchQueue.global(qos: .background).async {
            self.titleslist +=  get_news_list(page: self.page) as [AnyObject]
            self.page = self.page + 1
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    // MARK: - GADBannerView delegate methods
/*
    func adViewDidReceiveAd(_ adView: GADBannerView) {
        // Mark banner ad as succesfully loaded.
        loadStateForAds[adView] = true
        // Load the next ad in the adsToLoad list.
        preloadNextAd()
    }

    func adView(_ adView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to receive ad: \(error.localizedDescription)")
        // Load the next ad in the adsToLoad list.
        preloadNextAd()
    }
*/
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    // MARK: - UITableView source data generation

    /// Adds banner ads to the tableViewItems list.
    func addBannerAds() {

        // Ensure subview layout has been performed before accessing subview sizes.
        self.collectionView?.layoutIfNeeded()
        var index = adInterval + ( loadStateForAds.count * adInterval)

        if(titleslist.count/adInterval != loadStateForAds.count && titleslist.last is fullTitle) {
            let adSize = GADAdSizeFromCGSize(
                CGSize(width: (self.collectionView?.contentSize.width)!, height: adViewHeight))

            let adView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            adView.adUnitID = adUnitID
            adView.rootViewController = self
            adView.delegate = self

            titleslist.append(adView)
            adsToLoad.append(adView)
            loadStateForAds[adView] = false
            index += adInterval
        }

    }

    /// Preload banner ads sequentially. Dequeue and load next ad from `adsToLoad` list.
    func preloadNextAd() {
        if !adsToLoad.isEmpty {
            let ad = adsToLoad.removeFirst()
            let adRequest = GADRequest()

            ad.adUnitID = "ca-app-pub-6296201459697561/3234000130"
           // adRequest.testDevices = ["04fbbf755983e9492cff3e5815f0a8e0"]
            ad.load(adRequest)
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        } else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }


}
