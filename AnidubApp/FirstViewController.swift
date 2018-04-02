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



class FirstViewController: UIViewController , UISearchBarDelegate {
    @IBOutlet weak var FirstNavigationBar: UINavigationBar!

    var searchflag = false
    var mytitle = ""
    var titleslist = [fullTitle]()
    var searchtitles = [fullTitle]()

    override func viewDidLoad() {
        super.viewDidLoad()

        FirstNavigationBar.titleTextAttributes = [ kCTFontAttributeName: UIFont(name: "Optima-Italic", size: 16)!] as [NSAttributedStringKey : Any]

        FirstNavigationBar.backgroundColor = UIColor(red: 200.0/255, green: 56.0/255, blue: 55.0/255, alpha: 0.0)

        FirstNavigationBar.isTranslucent = false
        FirstNavigationBar.barTintColor = UIColor(red: 200.0/255, green: 56.0/255, blue: 55.0/255, alpha: 0.5)


        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(FirstViewController.searchTapped))

        let navItem = UINavigationItem()
        navItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)
        FirstNavigationBar.items = [navItem]

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
        //self.mycollection.reloadData()
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
       // self.mycollection.reloadData()
        searchtitles = search_string(name: searchBar.text!,page: 0)

        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
    }

}

