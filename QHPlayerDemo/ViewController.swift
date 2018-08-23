//
//  ViewController.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/21.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAction(_ sender: Any) {
        let vc = PlayViewController.create()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

