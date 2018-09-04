//
//  QHPlayerView.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/23.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit
import AVFoundation

public typealias QHPlayerLogCallBackBlock = (_ log: String) -> Void

public class QHPlayerView: UIView {
    
    var activity: UIActivityIndicatorView?
    var playControlV: QHPlayerControlView?
    var playConfig: QHPlayerPlayConfig!
    var playerItemStatu: QHPlayerItemStatus = .unknown
    
    var timeObserverToken: Any?
    public var logBlock: QHPlayerLogCallBackBlock?
    var playerStatus = QHPlayerStatus.ready
    
    override public class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    deinit {
        #if DEBUG
        print("[\(type(of: self)) \(#function)]")
        #endif
        
        p_removeVideoKVO()
        p_removeVideoTimerObserver()
        p_removeVideoNotification()
    }
    
    init(frame: CGRect, initConfig config: QHPlayerPlayConfig) {
        super.init(frame: frame)
        playConfig = config
        p_setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Private
    
    private func p_setup() {
        backgroundColor = UIColor.clear
        p_audioSessionActive()
        p_addPlayControlView()
        p_addActivityIndicatorView()
        p_addVideoNotification()
    }
    
    private func p_addActivityIndicatorView() {
        if playConfig.load == true {
            activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activity!.hidesWhenStopped = true
            addSubview(activity!)
            activity!.translatesAutoresizingMaskIntoConstraints = false
            addConstraint(NSLayoutConstraint(item: activity!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: activity!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        }
    }
}

extension QHPlayerView {
    
    private func p_audioSessionActive() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        }
        catch {
            p_log("\(error)")
        }
    }
    
    func p_prepare(url URL: URL) {
        if let playerLayer = layer as? AVPlayerLayer {
            playerItemStatu = .unknown
            
            // 添加协议头：AVURLAssetHTTPHeaderFieldsKey
            let headerFields: [String: String] = ["User-Agent":"value"]
            let asset = AVURLAsset(url: URL, options: ["AVURLAssetHTTPHeaderFieldsKey": headerFields])
            let playerItem = AVPlayerItem(asset: asset)
//            let playerItem = AVPlayerItem(url: URL)
            
            var player: AVPlayer
            if let playerTemp = playerLayer.player {
                p_removeVideoKVO()
                
                player = playerTemp
                p_pause()
                playerStatus = .ready
                player.replaceCurrentItem(with: playerItem)
            }
            else {
                playerStatus = .ready
                player = AVPlayer(playerItem: playerItem)
                playerLayer.player = player
                p_addVideoTimerObserver()
            }
            if #available(iOS 10.0, *) {
                player.automaticallyWaitsToMinimizeStalling = false
            } else {
                // Fallback on earlier versions
            }
            
            playerLayer.videoGravity = playConfig.videoGravity
            player.volume = playConfig.volume
            
            p_addVideoKVO()
            
//            playControlV?.playSumTime = Float(p_currentItemDuration())
            playControlV?.volume = Float(player.volume)
            playControlV?.bReadyToPlay = false
            
            // 异步获取视频的 size
            asset.loadValuesAsynchronously(forKeys: ["tracks"]) {
                for track in asset.tracks {
                    print("\(track)")
                    if track.mediaType == .video {
                        print("\(track.naturalSize)")
                    }
                }
            }
            
            let a = AVAudioPlayer()
            a.updateMeters()
        }
    }
    
    func p_play() {
        if let player = p_player() {
            playerStatus = .play
            player.play()
        }
    }
    
    func p_pause() {
        if let player = p_player() {
            playerStatus = .pause
            player.pause()
        }
    }
    
    func p_seek(to seconds: Float64, completionHandler: @escaping (Bool) -> Swift.Void) {
        if let player = p_player() {
            guard player.currentItem?.status == .readyToPlay else {
                completionHandler(false)
                return
            }
            let time = CMTimeMakeWithSeconds(seconds, Int32(NSEC_PER_SEC))
            player.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero) { (bFinished) in
                completionHandler(bFinished)
            }
        }
        else {
            completionHandler(false)
        }
    }
    
    func p_mute(is bMute: Bool) {
        if let player = p_player() {
            player.isMuted = bMute
        }
    }
    
    func p_gravity(is bGravity: Bool) {
        if let playerLayer = layer as? AVPlayerLayer {
            if bGravity == true {
                playerLayer.videoGravity = .resizeAspectFill
            }
            else {
                playerLayer.videoGravity = .resizeAspect
            }
        }
    }
    
    func p_seekToward(to seconds: Float64, completionHandler: @escaping (Bool) -> Swift.Void) {
        if let currentTime = p_player()?.currentTime() {
            let toSeconds = min(max(CMTimeGetSeconds(currentTime) + seconds, 0), Double(p_currentItemDuration()))
            p_seek(to: toSeconds) { (bFinished) in
                completionHandler(bFinished)
            }
        }
    }
    
    func p_volume(to volume: Float) {
        if let player = p_player() {
            player.volume = max(min(volume, 1), 0)
        }
    }
}
