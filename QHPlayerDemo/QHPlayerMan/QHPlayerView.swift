//
//  QHPlayerView.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/23.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit
import AVFoundation

class QHPlayerView: UIView {
    
    var playControlV: QHPlayerControlView?
    var config: QHPlayerConfig!
    
    var timeObserverToken: Any?
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    deinit {
        #if DEBUG
        print("[\(type(of: self)) \(#function)]")
        #endif
        
        if let timeOT = timeObserverToken {
            p_player()?.removeTimeObserver(timeOT)
        }
        p_player()?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
    
    private func p_player() -> AVPlayer? {
        if let playerLayer = layer as? AVPlayerLayer {
            if let player = playerLayer.player {
                return player
            }
        }
        return nil
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

// MARK - Public

extension QHPlayerView {
    
    class func createAt(superView: UIView, config: QHPlayerConfig = QHPlayerConfig()) -> QHPlayerView {
        let playV = QHPlayerView()
        superView.addSubview(playV)
        playV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["playV": playV]
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[playV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        playV.playControlV = QHPlayerControlView.createAt(superView: playV, delegate: playV)
        playV.config = config
        return playV
    }
    
    func prepare(url URL: URL) {
        if let playerLayer = layer as? AVPlayerLayer {
            let playerItem = AVPlayerItem(url: URL)
            if playerLayer.player != nil {
                playerLayer.player?.pause()
                playerLayer.player = nil
            }
            let player = AVPlayer(playerItem: playerItem)
            playerLayer.player = player
            
            playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            playControlV?.playSumTime = CGFloat(CMTimeGetSeconds(playerItem.asset.duration))
        }
    }
    
    func play() -> Bool {
        if let player = p_player() {
            let interval = CMTimeMakeWithSeconds(1, Int32(NSEC_PER_SEC));
            timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: nil) { (time) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: QHPlayerDefinition.pp), object: [time, player.currentItem?.asset.duration])
            }
            player.play()
            return true
        }
        return false
    }
    
    func pause() {
        if let player = p_player() {
            player.pause()
        }
    }
    
    func goPlay(p: CGFloat, completionHandler: @escaping (Bool) -> Swift.Void) {
        let t = CGFloat(CMTimeGetSeconds((p_player()?.currentItem?.asset.duration)!)) * p
        goPlay(time: Int64(t)) { (bFinished) in
            completionHandler(bFinished)
        }
        //        let s = (p_player()?.currentItem?.asset.duration.timescale)!
        //        let startTime = CMTimeMake(Int64(t * CGFloat(s)), s)
        //        p_player()?.seek(to: startTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    
    func goPlay(time: Int64, completionHandler: @escaping (Bool) -> Swift.Void) {
        print("\(time)")
        print("1000000000")
        print("1 = \(Int32(1000000000))")
        print("\(Int32(NSEC_PER_SEC))")
        print("\((p_player()?.currentItem?.asset.duration.timescale)!)")
        //        let startTime = CMTime.init(seconds: Double(time), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        //        let startTime = CMTimeMake(time, Int32(1000000000))
        let s = (p_player()?.currentItem?.asset.duration.timescale)!
        let startTime = CMTimeMake(Int64(time * Int64(s)), s)
        //        p_player()?.seek(to: startTime, completionHandler: { (bFinished) in
        //            print("bFinished = \(bFinished)")
        //        })
        //        if CMTIME_IS_VALID(startTime) {
        //            p_player()?.seek(to: startTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        //        }
        //        else {
        //            print("invalid")
        //        }
        
        p_player()?.seek(to: startTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (bFinished) in
            completionHandler(bFinished)
        })
    }
}


// MARK - QHPlayerControlViewDelegate

extension QHPlayerView: QHPlayerControlViewDelegate {
    
    func playerControlTo(_ view: QHPlayerControlView, bPlay: Bool) {
        if bPlay == true {
            let _ = play()
        }
        else {
            pause()
        }
    }
    
    func playerControlTo(_ view: QHPlayerControlView, bMute: Bool) {
        
    }
    
    func playerControlTo(_ view: QHPlayerControlView, seek: CGFloat, completionHandler: @escaping (Bool) -> Swift.Void) {
        goPlay(p: seek, completionHandler: { (bFinished) in
            completionHandler(bFinished)
        })
    }
}
