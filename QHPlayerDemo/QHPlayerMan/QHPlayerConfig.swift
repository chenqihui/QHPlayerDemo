//
//  QHPlayerConfig.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/24.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import Foundation
import AVFoundation

public typealias QHPlayerItemStatus = AVPlayerItemStatus

public enum QHPlayerStatus {
    case ready
    case play
    case pause
    case fails
}

public struct QHPlayerPlayConfig {
    // 控制器
    public var control = false
    // 内部日志
    public var log = false
    // 音量
    public var volume: Float = 0.5
    // 填充模式
    public var videoGravity: AVLayerVideoGravity = .resizeAspect
    // 播放进度回调间隔
    public var progress: Float64 = 1
    // 菊花
    public var load = false
    // 过滤 .readyToPlay
    // 用于控制 playItemStatus 在 App 回前台时候再次通知 readyToPlay 时候的过滤。其实也可以回前台时做标记，通过这个通知再进行播放控制，这里可以根据需求来确定。
    public var readyToPlay = false
    
    // 自动播放
    var autoPlay = false
    // 后台播放
    var background = false
    // 缓存
    var cache = false
    // 循环播放
    var loop = false
    
    public init() {
        
    }
}

extension NSNotification.Name {
    
    public static let QHPlayerProgress: NSNotification.Name = NSNotification.Name(rawValue: "QHPlayerProgress")
    
    public static let QHPlayerItemStatus: NSNotification.Name = NSNotification.Name(rawValue: "QHPlayerItemStatus")
    
    public static let QHPlayerItemBuffer: NSNotification.Name = NSNotification.Name(rawValue: "QHPlayerItemBuffer")
    
    public static let QHPlayerItemDidPlayToEndTime: NSNotification.Name = NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTime")
    
    public static let QHPlayerItemFailedToPlayToEndTime: NSNotification.Name = NSNotification.Name(rawValue: "AVPlayerItemFailedToPlayToEndTime")
    
}

public class QHPlayerDefinition: NSObject {
    // QHPlayerProgress
    // - Float64
    public static let QHPlayerProgressKey = "QHPlayerProgressKey"
    
    // QHPlayerItemStatus
    // - AVPlayerItemStatus
    public static let QHPlayerItemStatusKey = "QHPlayerItemStatusKey"
    // - CGFloat
    public static let QHPlayerItemDurationKey = "QHPlayerItemDurationKey"
    
    // QHPlayerItemBuffer
    // - Bool
    public static let QHPlayerItemBufferKey = "QHPlayerItemBufferKey"
    
    // QHPlayerItemFailedToPlayToEndTime
    // - String
    public static let QHPlayerItemFailedToPlayToEndTimeErrorKey = "QHPlayerItemFailedToPlayToEndTimeErrorKey"
}
