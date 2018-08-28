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
    
    func p_addVideoKVO() {
        p_player()?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        p_player()?.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        p_player()?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        p_player()?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
    }
    
    func p_removeVideoKVO() {
        p_player()?.currentItem?.removeObserver(self, forKeyPath: "status")
        p_player()?.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        p_player()?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        p_player()?.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }
    
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
    
    func p_removeVideoTimerObserver() {
        if let timeOT = timeObserverToken {
            p_player()?.removeTimeObserver(timeOT)
        }
    }
    
    func p_addVideoNotificaion() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidPlayToEndTime(notif:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemFailedToPlayToEndTime(notif:)), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
    }
    
    func p_removeVideoNotificaion() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
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
                        NotificationCenter.default.post(name: NSNotification.Name.QHPlayerItemStatus, object: status)
                    }
                }
            }
        }
        else if keyPath == "loadedTimeRanges" {
//            print("loadedTimeRanges")
            let loadedTimeRange = p_player()?.currentItem?.loadedTimeRanges
            if let timeRange = loadedTimeRange?.first as? CMTimeRange {
                let startSeconds = CMTimeGetSeconds(timeRange.start)
                let durationSeconds = CMTimeGetSeconds(timeRange.duration)
                let timeInterval = startSeconds + durationSeconds
                print("\(timeInterval)")
            }
        }
        else if keyPath == "playbackBufferEmpty" {
            print("playbackBufferEmpty")
            NotificationCenter.default.post(name: NSNotification.Name.QHPlayerItemBuffer, object: true)
        }
        else if keyPath == "playbackLikelyToKeepUp" {
            print("playbackLikelyToKeepUp")
            NotificationCenter.default.post(name: NSNotification.Name.QHPlayerItemBuffer, object: false)
        }
    }
    
    @objc func playerItemDidPlayToEndTime(notif: Notification) {
        print("playerItemDidPlayToEndTime")
    }
    
    @objc func playerItemFailedToPlayToEndTime(notif: Notification) {
        print("playerItemFailedToPlayToEndTime")
    }
}