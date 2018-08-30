//
//  PlayViewController.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/23.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    deinit {
        #if DEBUG
        print("[\(type(of: self)) \(#function)]")
        #endif
        p_removeNotificaion()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.delegate = self
        
        p_addPlayerView()
        p_addNotificaion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Private
    
    private func p_addPlayerView() {
        if let url = URL(string: "http://10.7.66.56/resource/4AC51038CA4411EED492019D6EA79A50.mp4") {
//        if let url = URL(string: "http://192.168.2.17/resource/4AC51038CA4411EED492019D6EA79A50.mp4") {
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
        }
    }
    
    private func p_addNotificaion() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.qhHandlePlayerNotify(notif:)), name: NSNotification.Name.QHPlayerProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.qhHandlePlayerNotify(notif:)), name: NSNotification.Name.QHPlayerItemStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.qhHandlePlayerNotify(notif:)), name: NSNotification.Name.QHPlayerItemBuffer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.qhHandlePlayerNotify(notif:)), name: NSNotification.Name.QHPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.qhHandlePlayerNotify(notif:)), name: NSNotification.Name.QHPlayerItemFailedToPlayToEndTime, object: nil)
    }
    
    private func p_removeNotificaion() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.QHPlayerProgress, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.QHPlayerItemStatus, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.QHPlayerItemBuffer, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.QHPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.QHPlayerItemFailedToPlayToEndTime, object: nil)
    }
    
    // MARK - Public
    
    class func create() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let className = NSStringFromClass(self).components(separatedBy: ".").last!
        let viewController = storyboard.instantiateViewController(withIdentifier: className)
        
        return viewController
    }
    
    // MARK - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.setNavigationBarHidden(true, animated: animated)
        }
        else {
            navigationController.setNavigationBarHidden(false, animated: animated)
            if (navigationController.delegate?.isKind(of: PlayViewController.self))! {
                navigationController.delegate = nil
            }
        }
    }
    
    // MARK - Action
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func qhHandlePlayerNotify(notif: Notification) {
        if notif.name == NSNotification.Name.QHPlayerProgress {
            if let object = notif.object as? [String: Any] {
                if let time = object[QHPlayerDefinition.QHPlayerProgressKey] as? Float64 {
                }
            }
        }
        else if notif.name == NSNotification.Name.QHPlayerItemStatus {
            if let object = notif.object as? [String: Any] {
                if let status = object[QHPlayerDefinition.QHPlayerItemStatusKey] as? QHPlayerItemStatus {
                    if status == .readyToPlay {
                        if let duration = object[QHPlayerDefinition.QHPlayerItemDurationKey] as? CGFloat {
                        }
                    }
                    else {
                    }
                }
            }
        }
        else if notif.name == NSNotification.Name.QHPlayerItemBuffer {
        }
        else if notif.name == NSNotification.Name.QHPlayerItemDidPlayToEndTime {
        }
        else if notif.name == NSNotification.Name.QHPlayerItemFailedToPlayToEndTime {
        }
    }
    
}
