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
                        let playTimeLValue = CMTimeGetSeconds(time)
                        NotificationCenter.default.post(name: NSNotification.Name.QHPlayerProgress, object: [QHPlayerDefinition.QHPlayerProgressKey: playTimeLValue])
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
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let c = change {
                if let statusValue = c[.newKey] as? Int {
                    if let status = AVPlayerItemStatus(rawValue: statusValue) {
                        var obj = [String: Any]()
                        obj[QHPlayerDefinition.QHPlayerItemStatusKey] = status
                        switch status {
                        case .unknown:
                            p_log("unknown")
                        case .readyToPlay:
                            p_log("readyToPlay")
                            obj[QHPlayerDefinition.QHPlayerItemDurationKey] = p_currentItemDuration()
                        case .failed:
                            p_log("failes")
                        }
                        NotificationCenter.default.post(name: NSNotification.Name.QHPlayerItemStatus, object: obj)
                    }
                }
            }
        }
        else if keyPath == "loadedTimeRanges" {
//            let loadedTimeRange = p_player()?.currentItem?.loadedTimeRanges
//            if let timeRange = loadedTimeRange?.first as? CMTimeRange {
//                let startSeconds = CMTimeGetSeconds(timeRange.start)
//                let durationSeconds = CMTimeGetSeconds(timeRange.duration)
//                let timeInterval = startSeconds + durationSeconds
//                print("\(timeInterval)")
//            }
        }
        else if keyPath == "playbackBufferEmpty" {
            p_log("playbackBufferEmpty")
            activity?.startAnimating()
            NotificationCenter.default.post(name: NSNotification.Name.QHPlayerItemBuffer, object: [QHPlayerDefinition.QHPlayerItemBufferKey: true])
        }
        else if keyPath == "playbackLikelyToKeepUp" {
            p_log("playbackLikelyToKeepUp")
            activity?.stopAnimating()
            NotificationCenter.default.post(name: NSNotification.Name.QHPlayerItemBuffer, object: [QHPlayerDefinition.QHPlayerItemBufferKey: false])
        }
    }
    
    @objc func playerItemDidPlayToEndTime(notif: Notification) {
        p_log("playerItemDidPlayToEndTime")
        NotificationCenter.default.post(name: NSNotification.Name.QHPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func playerItemFailedToPlayToEndTime(notif: Notification) {
        p_log("playerItemFailedToPlayToEndTime")
        var error = "unknow"
        if let obj = notif.object as? [String: Any] {
            if let err = obj[AVPlayerItemFailedToPlayToEndTimeErrorKey] {
                error = "\(err)"
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name.QHPlayerItemFailedToPlayToEndTime, object: [QHPlayerDefinition.QHPlayerItemFailedToPlayToEndTimeErrorKey: error])
    }
}
