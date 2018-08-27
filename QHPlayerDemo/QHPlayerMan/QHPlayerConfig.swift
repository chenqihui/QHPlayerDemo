//
//  QHPlayerConfig.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/24.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import Foundation

enum QHPlayerStatus {
    case unknown
    case readyToPlay
    case play
    case pause
    case stop
    case fail
}

struct QHPlayerConfig {
    // 准备好自动播放
    var autoPlay = false
    // 循环播放
    // 静音
    // 缓存
    var addPlayControl = false
}

// 播放进度回调间隔
// 日志

class QHPlayerDefinition: NSObject {
}

extension QHPlayerDefinition {
    static let pp = "npp"
}
