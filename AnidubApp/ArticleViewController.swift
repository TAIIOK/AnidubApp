//
//  ArticleViewController.swift
//  Pods
//
//  Created by Matthew Rigdon on 8/16/16.
//
//

import UIKit
import WebKit
import Firebase

open class ArticleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(EpisodesList.count > 0 ) {
            if(segment.selectedSegmentIndex == 0) {
            return ((EpisodesList.first?.count)!)} else {
            return ((EpisodesList.last?.count)!)
            }

        }
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")

        if(episodes_mark.count >= 1 && ((indexPath.row <= (EpisodesList.first?.count)!-1 && episodes_mark.contains((EpisodesList.first as! [episodes])[indexPath.row].Name)) || (indexPath.row <= (EpisodesList.last?.count)!-1 && episodes_mark.contains((EpisodesList.last as! [episodes])[indexPath.row].Name)))) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }

        if(segment.selectedSegmentIndex == 0) {
            cell.textLabel!.text = (EpisodesList.first as! [episodes])[indexPath.row].Name
        } else {
            cell.textLabel!.text = (EpisodesList.last as! [episodes])[indexPath.row].Name
        }

        cell.backgroundColor = ThemeManager.currentTheme().backgroundCellColor
        cell.textLabel?.textColor = ThemeManager.currentTheme().TextCellColor
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebPlayer") as! WebPlayerController

        if(segment.selectedSegmentIndex == 0) {
            vc.loadVideo(urls: (EpisodesList.first as! [episodes])[indexPath.row].Url)
            vc.episodeList = EpisodesList.first as! [episodes]
            vc.currentEpisode = indexPath.row
            vc.alt = true
        } else {
            vc.loadVideo(urls: (EpisodesList.last as! [episodes])[indexPath.row].Url)
            vc.episodeList = EpisodesList.last as! [episodes]
            vc.currentEpisode = indexPath.row
            vc.alt = false
        }

        navigationController?.pushViewController(vc, animated: true)

    }

    var complete: Bool = false {
        didSet {
            if complete {
                comp = "Удалить из просмотренного"
            } else {
                comp = "Добавить в просмотренное"
            }
        }
    }
    var comp: String = "Добавить в просмотренное"

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let cell = tableView.cellForRow(at: indexPath)

        if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark) {
            complete = true
        } else {
            complete = false

        }
        let completeAction = UITableViewRowAction(style: .normal, title: "\(comp)", handler: { (action, _) in

            if action.title == "Добавить в просмотренное"{
                self.complete = true
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                edit_episodes_new(User_id: Auth.auth().currentUser!.uid, Title_id: (currentTitle.first?.ID)!, Episode: cell!.textLabel!.text!, Remove: 0)
                self.episodes_mark.append(cell!.textLabel!.text!)

            } else {
                edit_episodes_new(User_id: Auth.auth().currentUser!.uid, Title_id: (currentTitle.first?.ID)!, Episode: cell!.textLabel!.text!, Remove: 1)
                self.complete = false
                cell?.accessoryType = UITableViewCellAccessoryType.none
                var first = self.episodes_mark
                self.episodes_mark = self.episodes_mark.filter {$0 != cell?.textLabel?.text}
               // update_episodes(id:(currentTitle.first?.ID)!,episode:indexPath.row,alt:true,update:false)

            }
            tableView.setEditing(false, animated: true)
        })

         completeAction.backgroundColor = UIColor(red: 0, green: 0.6588, blue: 0.9176, alpha: 1.0)

        return [completeAction]
    }

    // MARK: - Public properties

    open let imageView = UIImageView()

    open var autoColored: Bool = false

    open var isAnilibria: Bool = false

    open var episodeButton = UIButton()

    open var bookmarkButton = UIButton()

    open var EpisodesList = [[Any?]]()

    open var bot_constr =  NSLayoutConstraint()

    open var episodes_mark = [String]()

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
    fileprivate let segment = UISegmentedControl(items: ["Альтернативный", "Анидаб"])

    fileprivate var backgroundColorSet = false
    fileprivate var headlineColorSet = false
    fileprivate var dateColorSet = false
    fileprivate var authorColorSet = false
    fileprivate var bodyColorSet = false

    fileprivate var play_button = UIButton()

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
            self.backgroundColor = ThemeManager.currentTheme().backgroundColor
            self.headlineColor = ThemeManager.currentTheme().TextCellColor
            self.dateColor = ThemeManager.currentTheme().TextCellColor
            self.authorColor = ThemeManager.currentTheme().TextCellColor
            self.bodyColor = ThemeManager.currentTheme().TextCellColor
            setupUI()
        }

         super.viewDidLoad()

        tableView.separatorColor = ThemeManager.currentTheme().secondaryColor
        tableView.backgroundColor = ThemeManager.currentTheme().backgroundTableColor

        tableView.dataSource = self
        tableView.delegate = self

        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.tag = 100
        tableView.isScrollEnabled = false

        backgroundView.addSubview(tableView)

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
        if(!isAnilibria || (!(currentTitle.first?.Information.Release.contains("anilibria"))!)) {
        setupBody()
        }
        //setupChoose()

    }

    open func loadRequest() {
        if(!EpisodesList.isEmpty) {
            setupChoose()
            self.setupEpisodesTable()
        }
    }

    open func update_table() {
        self.tableView.reloadData()
    }

    open func update_info() {
        if(!anilibria_info.isEmpty) {
        body =  (anilibria_info.first?.Information.Description)!
        setupBody()
        setupPlayButton()
        }
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
        headlineLabel.font = UIFont(name: "HelveticaNeue-Light", size: 25)
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

    @objc func changeTable(segment: UISegmentedControl) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    fileprivate func setupChoose() {

        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
//        segment.addTarget(self, action: Selector(("changeTableWithSender:")), for:.valueChanged)
        segment.addTarget(self, action: #selector(self.changeTable(segment:)), for: .valueChanged)

        backgroundView.addSubview(segment)

        NSLayoutConstraint(item: segment, attribute: .top, relatedBy: .equal, toItem: bodyLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: segment, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 14).isActive = true
        NSLayoutConstraint(item: segment, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -14).isActive = true

      bot_constr =   NSLayoutConstraint(item: segment, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: 0)

        bot_constr.isActive = true

    }

    fileprivate func setupPlayButton() {
        let btnImage = UIImage(named: "Group212")

        play_button.setImage(btnImage, for: UIControlState.normal)
        play_button.translatesAutoresizingMaskIntoConstraints = false

        //segment.addTarget(self, action: #selector(self.changeTable(segment:)), for:.valueChanged)
        play_button.addTarget(self, action: #selector(openPlayer), for: .touchDown)

        backgroundView.addSubview(play_button)

        NSLayoutConstraint(item: play_button, attribute: .top, relatedBy: .equal, toItem: bodyLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: play_button, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 14).isActive = true
        NSLayoutConstraint(item: play_button, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: -14).isActive = true

        bot_constr =   NSLayoutConstraint(item: play_button, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: -100)

        bot_constr.isActive = true

    }

    @objc fileprivate func openPlayer() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebPlayer") as! WebPlayerController

        vc.loadVideo(urls: (anilibria_info.first?.Url)!)

        navigationController?.pushViewController(vc, animated: true)
    }

    fileprivate func setupEpisodesTable() {
        bot_constr.isActive = false

        NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: segment, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: backgroundView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: backgroundView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        if(!EpisodesList.isEmpty && !(EpisodesList.first?.isEmpty)! && (EpisodesList.first?.count)! >= (EpisodesList.last?.count)!) {
            NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat((Double((EpisodesList.first?.count)!)) * 44.3)).isActive = true} else if (!EpisodesList.isEmpty && !(EpisodesList.last?.isEmpty)! && (EpisodesList.first?.count)! <= (EpisodesList.last?.count)!) {
            NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat((Double((EpisodesList.last?.count)!)) * 44.3)).isActive = true
        }
        NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

    }

    override open var shouldAutorotate: Bool {
        return false
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
