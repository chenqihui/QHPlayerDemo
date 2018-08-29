//
//  QHPlayerControlView.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/24.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit
import AVFoundation

protocol QHPlayerControlViewDelegate: NSObjectProtocol {
    func playerControlTo(_ view: QHPlayerControlView, bPlay: Bool)
    func playerControlTo(_ view: QHPlayerControlView, bMute: Bool)
    func playerControlTo(_ view: QHPlayerControlView, seconds: CGFloat, completionHandler: @escaping (Bool) -> Swift.Void)
    func playerControlTo(_ view: QHPlayerControlView, toward: CGFloat, completionHandler: @escaping (Bool) -> Swift.Void)
    func playerControlTo(_ view: QHPlayerControlView, bGravity: Bool)
    func playerControlTo(_ view: QHPlayerControlView, volume to: Float)
}

class QHPlayerControlView: UIView {
    
    var topLeftView: UIView!
    var topRightView: UIView!
    var bottomView: UIView!
    
    // bottomView ---------------------
    var playSliderView: UIView!
    var playTimeView: UIView!
    var playSumTimeView: UIView!
    var buttonView: UIView!
    
    var playBtn: UIButton!
    var playBackwardBtn: UIButton!
    var playForwardBtn: UIButton!
    var playTimeL: UILabel!
    var playS: UISlider!
    var playSumTimeL: UILabel!
    // --------------------------------
    
    // topRightView -------------------
    var muteBtnView: UIView!
    var gravityBtnView: UIView!
    var volumeSView: UIView!
    
    var muteBtn: UIButton!
    var gravityBtn: UIButton!
    var volumeS: UISlider!
    // --------------------------------
    
    var hideControlTimer: Timer?
    
    var bTouchSlider = false
    var playSumTime: Float {
        set {
            playS.maximumValue = newValue
            playSumTimeL.text = p_secondsToString(Int(newValue))
        }
        get {
            return playS.value
        }
    }
    
    var volume: Float {
        set {
            volumeS.value = newValue
        }
        get {
            return volumeS.value
        }
    }
    
    var bReadyToPlay = false
    
    weak var delegate: QHPlayerControlViewDelegate?
    
    var statusBarOrientation: UIInterfaceOrientation = .unknown
    var bottomHLC: [NSLayoutConstraint]?
    var bottomVLC: [NSLayoutConstraint]?
//    var topRightHLC: [NSLayoutConstraint]?
//    var topRightVLC: [NSLayoutConstraint]?
    
    deinit {
        #if DEBUG
        print("[\(type(of: self)) \(#function)]")
        #endif
        p_removeNotificaion()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        p_setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Private
    
    private func p_setup() {
        p_addUI()
        p_addNotificaion()
        p_hideControlTimer()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(QHPlayerControlView.tapAction))
        addGestureRecognizer(tap)
    }
    
    func p_hideControlTimer() {
        if let timer = hideControlTimer {
            if timer.isValid == true {
                timer.invalidate()
                hideControlTimer = nil
                p_control(isHidden: true)
                return
            }
            hideControlTimer = nil
        }
        p_control(isHidden: false)
        hideControlTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(QHPlayerControlView.hideControlTimerAction), userInfo: nil, repeats: false)
    }
}

// MARK - Public

extension QHPlayerControlView {
    
    class func createAt(superView: UIView, delegate: QHPlayerControlViewDelegate?) -> QHPlayerControlView {
        
        let playControlV = QHPlayerControlView()
        playControlV.backgroundColor = UIColor.clear
        superView.addSubview(playControlV)
        playControlV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["playControlV": playControlV]
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[playControlV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playControlV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        playControlV.delegate = delegate
        
        return playControlV
    }
}

// MARK - Util

extension QHPlayerControlView {
    
    func p_secondsToString(_ seconds: Int) -> String {
        let timeStamp = seconds
        let s = timeStamp % 60
        let m = timeStamp / 60
        let time = String(format: "%.2d:%.2d", m, s)
        return time
    }
    
    func p_addFullConstraintsTo(_ view: UIView, superView: UIView) {
        superView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let leftLC = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superView, attribute: .left, multiplier: 1, constant: 0)
        let rightLC = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1, constant: 0)
        let topLC = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: 0)
        let bottomLC = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: 0)
        superView.addConstraints([leftLC, rightLC, topLC, bottomLC])
    }
    
    func p_isX() -> Bool {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            if UIScreen.instancesRespond(to:#selector(getter: UIScreen.main.currentMode)) {
                if let size = UIScreen.main.currentMode?.size {
                    if __CGSizeEqualToSize(CGSize(width:1125, height:2436), size) {
                        return true
                    }
                }
            }
        }
        return false
    }
}
