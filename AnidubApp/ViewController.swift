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

class ViewController: UIViewController,UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    @IBOutlet weak var mycollection: UICollectionView!
    
    var titleslist = [fullTitle]()
    private func setupSidebarMenu() {
        if self.revealViewController() != nil {
            /*
            self.revealViewController().rearViewRevealDisplacement = 0
            self.revealViewController().rearViewRevealOverdraw = 0
            self.revealViewController().rearViewRevealWidth = 275
            self.revealViewController().frontViewShadowRadius = 0
            */
            btnMenuButton.target = revealViewController()
            btnMenuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    var page = 0
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    var maxpage:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let  student = loadUser() as? user {
            maxpage = student.favCount/10
        }
        self.titleslist.removeAll()
        setupSidebarMenu()
        mycollection.delegate = self
        mycollection.dataSource = self
        
        
        switch state {
        case 0:
            page = 0
            loadTitles()
        case 1:
            title = "Случайный тайтл"
            let randomNum:UInt32 = arc4random_uniform(100) // range is 0 to 99
            page = Int(randomNum)
            loadTitles()
        
        case 5:
            title = "Мои закладки"
            loadBookmarks()
        default:
            break
        }

        

        
    }
    
    func loadBookmarks()
    {
     
        DispatchQueue.global(qos: .background).async {
            // Background Thread
            //self.titleslist += getTitles_list(page: self.page )
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
            // Background Thread
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

        if indexPath.item == (titleslist.count - 5) {
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
        return titleslist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionViewCell", for: indexPath as IndexPath) as! CollectionViewCell
        
        cell.titleLabel.text = titleslist[indexPath.row].Title.Russian
        
        
        let dishName = titleslist[indexPath.row].ID
        
        //This is a workaround to cash the image and improve the performance while user scrolling UITableView.
        // If this image is already cached, don't re-download
        if let dishImage = ImageCache[dishName] {
            cell.titleimageview?.image = dishImage
        }
        else {
            //Download image
            // We should perform this in a background thread

            
            Alamofire.request(titleslist[indexPath.row].Poster).responseImage { response in
                debugPrint(response)
                
                if let image = response.result.value {
                    // Store the commit date in to our cache
                    ImageCache[dishName] = image
                    // Update the cell
                    DispatchQueue.main.async(execute: {
                            cell.titleimageview?.image = image
                    })
                }
            }
            
            
            
            
            
        }

        return cell
        
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as! playerViewController

        currentTitle.append(titleslist[indexPath.row])
        navigationController?.pushViewController(myVC, animated: true)
        

        print(indexPath.row)
        
    }
    
    
    
    
}

