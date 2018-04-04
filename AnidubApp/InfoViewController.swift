//
//  InfoViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 04.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

//
//  SecondViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 02.04.2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

import UIKit

import MRArticleViewController

class InfoViewController: ArticleViewController {

    override func viewDidLoad() {

        autoColored = true
        imageView.image = ImageCache[(currentTitle.first?.ID)!]
        super.viewDidLoad()



        imageView.image = ImageCache[(currentTitle.first?.ID)!]
        headline = (currentTitle.first?.Title.Russian)!
        author = (currentTitle.first?.Information.Dubbers)! + (currentTitle.first?.Information.Studio)! + (currentTitle.first?.Information.Country)!
        date = NSDate() as Date
        body =  (currentTitle.first?.Information.Description)!
        autoColored = true

        print("PUSH2")
        // Do any additional setup after loading the view, typically from a nib.
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(_ animated: Bool) {
        currentTitle.removeAll()
        print("Deleted")
        print(currentTitle.count)
    }

}

