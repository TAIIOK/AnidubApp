//
//  ArticleViewController.swift
//  Pods
//
//  Created by Matthew Rigdon on 8/16/16.
//
//

import UIKit
import WebKit

open class ArticleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(EpisodesList.count > 0 ){
            return ((EpisodesList.first?.count)!)}
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        
        cell.textLabel!.text = (EpisodesList.first as! [episodes])[indexPath.row].Name
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "WebPlayer") as! WebPlayerController
    
        let navController = UINavigationController(rootViewController: newViewController)
        
        self.navigationController?.present(navController, animated: true, completion: nil)
    */
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebPlayer") as! WebPlayerController
        
        vc.loadVideo(urls: (EpisodesList.first?.first as! episodes).Url)
        navigationController?.pushViewController(vc, animated: true)
        
 
    }
    
    var complete:Bool = false
    {
        didSet{
            if complete {
                comp = "Удалить из просмотренного"
            }
            else{
                comp = "Добавить в просмотренное"
            }
        }
    }
    var comp:String = "Добавить в просмотренное"
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        
        let cell = tableView.cellForRow(at: indexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark){
            complete = true
        }
        else{
            complete = false
        }
        let completeAction = UITableViewRowAction(style: .normal, title: "\(comp)", handler: { (action, indexPath) in

            if action.title == "Добавить в просмотренное"{
                self.complete = true
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else{
                self.complete = false
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
            tableView.setEditing(false, animated: true)
        })

         completeAction.backgroundColor = UIColor(red: 0, green: 0.6588, blue: 0.9176, alpha: 1.0)
    
        
        
        return [completeAction]
    }

    // MARK: - Public properties
    
    open let imageView = UIImageView()

    open var autoColored: Bool = false

    open var episodeButton = UIButton()

    open var bookmarkButton = UIButton()

    open var videoWebview = WKWebView()

    open var EpisodesList = [[Any?]]()
    
    
    open var headline: String = "" {
        didSet {
            headlineLabel.text = headline
        }
    }
    
    open var author: String = "" {
        didSet {
            authorLabel.text = "by \(author)"
        }
    }
    
    open var date: Date = Date() {
        didSet {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .long
            dateLabel.text = formatter.string(from: date)
        }
    }
    
    open var body: String = "" {
        didSet {
            bodyLabel.text = body
        }
    }
    
    open var backgroundColor: UIColor = UIColor.white {
        didSet {
            backgroundColorSet = true
            backgroundView.backgroundColor = backgroundColor
            videoWebview.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        }
    }

    
    open var headlineColor: UIColor = UIColor.black {
        didSet {
            headlineColorSet = true
            headlineLabel.textColor = headlineColor
        }
    }
    
    open var dateColor: UIColor = UIColor.black {
        didSet {
            dateColorSet = true
            dateLabel.textColor = dateColor
        }
    }
    
    open var authorColor: UIColor = UIColor.black {
        didSet {
            authorColorSet = true
            authorLabel.textColor = authorColor
        }
    }
    
    open var bodyColor: UIColor = UIColor.black {
        didSet {
            bodyColorSet = true
            bodyLabel.textColor = bodyColor
        }
    }
    
    // MARK: - Private Properties
    
    fileprivate let scrollView = UIScrollView()
    fileprivate let backgroundView = UIView()
    fileprivate let headlineLabel = UILabel()
    fileprivate let authorLabel = UILabel()
    fileprivate let dateLabel = UILabel()
    fileprivate let divider = UIView()
    fileprivate let bodyLabel = UILabel()
    fileprivate let tableView: UITableView = UITableView()
    
    fileprivate var backgroundColorSet = false
    fileprivate var headlineColorSet = false
    fileprivate var dateColorSet = false
    fileprivate var authorColorSet = false
    fileprivate var bodyColorSet = false

    // MARK: - UIViewController
    
    override open func viewDidLoad() {

        
        // if autoColored, setup after extracting color; otherwise, setup now.
        if autoColored {
            imageView.image?.getColors { colors in
                self.backgroundColor = self.backgroundColorSet ? self.backgroundColor : colors.background
                self.headlineColor = self.headlineColorSet ? self.headlineColor : colors.primary
                self.dateColor = self.dateColorSet ? self.dateColor : colors.detail
                self.authorColor = self.authorColorSet ? self.authorColor : colors.secondary
                self.bodyColor = self.bodyColorSet ? self.bodyColor : colors.detail
                self.setupUI()

            }
        } else {
            setupUI()
        }

         super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.tag = 100
        tableView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIDeviceOrientationDidChange, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIWindowDidBecomeVisible, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIWindowDidBecomeHidden, object: nil)


    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Methods
    
    open func setupUI() {
        
        setupScrollView()
        setupImageView()
        setupHeadline()
        setupAuthor()
        setupDate()
        setupBody()
        setupChoose()
 
       // setupWeb()
 
       // setupEpisodesTable()
    }

    open func loadRequest(urls:String){
        
        
        
        DispatchQueue.main.async {
            self.setupEpisodesTable()
            self.tableView.reloadData()
        }
        /*
        let web = backgroundView.viewWithTag(90) as! WKWebView

        let url = URL(string: urls)!

        web.load(URLRequest(url: url))
 */
    }
 
    fileprivate func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(backgroundView)
        NSLayoutConstraint(item: backgroundView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundView, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundView, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.bounds.width).isActive = true
    }
    
    fileprivate func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(imageView)
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: backgroundView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.bounds.width).isActive = true
    }
    
    fileprivate func setupHeadline() {
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(headlineLabel)
        NSLayoutConstraint(item: headlineLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: headlineLabel, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 14).isActive = true
        NSLayoutConstraint(item: headlineLabel, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -24).isActive = true
        headlineLabel.numberOfLines = 0
        headlineLabel.sizeToFit()
        headlineLabel.font = UIFont(name: "HelveticaNeue-Light", size: 36)
    }
    
    fileprivate func setupAuthor() {
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(authorLabel)
        NSLayoutConstraint(item: authorLabel, attribute: .top, relatedBy: .equal, toItem: headlineLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: authorLabel, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 14).isActive = true
        NSLayoutConstraint(item: authorLabel, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -14).isActive = true
        authorLabel.numberOfLines = 0
        authorLabel.sizeToFit()
        authorLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 12)
    }
    
    fileprivate func setupDate() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(dateLabel)
        NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: authorLabel, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: dateLabel, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 14).isActive = true
        NSLayoutConstraint(item: dateLabel, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -14).isActive = true
        dateLabel.numberOfLines = 0
        dateLabel.sizeToFit()
        dateLabel.font = UIFont(name: "HelveticaNeue", size: 12)
    }
    
    fileprivate func setupBody() {
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(bodyLabel)
        
        NSLayoutConstraint(item: bodyLabel, attribute: .top, relatedBy: .equal, toItem: dateLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: bodyLabel, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 14).isActive = true
        NSLayoutConstraint(item: bodyLabel, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -14).isActive = true
        bodyLabel.numberOfLines = 0
        bodyLabel.sizeToFit()
        bodyLabel.font = UIFont(name: "Georgia", size: 20)

    }

    fileprivate func setupChoose(){


        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(bookmarkButton)


        NSLayoutConstraint(item: bookmarkButton, attribute: .top, relatedBy: .equal, toItem: bodyLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: bookmarkButton, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 14).isActive = true
        NSLayoutConstraint(item: bookmarkButton, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -14).isActive = true


        episodeButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(episodeButton)

        NSLayoutConstraint(item: episodeButton, attribute: .top, relatedBy: .equal, toItem: bookmarkButton, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: episodeButton, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 14).isActive = true
        NSLayoutConstraint(item: episodeButton, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -14).isActive = true

    }


    fileprivate func setupWeb() {
        videoWebview.translatesAutoresizingMaskIntoConstraints = false

        videoWebview.tag = 90

        videoWebview.scrollView.bounces = false
        videoWebview.scrollView.isScrollEnabled = false
        videoWebview.isOpaque = false
        backgroundView.addSubview(videoWebview)


        NSLayoutConstraint(item: videoWebview, attribute: .top, relatedBy: .equal, toItem: episodeButton, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: videoWebview, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: videoWebview, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: videoWebview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.bounds.width).isActive = true
        NSLayoutConstraint(item: videoWebview, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: -30).isActive = true
    }
    

    
    fileprivate func setupEpisodesTable() {
        
        backgroundView.addSubview(tableView)
        
        
        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: episodeButton, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(((EpisodesList.first?.count)!) * 44)).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

    }
    

    override open var prefersStatusBarHidden: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }

    @objc func videoDidRotate() {
        print("ANUS")
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        UIApplication.shared.isStatusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        print("SYKA BLAT")
    }




}
