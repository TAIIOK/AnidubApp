//
//  ViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 18.04.17.
//  Copyright © 2017 Roman Efimov. All rights reserved.
//

import UIKit
import SideMenu


struct NewsData{
    var link:String
    var title:String
    var imagelink:String
}

extension String  {
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


extension UIImage {
    
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var newsTableView: UITableView!

    
    var newsData: [NewsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!

        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        let appScreenRect: CGRect = UIScreen.main.bounds
        SideMenuManager.menuWidth = max(round(min((appScreenRect.width), (appScreenRect.height)) * 0.15), 240)
        //SideMenuManager.menuShadowColor = UIColor(red: 41 , green: 182, blue: 246, alpha: 1)
        SideMenuManager.menuAnimationBackgroundColor = UIColor(red: 66.0/255 , green: 66.0/255 , blue: 66.0/255 , alpha: 1.0)
        SideMenuManager.menuAllowPushOfSameClassTwice = false
        SideMenuManager.menuFadeStatusBar = false
        
        // Data model: These strings will be the data for the table view cells
        
        // Register the table view cell class and its reuse id

        // This view controller itself will provide the delegate methods and row data for the table view.
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData()
    {
        let url = "http://vstu.ru/archive/news/index.html"
        
        
        guard let myURL = URL (string : url) else {
            print ("Error")
            return
        }
        
        
        
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.newsData.count)
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = self.newsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // set the text from the data model
        cell.textLabel?.font = cell.textLabel?.font.withSize(14)
        cell.textLabel?.text = self.newsData[indexPath.row].title
        let  image : UIImage = UIImage(named: "Elefant")!
        cell.imageView?.downloadedFrom(link: self.newsData[indexPath.row].imagelink)
        cell.imageView?.image = image.imageResize(sizeChange: CGSize(width: 80, height: 80))
        return (cell)
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }

}

