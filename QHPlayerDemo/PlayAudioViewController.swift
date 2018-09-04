//
//  PlayAudioViewController.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/31.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayAudioViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    static let url = "http://10.7.66.56/resource/Beyond.mp3"
//    static let url = "http://192.168.2.17/resource/Beyond.mp3"
    
    deinit {
        #if DEBUG
        print("[\(type(of: self)) \(#function)]")
        #endif
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        p_addPlayerView()
    }
    
    // MARK - Private
    
    private func p_addPlayerView() {
        if let url = URL(string: PlayAudioViewController.url) {
            var config = QHPlayerPlayConfig()
            config.control = true
            config.progress = 1
            config.log = false
            config.load = true
            let playV = QHPlayerView.createAt(superView: contentView, initConfig: config)
            playV.logBlock = { (log) in
                print("\(log)")
            };
            playV.prepare(url: url)
//            playV.play()
            
            let artwork = MPMediaItemArtwork(image: QHPlayerControlView.createImageWithColor(UIColor.orange, size: CGSize(width: 100, height: 100))!)
                let infoCenter = MPNowPlayingInfoCenter.default()
            infoCenter.playbackState = .playing
            infoCenter.nowPlayingInfo = [
                                        MPMediaItemPropertyTitle: "真的喜欢你",
                                        MPMediaItemPropertyArtist: "Beyond",
                                        MPNowPlayingInfoPropertyElapsedPlaybackTime: 0,
                                        MPMediaItemPropertyPlaybackDuration: playV.currentItemDuration(),
                                        MPMediaItemPropertyArtwork: artwork,
                                        MPNowPlayingInfoPropertyPlaybackRate: 1
                                        ]
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
            // 启用播放命令 (锁屏界面和上拉快捷功能菜单处的播放按钮触发的命令)，默认 true
            MPRemoteCommandCenter.shared().playCommand.isEnabled = true
            MPRemoteCommandCenter.shared().playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                playV.play()
                return .success
            }
            MPRemoteCommandCenter.shared().pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                playV.pause()
                return .success
            }
            // 启用耳机的播放/暂停命令 (耳机上的播放按钮触发的命令)
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                // 需自己判断 play or pause
                if playV.playerStatus == .play {
                    playV.pause()
                }
                else if playV.playerStatus == .pause {
                    playV.play()
                }
                return .success
            }
            MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                return .success
            }
            MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                return .success
            }
            
            if let player = playV.p_player() {
                player.isMeteringEnabled = true
                player.averagePowerListInLinearForm { (iAvgPowerList, iSuccess) in
                    if let list = iAvgPowerList {
                        if list.count > 0 {
                            if var power = list[0] as? Double {
                                if list.count > 1 {
                                    if let secondPower = list[1] as? Double {
                                        power = (power + secondPower) / 2
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.progressView.progress = Float(power)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK - Public
    
    class func create() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let className = NSStringFromClass(self).components(separatedBy: ".").last!
        let viewController = storyboard.instantiateViewController(withIdentifier: className)
        
        return viewController
    }
    

}
