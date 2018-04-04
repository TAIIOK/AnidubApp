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

        super.viewDidLoad()

        imageView.image = UIImage(named: "TestPic")!
        headline = "Dreamers go deeper than ever before, help man find pinwheel"
        author = "Christopher Nolan"
        date = NSDate() as Date
        body =  " bodyText"
        autoColored = true

        print("PUSH2")
        // Do any additional setup after loading the view, typically from a nib.
    }

  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

