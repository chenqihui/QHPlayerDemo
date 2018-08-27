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
    func playerControlTo(_ view: QHPlayerControlView, seek: CGFloat, completionHandler: @escaping (Bool) -> Swift.Void)
}

class QHPlayerControlView: UIView {
    
    var playBtn: UIButton!
    var playTimeL: UILabel!
    var playS: UISlider!
    var playSumTimeL: UILabel!
    var muteBtn: UIButton!
    
    var bTouchSlider = false
    var playSumTime: CGFloat = 0
    
    weak var delegate: QHPlayerControlViewDelegate?
    
    deinit {
        #if DEBUG
        print("[\(type(of: self)) \(#function)]")
        #endif
        p_remove()
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
        p_add()
    }
    
    // MARK - Action
    
    @objc func playAction() {
        delegate?.playerControlTo(self, bPlay: !playBtn.isSelected)
        playBtn.isSelected = !playBtn.isSelected
    }
    
    @objc func muteAction() {
        delegate?.playerControlTo(self, bMute: muteBtn.isSelected)
        muteBtn.isSelected = !muteBtn.isSelected
    }
    
    @objc func sliderValueChangedAction(slider: UISlider) {
//        print("\(slider.value)")
        bTouchSlider = true
    }
    
    @objc func sliderTouchUpInsideAction(slider: UISlider) {
        delegate?.playerControlTo(self, seek: CGFloat(slider.value), completionHandler: { (bFinished) in
            self.bTouchSlider = false
        })
    }
    
    @objc func sliderTouchUpOutsideAction(slider: UISlider) {
        bTouchSlider = false
    }
}

// MARK - Public

extension QHPlayerControlView {
    class func createAt(superView: UIView, delegate: QHPlayerControlViewDelegate?) -> QHPlayerControlView {
        let playControlV = QHPlayerControlView()
        superView.addSubview(playControlV)
        playControlV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["playControlV": playControlV]
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[playControlV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[playControlV(60)]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        playControlV.delegate = delegate
        return playControlV
    }
}

// MARK - Notification

extension QHPlayerControlView {
    
    private func p_add() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playChangedListener(notif:)), name: NSNotification.Name(rawValue: QHPlayerDefinition.pp), object: nil)
    }
    
    private func p_remove() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: QHPlayerDefinition.pp), object: nil)
    }
    
    // MARK - Action
    
    @objc func playChangedListener(notif: Notification) {
        if bTouchSlider == true {
            return
        }
        if let object = notif.object as? [Any] {
            if let t = object[0] as? CMTime {
                let playTimeLValue = CMTimeGetSeconds(t)
                playTimeL.text = "\(Int(playTimeLValue))"
                if let st = object[1] as? CMTime {
                    let playSumTimeLValue = CMTimeGetSeconds(st)
                    playSumTimeL.text = "\(Int(playSumTimeLValue))"
                    let p = min(1, max(playTimeLValue/playSumTimeLValue, 0))
                    playS.value = Float(p)
                }
            }
        }
    }
}

// MARK - UI

extension QHPlayerControlView {
    private func p_addUI() {
        
        let playBtnView = UIView()
        playBtnView.backgroundColor = UIColor.orange
        addSubview(playBtnView)
        playBtnView.translatesAutoresizingMaskIntoConstraints = false
        
        let playTimeView = UIView()
        playTimeView.backgroundColor = UIColor.red
        addSubview(playTimeView)
        playTimeView.translatesAutoresizingMaskIntoConstraints = false
        
        let playSView = UIView()
        playSView.backgroundColor = UIColor.blue
        addSubview(playSView)
        playSView.translatesAutoresizingMaskIntoConstraints = false
        
        let playSumTimeView = UIView()
        playSumTimeView.backgroundColor = UIColor.gray
        addSubview(playSumTimeView)
        playSumTimeView.translatesAutoresizingMaskIntoConstraints = false
        
        let muteBtnView = UIView()
        muteBtnView.backgroundColor = UIColor.yellow
        addSubview(muteBtnView)
        muteBtnView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDict = ["playBtnView": playBtnView, "playTimeView": playTimeView, "playSView": playSView, "playSumTimeView": playSumTimeView, "muteBtnView": muteBtnView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-20-[playBtnView(40)]-0-[playTimeView(40)]-0-[playSView]-0-[playSumTimeView(40)]-0-[muteBtnView(40)]-20-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playBtnView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playTimeView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playSView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playSumTimeView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[muteBtnView]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        
        let fontSize: CGFloat = 13
        let fontSizeBtn: CGFloat = 16
        
        let playBtn = UIButton(type: .custom)
        playBtn.setTitle("▶️", for: .normal)
        playBtn.setTitle("⏸", for: .selected)
        playBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontSizeBtn)
        playBtn.addTarget(self, action: #selector(QHPlayerControlView.playAction), for: .touchUpInside)
        p_addFullConstraintsTo(playBtn, superView: playBtnView)
        self.playBtn = playBtn
        
        let playTimeL = UILabel()
        playTimeL.text = "0"
        playTimeL.textAlignment = .center
        playTimeL.font = UIFont.systemFont(ofSize: fontSize)
        p_addFullConstraintsTo(playTimeL, superView: playTimeView)
        self.playTimeL = playTimeL
        
        let playS = UISlider()
        playS.value = 0
        playS.addTarget(self, action: #selector(QHPlayerControlView.sliderValueChangedAction(slider:)), for: .valueChanged)
        playS.addTarget(self, action: #selector(QHPlayerControlView.sliderTouchUpInsideAction(slider:)), for: .touchUpInside)
        playS.addTarget(self, action: #selector(QHPlayerControlView.sliderTouchUpOutsideAction(slider:)), for: .touchUpOutside)
        p_addFullConstraintsTo(playS, superView: playSView)
        self.playS = playS
        
        let playSumTimeL = UILabel()
        playSumTimeL.text = "0"
        playSumTimeL.textAlignment = .center
        playSumTimeL.font = UIFont.systemFont(ofSize: fontSize)
        p_addFullConstraintsTo(playSumTimeL, superView: playSumTimeView)
        self.playSumTimeL = playSumTimeL
        
        let muteBtn = UIButton(type: .custom)
        muteBtn.setTitle("🔈", for: .normal)
        muteBtn.setTitle("🔇", for: .selected)
        muteBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontSizeBtn)
        muteBtn.addTarget(self, action: #selector(QHPlayerControlView.muteAction), for: .touchUpInside)
        p_addFullConstraintsTo(muteBtn, superView: muteBtnView)
        self.muteBtn = muteBtn
    }
    
    // MARK - Util
    
    private func p_addFullConstraintsTo(_ view: UIView, superView: UIView) {
        superView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let leftLC = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superView, attribute: .left, multiplier: 1, constant: 0)
        let rightLC = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1, constant: 0)
        let topLC = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: 0)
        let bottomLC = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: 0)
        superView.addConstraints([leftLC, rightLC, topLC, bottomLC])
    }
}
