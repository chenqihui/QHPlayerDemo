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
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    deinit {
        #if DEBUG
        print("[\(type(of: self)) \(#function)]")
        #endif
    }
    
    // MARK - Public
    
    class func createAt(superView: UIView) -> QHPlayerView {
        let playV = QHPlayerView()
        superView.addSubview(playV)
        playV.translatesAutoresizingMaskIntoConstraints = false
        let viewsDict = ["playV": playV]
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-0-[playV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[playV]-0-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: viewsDict))
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
        }
    }
    
    func play() -> Bool {
        if let playerLayer = layer as? AVPlayerLayer {
            if let player = playerLayer.player {
                player.play()
                return true
            }
        }
        return false
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
