//
//  QHPlayerControlView+Observer.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/29.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import Foundation
import AVFoundation

// MARK - Notification

extension QHPlayerControlView {
    
    func p_addNotificaion() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playChangedListener(notif:)), name: NSNotification.Name.QHPlayerProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceOrientationDidChange(notif:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playItemStatusListener(notif:)), name: NSNotification.Name.QHPlayerItemStatus, object: nil)
    }
    
    func p_removeNotificaion() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.QHPlayerProgress, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.QHPlayerItemStatus, object: nil)
    }
    
    // MARK - Action
    
    @objc func playChangedListener(notif: Notification) {
        if bTouchSlider == true {
            return
        }
        if let object = notif.object as? [Any] {
            if let t = object[0] as? CMTime {
                let playTimeLValue = CMTimeGetSeconds(t)
                playTimeL.text = p_secondsToString(Int(playTimeLValue))
                playS.value = Float(playTimeLValue)
            }
        }
    }
    
    @objc func deviceOrientationDidChange(notif: Notification) {
        p_addConstraints()
    }
    
    @objc func playItemStatusListener(notif: Notification) {
        if let object = notif.object as? [Any] {
            if let status = object[0] as? AVPlayerItemStatus {
                if status == .readyToPlay {
                    if let duration = object[1] as? CGFloat {
                        playSumTime = Float(duration)
                    }
                    bReadyToPlay = true
                }
                else {
                    bReadyToPlay = false
                }
            }
        }
    }
}
