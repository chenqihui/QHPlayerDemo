//
//  QHPlayerView+Observer.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/28.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import Foundation
import AVFoundation

extension QHPlayerView {
    
    func p_addVideoTimerObserver() {
        if playConfig.progress >= 0 {
            p_removeVideoTimerObserver()
            if let player = p_player() {
                let interval = CMTimeMakeWithSeconds(playConfig.progress, Int32(NSEC_PER_SEC));
                timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: nil) { [weak self] (time) in
                    if self != nil {
                        NotificationCenter.default.post(name: NSNotification.Name.QHPlayerProgress, object: [time])//, self.p_currentItemDuration()
                    }
                }
            }
        }
    }
    
    func p_addVideoNotificaion() {
        
    }
    
    func p_addVideoKVO() {
        p_player()?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
    }
    
    func p_removeVideoTimerObserver() {
        if let timeOT = timeObserverToken {
            p_player()?.removeTimeObserver(timeOT)
        }
    }
    
    func p_removeVideoNotificaion() {
        
    }
    
    func p_removeVideoKVO() {
        p_player()?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
    
    // MARK - Action
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let c = change {
                if let statusValue = c[.newKey] as? Int {
                    if let status = AVPlayerItemStatus(rawValue: statusValue) {
                        switch status {
                        case .unknown:
                            print("unknown")
                        case .readyToPlay:
                            print("readyToPlay")
                        case .failed:
                            print("failes")
                        }
                    }
                }
            }
        }
    }
}
