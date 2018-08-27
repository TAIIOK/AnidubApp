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

class WebPlayerController: UIViewController , WKNavigationDelegate{
  
    var url = ""
    
    

    @IBOutlet weak var myWk: WKWebView!
    
    
    @IBOutlet weak var myProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWk.navigationDelegate = self

        myWk.load(URLRequest(url: URL(string: url)!))
        
        //add observer to get estimated progress value
        self.myWk.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
 
       
    }
    

    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.myProgressBar.progress = Float(self.myWk.estimatedProgress);
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.isTranslucent = false
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
    
    
    @objc func goBack()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadVideo(urls:String){
        
        self.url = urls
       
    }
    
    
    
}
