//
//  VideoTableViewCell.swift
//  VideoListSwift
//
//  Created by 张建军 on 16/9/7.
//  Copyright © 2016年 张建军. All rights reserved.
//

import UIKit
// 创建结构体
struct video {
    
    let image: String
    let title: String
    let source: String
    
}


protocol VideoTabViewCellDelegate {
    
    func ButtonDidClcik()
    
}

class VideoTableViewCell: UITableViewCell {


    //声明实例变量
    // 设置一个代理变量
    var delegate: VideoTabViewCellDelegate?
    var videoScreenshot = UIImageView(image: UIImage.init(named: "videoScreenshot01"))
    
    var videoTitleLabel = UILabel()
    var videoSourceLabel = UILabel()
    var videoPlayBtn = UIButton(type: .custom)
    let SCREEN_WITH = UIScreen.main.bounds.size.width
    let SCTREEN_HIEGTH = UIScreen.main.bounds.size.height

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: .default, reuseIdentifier: nil)
        self.awakeFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // 初始化值
        videoSourceLabel.frame = CGRect(x: 0, y: 197, width: SCREEN_WITH, height: 14)
        videoSourceLabel.font = UIFont.systemFont(ofSize: 10)
        videoSourceLabel.textAlignment = NSTextAlignment.center
        videoSourceLabel.textColor = UIColor.green
        
        
        videoTitleLabel.frame = CGRect(x: 0, y: 173, width: SCREEN_WITH, height: 16)
        videoTitleLabel.textColor = UIColor.green
        videoTitleLabel.font = UIFont.systemFont(ofSize: 14)
        videoTitleLabel.textAlignment = NSTextAlignment.center
        
//         初始化话背景图
        
        videoScreenshot.frame = CGRect(x: 0, y: 0, width: SCREEN_WITH, height: 220)
        videoScreenshot.backgroundColor = UIColor.green
        // 初始化播放按钮
        videoPlayBtn.frame = CGRect(x: (SCREEN_WITH - 200)/2, y: 60, width: 200, height: 100)
        videoPlayBtn.setImage(UIImage(named: "playBtn"), for: UIControlState())
        
        videoPlayBtn.addTarget(self, action: #selector(self.videoBtnClick), for: .touchUpInside)
        // 将控件添加到cell 上 【添加顺序】
        self.addSubview(videoScreenshot)// 背景视图
        self.addSubview(videoPlayBtn)// 添加播放按钮
        self.addSubview(videoSourceLabel)// 添加Lable
        self.addSubview(videoTitleLabel)// 添加视频标题
        
        
        
        
        
    }
    
 // 代理方法的声明
    func videoBtnClick() {
        
        delegate?.ButtonDidClcik()
    }
    


}
