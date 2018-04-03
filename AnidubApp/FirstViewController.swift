//
//  FirstViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 02.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

extension Array where Element: Equatable {

    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }

    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
}


var ImageCache = [Int:UIImage]()
var currentTitle = [fullTitle]()

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension String {
    func slice(from: String, to: String) -> String? {

        var result = (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
        if result == nil{
            return ""
        }
        return result
    }
}


extension FirstViewController : UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/2, height: collectionViewWidth/2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}



class FirstViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource, UISearchBarDelegate {

    


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

        cell.titleLabel.sizeToFit()
        if(searchflag == false){

          //  cell.titleLabel.font = UIFont(name: "Optima-Ragular", size: 16)
            if(titleslist[indexPath.row].Title.Russian == ""){
                var temp:String = titleslist[indexPath.row].Title.fullName
                let index = temp.index(of: "/") ?? temp.endIndex
                let beginning = temp[..<index]

                titleslist[indexPath.row].Title.Russian = String(beginning) + " [" + temp.slice(from: "[", to: "]")! + "]"
            }
            cell.titleLabel.text = titleslist[indexPath.row].Title.Russian
            print(titleslist[indexPath.row].Title.Russian)
            dishName = titleslist[indexPath.row].ID
        }else{

            if(searchtitles[indexPath.row].Title.Russian == ""){
                var temp:String = searchtitles[indexPath.row].Title.fullName
                let index = temp.index(of: "/") ?? temp.endIndex
                let beginning = temp[..<index]

                searchtitles[indexPath.row].Title.Russian = String(beginning)
                if(temp.slice(from: "[", to: "]")! != ""){
                    searchtitles[indexPath.row].Title.Russian += " [" + temp.slice(from: "[", to: "]")! + "]"
                }


            }


          //  cell.titleLabel.font = UIFont(name: "Optima-Ragular", size: 16)
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

       // let myVC = storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as! playerViewController
        if(searchflag==false){
            currentTitle.append(titleslist[indexPath.row])
        }
        else{
            currentTitle.append(searchtitles[indexPath.row])
        }
       // navigationController?.pushViewController(myVC, animated: true)


        print(indexPath.row)

    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {


        if (indexPath.item == (titleslist.count - 5) && searchflag == false){
                loadTitles()
        }

    }

    



    
    @IBOutlet weak var mycollection: UICollectionView!
    
    @IBOutlet weak var FirstNavigationBar: UINavigationBar!

    var searchflag = false
    var mytitle = ""
    var titleslist = [fullTitle]()
    var searchtitles = [fullTitle]()
    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarView?.backgroundColor = .blue

        FirstNavigationBar.titleTextAttributes = [ kCTFontAttributeName: UIFont(name: "Optima-Italic", size: 16)!] as [NSAttributedStringKey : Any]

        FirstNavigationBar.backgroundColor = UIColor(red: 200.0/255, green: 56.0/255, blue: 55.0/255, alpha: 0.0)

        FirstNavigationBar.isTranslucent = false
        FirstNavigationBar.barTintColor = UIColor(red: 200.0/255, green: 56.0/255, blue: 55.0/255, alpha: 0.5)


        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(FirstViewController.searchTapped))

        let navItem = UINavigationItem()
        navItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        FirstNavigationBar.items = [navItem]

        /*
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        mycollection.collectionViewLayout = layout
         */
        mycollection.delegate = self
        mycollection.dataSource = self

        loadTitles()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func hideSearchBar(){
        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(FirstViewController.searchTapped))

        searchflag = false
        let navItem = UINavigationItem()
        navItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)

        FirstNavigationBar.items = [navItem]
        self.mycollection.reloadData()
        var navigationTitlelabel = UILabel()
        navigationTitlelabel.text = mytitle
        navigationTitlelabel.font = UIFont(name: "Optima-Italic", size: 16)
        navigationTitlelabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)


        FirstNavigationBar.topItem!.titleView = navigationTitlelabel
    }

    @objc func searchTapped(){

        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(FirstViewController.hideSearchBar))
        let navItem = UINavigationItem()
        navItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        var searchBar:UISearchBar = UISearchBar()
        searchBar.placeholder = "Поиск тайтла"
        navItem.titleView = searchBar
        FirstNavigationBar.items = [navItem]
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

    func loadTitles()
    {

        DispatchQueue.global(qos: .background).async {
            let input  = getTitle_list(page: self.page )
            for title in input
            {
                let res = self.titleslist.index{ $0.ID == title.ID }
                if( res == nil )
                {
                    self.titleslist.append(title)
                }
            }

            self.page = self.page + 1


            DispatchQueue.main.async {
                self.mycollection.reloadData()
            }
        }


    }




}

