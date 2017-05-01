//
//  playerViewController.swift
//  AnidubApp
//
//  Created by Roman Efimov on 20.04.17.
//  Copyright © 2017 Roman Efimov. All rights reserved.
//

import UIKit


class playerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 1)
        {
            return 480
        }
        
        return UITableViewAutomaticDimension
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoTableViewCell
            
            
            cell.titleimageview.image = ImageCache[(currentTitle.first?.ID)!]
            cell.countofepisodes.text = currentTitle.first?.Information.Episodes
            cell.Country.text = currentTitle.first?.Information.Country
            cell.Dubbers.text = currentTitle.first?.Information.Dubbers
            cell.Studio.text = currentTitle.first?.Information.Studio
            cell.titledescription.text = currentTitle.first?.Information.Description
            cell.TitleDescription.text = currentTitle.first?.Title.Russian
            cell.Genries.text = currentTitle.first?.Information.Genres
            
            return cell
        }

        let newcell = VideoTableViewCell(style: .default, reuseIdentifier: "VideoTableViewCell")

        newcell.firstlist = listEpisodes

        
        return newcell
    }
    

    var listEpisodes = [[episodes]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = currentTitle.first?.Title.Russian
        

        DispatchQueue.global(qos: .background).async {
            
            self.load_episodes()
            
            let indexPath = NSIndexPath(row: 1, section: 0)
            let currentCell = self.tableView.cellForRow(at: indexPath as IndexPath) as! VideoTableViewCell
            currentCell.videoWebview.loadRequest(URLRequest(url: URL(string: (self.listEpisodes.first?[0].Url)!)!))

        }
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 266

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: "VideoTableViewCell")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        currentTitle.removeAll()
    }
    
    func load_episodes() {
    
       listEpisodes = getTitles_episodes(id: (currentTitle.first?.ID)!)
    
    }

    
}
