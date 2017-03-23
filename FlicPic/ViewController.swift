//
//  ViewController.swift
//  FlicPic
//
//  Created by Simon Jensen on 21/03/2017.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit
import FPCore


class ViewController: UIViewController {
    
    @IBAction func loginAction(sender: UIButton) {
        let urlStr = FPCore.shared.authUrl
        let url = URL(string: urlStr)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

