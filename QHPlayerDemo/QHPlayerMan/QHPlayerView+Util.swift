//
//  QHPlayerView+Util.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/28.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import Foundation
import AVFoundation

extension QHPlayerView {
    
    func p_player() -> AVPlayer? {
        if let playerLayer = layer as? AVPlayerLayer {
            if let player = playerLayer.player {
                return player
            }
        }
        return nil
    }
    
    func p_currentItemDuration() -> CGFloat {
        if let player = p_player() {
            if let playerItem = player.currentItem {
                return CGFloat(CMTimeGetSeconds(playerItem.asset.duration))
            }
        }
        return 0
    }
    
    func p_log(_ log: String) {
        if playConfig.log == true {
            #if DEBUG
            print(log)
            #endif
        }
        if logBlock != nil {
            logBlock!(log)
        }
    }
}
