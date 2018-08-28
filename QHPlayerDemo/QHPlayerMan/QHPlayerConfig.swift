//
//  QHPlayerConfig.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/24.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import Foundation
import AVFoundation

enum QHPlayerStatus {
    case unknown
    case readyToPlay
    case play
    case pause
    case stop
    case fail
}

struct QHPlayerPlayConfig {
    var control = false
    // 日志
    var log = false
    // 准备好自动播放
    var autoPlay = false
    // 循环播放
    // 静音
    // 缓存
    // 填充模式
    var videoGravity: AVLayerVideoGravity = .resizeAspect
    // 播放进度回调间隔
    var progress: Float64 = 0
}

class QHPlayerDefinition: NSObject {
}

extension NSNotification.Name {
    public static let QHPlayerProgress: NSNotification.Name = NSNotification.Name(rawValue: "QHPlayerProgress")
    
    public static let QHPlayerItemStatus: NSNotification.Name = NSNotification.Name(rawValue: "QHPlayerItemStatus")
    
    public static let QHPlayerItemBuffer: NSNotification.Name = NSNotification.Name(rawValue: "QHPlayerItemBuffer")
    
}
