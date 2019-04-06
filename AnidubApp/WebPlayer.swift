//
//  WebPlayer.swift
//  AnidubApp
//
//  Created by Roman Efimov on 26/08/2018.
//  Copyright © 2018 Roman Efimov. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import GoogleMobileAds
import Firebase

extension UINavigationBar {
    func installBlurEffect() {
        if(viewWithTag(98) == nil){
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.isUserInteractionEnabled = false
        blurView.frame = blurFrame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = 98
        
        blurView.layer.zPosition = -1
        addSubview(blurView)
        }else{
            viewWithTag(98)?.removeFromSuperview()
        }
    }
}

class WebPlayerController: UIViewController , WKNavigationDelegate , GADBannerViewDelegate, GADInterstitialDelegate{
  
    var url:String = ""
    
    @IBOutlet weak var previous: UIButton!
    
    @IBOutlet weak var nextbtn: UIButton!
    
    @IBOutlet weak var ViewForWK: UIView!
    
    let myWK = WKWebView()
    
    var timer: Timer?
    var episodeList = [episodes]()
    var currentEpisode = 0
    var alt = false
    
    @IBOutlet weak var myProgressBar: UIProgressView!

    var interstitial: GADInterstitial!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        
       super.viewDidLoad()
        
   
        timer = Timer.scheduledTimer(timeInterval: 10 * 60 , target: self, selector: #selector(myFun), userInfo: nil, repeats: true)

        
        myWK.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
        
        
        previous.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height/2, width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.height/8)
        
        myWK.backgroundColor = ViewForWK.backgroundColor
        myWK.tintColor = ViewForWK.backgroundColor
        //myWK.isOpaque = false
        myWK.backgroundColor = UIColor.clear
        myWK.scrollView.backgroundColor = UIColor.clear
        myWK.allowsBackForwardNavigationGestures = true
        ViewForWK.addSubview(myWK)
        
        myWK.navigationDelegate = self
        
        if(!url.contains("streamguard.cc") || !anilibria_info.isEmpty){
        myWK.load(URLRequest(url: URL(string: url)!))
        }

        if(!anilibria_info.isEmpty){
            previous.isHidden = true
            nextbtn.isHidden = true
        //    previous.removeFromSuperview()
        //    nextbtn.removeFromSuperview()
        } else{
            checkButtonStatus()
            checkVideoUrl()
        }
        
        //add observer to get estimated progress value
        self.myWK.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIDeviceOrientationDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIWindowDidBecomeVisible, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIWindowDidBecomeHidden, object: nil)
        
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-6296201459697561/3234000130"
       // bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test
        addBannerViewToView(bannerView)
        
        var test = GADRequest()
        //test.testDevices = ["04fbbf755983e9492cff3e5815f0a8e0"]
        
        bannerView.load(test)
        nextbtn.addTarget(self, action: #selector(buttonActionNext), for: .touchUpInside)
        previous.addTarget(self, action: #selector(buttonActionPrevious), for: .touchUpInside)
        
        
        
    }
    
    func checkVideoUrl(){
        if(url.contains("streamguard.cc")){
            DispatchQueue.global(qos: .background).async {
                self.url = get_video(VideoUrl: self.url)
                DispatchQueue.main.async {
                self.myWK.load(URLRequest(url: URL(string:  self.url)!))
                self.myWK.reload()
                }
            }
            
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-6296201459697561/3198763549")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }

    @objc func myFun(){
        showAdv = true
        if(!currentTitle.isEmpty){
            if(anilibria_info.isEmpty){
      edit_episodes_new(User_id:Auth.auth().currentUser!.uid,Title_id:(currentTitle.first?.ID)!,Episode: episodeList[currentEpisode].Name,Remove:0)
            }}
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
   
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
   
    @objc func buttonActionNext(sender: UIButton!) {
        print("Button next tapped")
        if(episodeList.count > currentEpisode+1){
            myWK.load(URLRequest(url: URL(string: episodeList[currentEpisode+1].Url)!))
            currentEpisode = currentEpisode + 1
            checkButtonStatus()
        }
        
        if  showAdv {
            interstitial =  createAndLoadInterstitial()
            showAdv = false
        } else {
            print("Ad wasn't ready")
            showAdv = false
        }
    }
    
    @objc func buttonActionPrevious(sender: UIButton!) {
        print("Button previous tapped")
        if(currentEpisode != 0){
        myWK.load(URLRequest(url: URL(string: episodeList[currentEpisode-1].Url)!))
        currentEpisode = currentEpisode - 1
        checkButtonStatus()
        }
        
        if  showAdv {
            showAdv = false
            interstitial =  createAndLoadInterstitial()
        } else {
            print("Ad wasn't ready")
            showAdv = false
        }
    }
    
    func checkButtonStatus(){
        if(currentEpisode == 0){
            previous.isEnabled = false
        }else{
            previous.isEnabled = true
        }
        if(currentEpisode == episodeList.count-1){
            nextbtn.isEnabled = false
        }
        else{
            nextbtn.isEnabled = true
        }
        
    }
    
    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.myProgressBar.progress = Float(self.myWK.estimatedProgress);
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        self.myProgressBar.setProgress(0.1, animated: false)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.myProgressBar.setProgress(1.0, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.myProgressBar.setProgress(1.0, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadVideo(urls:String){
        
        self.url = urls
       
    }
    
    override  var prefersStatusBarHidden: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    
    @objc func videoDidRotate() {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        self.setNeedsStatusBarAppearanceUpdate()
        print("SYKA BLAT")
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
        ad.present(fromRootViewController: self)
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
    
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
    
}
