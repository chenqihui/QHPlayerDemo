//
//  QHPlayerControlView+UI.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/29.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit

extension QHPlayerControlView {
    
    func p_addUI() {
        p_addBottom()
        p_addTopRightView()
        p_addTopRightViewConstraints()
        p_addConstraints()
    }
}

extension QHPlayerControlView {
    
    static let fontSize: CGFloat = 13
    static let fontSizeBtn: CGFloat = 20
    
    func p_addBottom() {
        let bottomV = UIView()
        bottomV.layer.masksToBounds = true
        bottomV.layer.cornerRadius = 15
        bottomV.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        addSubview(bottomV)
        bottomV.translatesAutoresizingMaskIntoConstraints = false
        bottomView = bottomV
        
        let playSliderV = UIView()
        playSliderV.backgroundColor = UIColor.clear
        bottomV.addSubview(playSliderV)
        playSliderV.translatesAutoresizingMaskIntoConstraints = false
        playSliderView = playSliderV
        
        let playTimeV = UIView()
        playTimeV.backgroundColor = UIColor.clear
        bottomV.addSubview(playTimeV)
        playTimeV.translatesAutoresizingMaskIntoConstraints = false
        playTimeView = playTimeV
        
        let playSumTimeV = UIView()
        playSumTimeV.backgroundColor = UIColor.clear
        bottomV.addSubview(playSumTimeV)
        playSumTimeV.translatesAutoresizingMaskIntoConstraints = false
        playSumTimeView = playSumTimeV
        
        let buttonV = UIView()
        buttonV.backgroundColor = UIColor.clear
        bottomV.addSubview(buttonV)
        buttonV.translatesAutoresizingMaskIntoConstraints = false
        buttonView = buttonV
        
        p_addBottomSubView()
    }
    
    func p_addBottomSubView() {
        
        // slider
        let playS = UISlider()
        playS.value = 0
        playS.maximumValue = 0
        playS.minimumValue = 0
        if let image = QHPlayerControlView.createImageWithColor(UIColor.white, size: CGSize(width: 10, height: 10)) {
            playS.setThumbImage(image, for: .normal)
        }
        playS.addTarget(self, action: #selector(QHPlayerControlView.sliderValueChangedAction(slider:)), for: .valueChanged)
        playS.addTarget(self, action: #selector(QHPlayerControlView.sliderTouchUpInsideAction(slider:)), for: .touchUpInside)
        playS.addTarget(self, action: #selector(QHPlayerControlView.sliderTouchUpOutsideAction(slider:)), for: .touchUpOutside)
        p_addFullConstraintsTo(playS, superView: playSliderView)
        self.playS = playS
        
        // progress time
        let playTimeL = UILabel()
        playTimeL.text = "--:--"
        playTimeL.textAlignment = .center
        playTimeL.textColor = UIColor.white
        playTimeL.font = UIFont.systemFont(ofSize: QHPlayerControlView.fontSize)
        p_addFullConstraintsTo(playTimeL, superView: playTimeView)
        self.playTimeL = playTimeL
        
        // video duration
        let playSumTimeL = UILabel()
        playSumTimeL.text = "--:--"
        playSumTimeL.textAlignment = .center
        playSumTimeL.textColor = UIColor.white
        playSumTimeL.font = UIFont.systemFont(ofSize: QHPlayerControlView.fontSize)
        p_addFullConstraintsTo(playSumTimeL, superView: playSumTimeView)
        self.playSumTimeL = playSumTimeL
        
        let playBtnV = UIView()
        playBtnV.backgroundColor = UIColor.clear
        buttonView.addSubview(playBtnV)
        playBtnV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["playBtnV": playBtnV]
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playBtnV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        buttonView.addConstraint(NSLayoutConstraint(item: playBtnV, attribute: .centerX, relatedBy: .equal, toItem: buttonView, attribute: .centerX, multiplier: 1, constant: 0))
        playBtnV.addConstraint(NSLayoutConstraint(item: playBtnV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50))
        
        let playBackwardBtnV = UIView()
        playBackwardBtnV.backgroundColor = UIColor.clear
        buttonView.addSubview(playBackwardBtnV)
        playBackwardBtnV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict1 = ["playBackwardBtnV": playBackwardBtnV]
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playBackwardBtnV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict1))
        buttonView.addConstraint(NSLayoutConstraint(item: playBackwardBtnV, attribute: .right, relatedBy: .equal, toItem: playBtnV, attribute: .left, multiplier: 1, constant: 0))
        playBackwardBtnV.addConstraint(NSLayoutConstraint(item: playBackwardBtnV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50))
        
        let playForwardBtnV = UIView()
        playForwardBtnV.backgroundColor = UIColor.clear
        buttonView.addSubview(playForwardBtnV)
        playForwardBtnV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict2 = ["playForwardBtnV": playForwardBtnV]
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playForwardBtnV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict2))
        buttonView.addConstraint(NSLayoutConstraint(item: playForwardBtnV, attribute: .left, relatedBy: .equal, toItem: playBtnV, attribute: .right, multiplier: 1, constant: 0))
        playForwardBtnV.addConstraint(NSLayoutConstraint(item: playForwardBtnV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50))
        
        // play
        let playBtn = UIButton(type: .custom)
        playBtn.backgroundColor = UIColor.clear
        playBtn.setTitle("▶️", for: .normal)
        playBtn.setTitle("⏸", for: .selected)
        playBtn.titleLabel?.font = UIFont.systemFont(ofSize: QHPlayerControlView.fontSizeBtn)
        playBtn.addTarget(self, action: #selector(QHPlayerControlView.playAction), for: .touchUpInside)
        p_addFullConstraintsTo(playBtn, superView: playBtnV)
        self.playBtn = playBtn
        
        // backward
        let playBackwardBtn = UIButton(type: .custom)
        playBackwardBtn.setTitle("↩️", for: .normal)
        playBackwardBtn.titleLabel?.font = UIFont.systemFont(ofSize: QHPlayerControlView.fontSizeBtn)
        playBackwardBtn.addTarget(self, action: #selector(QHPlayerControlView.backwardAction), for: .touchUpInside)
        p_addFullConstraintsTo(playBackwardBtn, superView: playBackwardBtnV)
        self.playBackwardBtn = playBackwardBtn
        
        // forward
        let playForwardBtn = UIButton(type: .custom)
        playForwardBtn.setTitle("↪️", for: .normal)
        playForwardBtn.titleLabel?.font = UIFont.systemFont(ofSize: QHPlayerControlView.fontSizeBtn)
        playForwardBtn.addTarget(self, action: #selector(QHPlayerControlView.forwardAction), for: .touchUpInside)
        p_addFullConstraintsTo(playForwardBtn, superView: playForwardBtnV)
        self.playForwardBtn = playForwardBtn
    }
    
    func p_portrait() {
        let spaceH = bottomView.layer.cornerRadius
        
        var bottomSpace: CGFloat = 10
        if p_isX() {
            bottomSpace += 20
        }
        let viewsDict = ["bottomView": bottomView!]
        bottomHLC = NSLayoutConstraint.constraints(withVisualFormat: "|-20-[bottomView]-20-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict)
        addConstraints(bottomHLC!)
        bottomVLC = NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomView(90)]-\(bottomSpace)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict)
        addConstraints(bottomVLC!)
        
        let viewsDict2 = ["playSliderView": playSliderView!]
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(spaceH)-[playSliderView]-\(spaceH)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict2))
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playSliderView(25)]", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict2))
        
        let viewsDict3 = ["playTimeView": playTimeView!]
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(spaceH)-[playTimeView(60)]|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict3))
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[playTimeView(15)]", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict3))
        
        let viewsDict4 = ["playSumTimeView": playSumTimeView!]
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[playSumTimeView(60)]-\(spaceH)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict4))
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[playSumTimeView(15)]", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict4))
        
        let viewsDict5 = ["buttonView": buttonView!]
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(spaceH)-[buttonView]-\(spaceH)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict5))
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[buttonView(50)]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict5))
    }
    
    func p_landscape() {
        
        let spaceH = bottomView.layer.cornerRadius
        
        let viewsDict = ["bottomView": bottomView!]
        bottomHLC = NSLayoutConstraint.constraints(withVisualFormat: "|-20-[bottomView]-20-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict)
        addConstraints(bottomHLC!)
        var bottomSpace: CGFloat = 10
        if p_isX() {
            bottomSpace += 20
        }
        bottomVLC = NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomView(50)]-\(bottomSpace)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict)
        addConstraints(bottomVLC!)
        
        let viewsDict1 = ["buttonView": buttonView, "playTimeView": playTimeView, "playSliderView": playSliderView, "playSumTimeView": playSumTimeView] as [String: Any]
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-\(spaceH)-[buttonView(150)]-0-[playTimeView(60)]-0-[playSliderView]-0-[playSumTimeView(60)]-\(spaceH)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict1))
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[buttonView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict1))
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playTimeView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict1))
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playSliderView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict1))
        bottomView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playSumTimeView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict1))
    }
    
    func p_addConstraints() {
        
        let statusBarO = UIApplication.shared.statusBarOrientation
        if statusBarO == statusBarOrientation, statusBarO != .unknown {
            return
        }
        statusBarOrientation = statusBarO
        if statusBarOrientation.isPortrait {
            p_removeConstraints()
            p_portrait()
            gravityBtn.setTitle("↕️", for: .normal)
            if let vWLV = volumeWLC {
                vWLV.constant = 0
                volumeS.isHidden = true
            }
        }
        else if statusBarOrientation.isLandscape {
            p_removeConstraints()
            p_landscape()
            gravityBtn.setTitle("↔️", for: .normal)
            if let vWLV = volumeWLC {
                vWLV.constant = 80
                volumeS.isHidden = false
            }
        }
    }
    
    func p_removeConstraints() {
        if let bHLC = bottomHLC {
            removeConstraints(bHLC)
            bottomHLC = nil
        }
        if let bVLC = bottomVLC {
            removeConstraints(bVLC)
            bottomVLC = nil
        }
        bottomView.removeConstraints(bottomView.constraints)
    }
    
    func p_addTopRightView() {
        
        let spaceH = bottomView.layer.cornerRadius
        
        let topRightV = UIView()
        topRightV.layer.masksToBounds = true
        topRightV.layer.cornerRadius = 15
        topRightV.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        addSubview(topRightV)
        topRightV.translatesAutoresizingMaskIntoConstraints = false
        topRightView = topRightV
        
        let gravityBtnV = UIView()
        gravityBtnV.backgroundColor = UIColor.clear
        topRightView.addSubview(gravityBtnV)
        gravityBtnV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["gravityBtnV": gravityBtnV]
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[gravityBtnV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        topRightView.addConstraint(NSLayoutConstraint(item: gravityBtnV, attribute: .right, relatedBy: .equal, toItem: topRightView, attribute: .right, multiplier: 1, constant: -spaceH))
        gravityBtnV.addConstraint(NSLayoutConstraint(item: gravityBtnV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50))
        gravityBtnV.addConstraint(NSLayoutConstraint(item: gravityBtnV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50))
        
        let muteBtnV = UIView()
        muteBtnV.backgroundColor = UIColor.clear
        topRightView.addSubview(muteBtnV)
        muteBtnV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict1 = ["muteBtnV": muteBtnV]
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[muteBtnV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict1))
        topRightView.addConstraint(NSLayoutConstraint(item: muteBtnV, attribute: .right, relatedBy: .equal, toItem: gravityBtnV, attribute: .left, multiplier: 1, constant: 0))
        muteBtnV.addConstraint(NSLayoutConstraint(item: muteBtnV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50))
        
        let volumeSV = UIView()
        volumeSV.backgroundColor = UIColor.clear
        topRightView.addSubview(volumeSV)
        volumeSV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict2 = ["volumeSV": volumeSV]
        topRightView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[volumeSV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict2))
        topRightView.addConstraint(NSLayoutConstraint(item: volumeSV, attribute: .left, relatedBy: .equal, toItem: topRightView, attribute: .left, multiplier: 1, constant: spaceH))
        topRightView.addConstraint(NSLayoutConstraint(item: volumeSV, attribute: .right, relatedBy: .equal, toItem: muteBtnV, attribute: .left, multiplier: 1, constant: 0))
        volumeWLC = NSLayoutConstraint(item: volumeSV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 80)
        volumeSV.addConstraint(volumeWLC!)
        
        // gravity
        let gravityBtn = UIButton(type: .custom)
        gravityBtn.backgroundColor = UIColor.clear
        gravityBtn.setTitle("↕️", for: .normal)
        gravityBtn.setTitle("⏹", for: .selected)
        gravityBtn.titleLabel?.font = UIFont.systemFont(ofSize: QHPlayerControlView.fontSizeBtn)
        gravityBtn.addTarget(self, action: #selector(QHPlayerControlView.gravityAction), for: .touchUpInside)
        p_addFullConstraintsTo(gravityBtn, superView: gravityBtnV)
        self.gravityBtn = gravityBtn

        // mute 🔈🔉🔊🔇
        let muteBtn = UIButton(type: .custom)
        muteBtn.backgroundColor = UIColor.clear
        muteBtn.setTitle("🔈", for: .normal)
        muteBtn.setTitle("🔇", for: .selected)
        muteBtn.titleLabel?.font = UIFont.systemFont(ofSize: QHPlayerControlView.fontSizeBtn)
        muteBtn.addTarget(self, action: #selector(QHPlayerControlView.muteAction), for: .touchUpInside)
        p_addFullConstraintsTo(muteBtn, superView: muteBtnV)
        self.muteBtn = muteBtn

        // slider
        let volumeS = UISlider()
        volumeS.backgroundColor = UIColor.clear
        volumeS.value = 0
        volumeS.maximumValue = 1
        volumeS.minimumValue = 0
        if let image = QHPlayerControlView.createImageWithColor(UIColor.white, size: CGSize(width: 10, height: 10)) {
            volumeS.setThumbImage(image, for: .normal)
        }
        volumeS.addTarget(self, action: #selector(QHPlayerControlView.volumeSliderValueChangedAction(slider:)), for: .valueChanged)
        p_addFullConstraintsTo(volumeS, superView: volumeSV)
        self.volumeS = volumeS
    }
    
    func p_addTopRightViewConstraints() {
        var bottomSpace: CGFloat = 30
        if p_isX() {
            bottomSpace += 20
        }
        
        let viewsDict1 = ["topRightView": topRightView!]
        let topRightHLC = NSLayoutConstraint.constraints(withVisualFormat: "[topRightView]-20-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict1)
        addConstraints(topRightHLC)
        let topRightVLC = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(bottomSpace)-[topRightView]", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict1)
        addConstraints(topRightVLC)
    }
    
    func p_control(isHidden bHidden: Bool) {
        bottomView.isHidden = bHidden
        topRightView.isHidden = bHidden
    }
}
