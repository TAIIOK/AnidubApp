//
//  playerViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 20.04.17.
//  Copyright © 2017 Roman Efimov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import AVFoundation
import AVKit
import MediaPlayer

class playerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!

    
    var playViewController = AVPlayerViewController()
    
    var playerView = AVPlayer()
    

    var changeButton = UIButton()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ButtonDidClcik()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 1)
        {
            return 400
        }
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoTableViewCell
            
            
            cell.titleimageview.image = ImageCache[(currentTitle.first?.ID)!]
            cell.nameTitle.text = "lol"
            
            return cell
        }

        let newcell = VideoTableViewCell(style: .default, reuseIdentifier: "VideoTableViewCell")
        
        //let video = data[indexPath.row]
        
        //newcell.delegate = self
        newcell.videoTitleLabel.text = "lol"
        newcell.videoScreenshot.image = ImageCache[(currentTitle.first?.ID)!]
        newcell.videoSourceLabel.text = "lol"
        

        
        
        return newcell
    }
    

    func ButtonDidClcik() {
        print("xyi")
        var videoUrl = NSURL(string: "http://www.ebookfrenzy.com/ios_book/movie/movie.mov")
    
        
        playerView = AVPlayer(url: videoUrl as! URL)
        
        playViewController.player = playerView
        
        self.present(playViewController, animated: true) {
            self.playViewController.player?.play()
        }
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoTableViewCell")
    }

    
}
