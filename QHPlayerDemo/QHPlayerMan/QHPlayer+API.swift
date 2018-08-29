//
//  QHPlayer+API.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/28.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import Foundation
import UIKit

extension QHPlayerView {
    
    class func createAt(superView: UIView, initConfig config: QHPlayerPlayConfig = QHPlayerPlayConfig()) -> QHPlayerView {
        let playV = QHPlayerView(frame: CGRect.zero, initConfig: config)
        superView.addSubview(playV)
        playV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["playV": playV]
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[playV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        return playV
    }
    
    func prepare(url URL: URL) {
        p_prepare(url: URL)
    }
    
    func play() {
        p_play()
    }
    
    func pause() {
        p_pause()
    }
    
    func seek(to seconds: Float64, completionHandler: @escaping (Bool) -> Swift.Void) {
        p_seek(to: seconds) { (bFinished) in
            completionHandler(bFinished)
        }
    }
    
    func seekToward(to seconds: Float64, completionHandler: @escaping (Bool) -> Swift.Void) {
        p_seekToward(to: seconds, completionHandler: completionHandler)
    }
    
    func gravity(is bGravity: Bool) {
        p_gravity(is: bGravity)
    }
    
    func mute(is bMute: Bool) {
        p_mute(is: bMute)
    }
    
    func volume(to volume: Float) {
        p_volume(to: volume)
    }
    
    func currentItemDuration() -> CGFloat {
        return p_currentItemDuration()
    }
}
