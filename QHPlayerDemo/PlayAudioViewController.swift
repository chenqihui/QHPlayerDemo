//
//  PlayAudioViewController.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/31.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit

class PlayAudioViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
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
        if let url = URL(string: "http://10.7.66.56/resource/Beyond.mp3") {
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
            playV.play()
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
