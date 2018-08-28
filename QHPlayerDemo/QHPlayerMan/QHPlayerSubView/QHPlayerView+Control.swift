//
//  QHPlayerView+Control.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/28.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit


// MARK - QHPlayerControlViewDelegate

extension QHPlayerView: QHPlayerControlViewDelegate {
    
    func p_addPlayControlView() {
        if playControlV == nil, playConfig.control == true {
            playControlV = QHPlayerControlView.createAt(superView: self, delegate: self)
        }
    }
    
    func playerControlTo(_ view: QHPlayerControlView, bPlay: Bool) {
        if bPlay == true {
            play()
        }
        else {
            pause()
        }
    }
    
    func playerControlTo(_ view: QHPlayerControlView, bMute: Bool) {
        mute(is: bMute)
    }
    
    func playerControlTo(_ view: QHPlayerControlView, seconds: CGFloat, completionHandler: @escaping (Bool) -> Swift.Void) {
        seek(to: Float64(seconds)) { (bFinished) in
            completionHandler(bFinished)
        }
    }
}
