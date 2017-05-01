//
//  ViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

var ImageCache = [Int:UIImage]()
var currentTitle = [fullTitle]()

class ViewController: UIViewController,UICollectionViewDelegate , UICollectionViewDataSource, UISearchBarDelegate {
    
    var mytitle = ""
    @IBOutlet weak var mycollection: UICollectionView!

    var titleslist = [fullTitle]()
    var searchtitles = [fullTitle]()
    private func setupSidebarMenu() {
        if self.revealViewController() != nil {

            btnMenuButton.target = revealViewController()
            btnMenuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    var page = 0
    var searchflag = false
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    var maxpage:Int = 0

    func hideSearchBar(){
        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(ViewController.searchTapped))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        searchflag = false
        self.mycollection.reloadData()
        var navigationTitlelabel = UILabel()
        navigationTitlelabel.text = mytitle
        navigationTitlelabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        navigationTitlelabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        self.navigationController!.navigationBar.topItem!.titleView = navigationTitlelabel
    }
    
    func searchTapped(){
       
        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(ViewController.hideSearchBar))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        var searchBar:UISearchBar = UISearchBar()
        searchBar.placeholder = "Поиск тайтла"
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchflag = true
        self.mycollection.reloadData()
        searchtitles = search_string(name: searchBar.text!,page: 0)
        
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 244.0/255, green: 67.0/255, blue: 54.0/255, alpha: 1.0)
        //rgb(144, 164, 174) // rgb(239, 83, 80) //rgb(255, 82, 82) //rgb(244, 67, 54)
        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(ViewController.searchTapped))
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        
        if let  student = loadUser() as? user {
            maxpage = student.favCount/10
        }
        self.titleslist.removeAll()
        setupSidebarMenu()
        mycollection.delegate = self
        mycollection.dataSource = self
        
        
        switch state {
        case 0:
            mytitle = "Новые серии"
            page = 0
            loadTitles()
        case 1:
            title = "Случайный тайтл"
            mytitle = "Случайный тайтл"
            let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99
            page = Int(randomNum)
            loadTitles()
        
        case 5:
            mytitle = "Мои закладки"
            title = "Мои закладки"
            loadBookmarks()
        default:
            break
        }
   
    }
    
    func loadBookmarks()
    {
        DispatchQueue.global(qos: .background).async {

            if let  student = loadUser() as? user {

                self.titleslist += getFav_list(login: student.ID, password: student.password, page: self.page)
                self.page = self.page + 1
            }

            DispatchQueue.main.async {
                self.mycollection.reloadData()
            }
        }
    }
    
    func loadTitles()
    {
 
        DispatchQueue.global(qos: .background).async {
            self.titleslist += getTitle_list(page: self.page )
            self.page = self.page + 1
            
            
            DispatchQueue.main.async {
                self.mycollection.reloadData()
            }
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        
        if (indexPath.item == (titleslist.count - 5) && searchflag == false){
            if(state != 5){
            loadTitles()
            }
            else if(maxpage<=page){
            loadBookmarks()
            }

        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchflag)
        {
            return searchtitles.count
        }
        return titleslist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionViewCell", for: indexPath as IndexPath) as! CollectionViewCell
        let dishName:Int
        if(searchflag == false){
        cell.titleLabel.text = titleslist[indexPath.row].Title.Russian
        dishName = titleslist[indexPath.row].ID
        }else{
            cell.titleLabel.text = searchtitles[indexPath.row].Title.Russian
            dishName = searchtitles[indexPath.row].ID
        }
        if let dishImage = ImageCache[dishName] {
            cell.titleimageview?.image = dishImage
        }
        else {
            if(searchflag == false){
            Alamofire.request(titleslist[indexPath.row].Poster).responseImage { response in
                debugPrint(response)
                
                
                if let image = response.result.value {
                    ImageCache[dishName] = image
                    DispatchQueue.main.async(execute: {
                            cell.titleimageview?.image = image
                    })
                }
            }
            }else{
                Alamofire.request(searchtitles[indexPath.row].Poster).responseImage { response in
                    debugPrint(response)
                    
                    
                    if let image = response.result.value {
                        ImageCache[dishName] = image
                        DispatchQueue.main.async(execute: {
                            cell.titleimageview?.image = image
                        })
                    }
                }
            
            }
            
        }

        return cell
        
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as! playerViewController
        if(searchflag==false){
        currentTitle.append(titleslist[indexPath.row])
        }
        else{
        currentTitle.append(searchtitles[indexPath.row])
        }
        navigationController?.pushViewController(myVC, animated: true)
        

        print(indexPath.row)
        
    }
    
    
    
    
}

