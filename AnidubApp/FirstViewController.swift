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

import DisplaySwitcher

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




let animationDuration: TimeInterval = 0.3

let listLayoutStaticCellHeight: CGFloat = 200
let gridLayoutStaticCellHeight: CGFloat = 165


class FirstViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource, UISearchBarDelegate {




     var tap: UITapGestureRecognizer!

     var isTransitionAvailable = true
    var listLayout = DisplaySwitchLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .list)
     var gridLayout = DisplaySwitchLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .grid)
     var layoutState: LayoutState = .list


     func setupCollectionView() {
        mycollection.collectionViewLayout = listLayout
        mycollection.register(UserCollectionViewCell.cellNib, forCellWithReuseIdentifier:UserCollectionViewCell.id)
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchflag)
        {
            return searchtitles.count
        }
        return titleslist.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.id, for: indexPath) as! UserCollectionViewCell
        if layoutState == .grid {
            cell.setupGridLayoutConstraints(1, cellWidth: cell.frame.width)
        } else {
            cell.setupListLayoutConstraints(1, cellWidth: cell.frame.width)
        }


        let dishName:Int

        
        if(searchflag == false){

          //  cell.titleLabel.font = UIFont(name: "Optima-Ragular", size: 16)
            if(titleslist[indexPath.row].Title.Russian == ""){
                var temp:String = titleslist[indexPath.row].Title.fullName
                let index = temp.index(of: "/") ?? temp.endIndex
                let beginning = temp[..<index]

                titleslist[indexPath.row].Title.Russian = String(beginning) + " [" + temp.slice(from: "[", to: "]")! + "]"
            }
            cell.setTitle(title:titleslist[indexPath.row].Title.Russian)
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
            cell.setTitle(title:searchtitles[indexPath.row].Title.Russian)

            dishName = searchtitles[indexPath.row].ID
        }
        if let dishImage = ImageCache[dishName] {
            cell.setImage(image: dishImage)
        }
        else {
            if(searchflag == false){
                Alamofire.request(titleslist[indexPath.row].Poster).responseImage { response in
                    debugPrint(response)


                    if let image = response.result.value {
                        ImageCache[dishName] = image
                        DispatchQueue.main.async(execute: {
                            cell.setImage(image: image)
                        })
                    }
                }
            }else{
                Alamofire.request(searchtitles[indexPath.row].Poster).responseImage { response in
                    debugPrint(response)


                    if let image = response.result.value {
                        ImageCache[dishName] = image
                        DispatchQueue.main.async(execute: {
                            cell.setImage(image: image)
                            
                        })
                    }
                }

            }

        }


       // cell.bind(searchUsers[(indexPath as NSIndexPath).row])
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

       // let storyboard1 = UIStoryboard(name: "Main", bundle: nil)


        let destination = InfoViewController() // Your destination
        navigationController?.pushViewController(destination, animated: true)
       // let myVC = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        if(searchflag==false){
            currentTitle.append(titleslist[indexPath.row])
        }
        else{
            currentTitle.append(searchtitles[indexPath.row])
        }

       // navigationController?.pushViewController(myVC, animated: true)
        print("PUSH")

        print(indexPath.row)

    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {


        if (indexPath.item == (titleslist.count - 5) && searchflag == false){
                loadTitles()
        }

    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTransitionAvailable = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isTransitionAvailable = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    
    @IBOutlet weak var mycollection: UICollectionView!

    var searchflag = false
    var mytitle = ""
    var titleslist = [fullTitle]()
    var searchtitles = [fullTitle]()
    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()



//        UIApplication.shared.statusBarView?.backgroundColor = .blue


        navigationController?.navigationBar.isTranslucent = true


        //rgb(68, 55, 83); 200 56 55
        //rgb(144, 164, 174) // rgb(239, 83, 80) //rgb(255, 82, 82) //rgb(244, 67, 54)
        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(FirstViewController.searchTapped))
        navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)

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

        setupCollectionView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @objc func hideSearchBar(){
        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(FirstViewController.searchTapped))

        searchflag = false
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        self.mycollection.reloadData()
        var navigationTitlelabel = UILabel()
        navigationTitlelabel.text = mytitle
        navigationTitlelabel.font = UIFont(name: "Optima-Italic", size: 16)
        navigationTitlelabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)


        self.navigationController!.navigationBar.topItem!.titleView = navigationTitlelabel
    }

    @objc func searchTapped(){

        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(FirstViewController.hideSearchBar))
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

