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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.delegate = self
        
        play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Private
    
    private func play() {
        if let url = URL(string: "http://10.7.66.56/resource/4AC51038CA4411EED492019D6EA79A50.mp4") {
            let playV = QHPlayerView.createAt(superView: contentView)
            playV.prepare(url: url)
//            let _ = playV.play()
        }
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
    
}
