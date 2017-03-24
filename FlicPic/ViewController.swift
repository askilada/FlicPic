//
//  ViewController.swift
//  FlicPic
//
//  Created by Simon Jensen on 21/03/2017.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit
import FPCore
import PKHUD

class ViewController: UIViewController {
    
    @IBOutlet var miniTokenTF: UITextField!
    
    @IBAction func loginAction(sender: UIButton) {
        let urlStr = FPCore.shared.authUrl
        let url = URL(string: urlStr)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func authenticate(sender: UIButton) {
        let token = miniTokenTF.text!
        let req = FPAuthRequest(miniToken: token)
        let hud = PKHUD.sharedHUD
        hud.contentView = PKHUDProgressView()
        hud.show()
        
        req.exec { (err, authToken) in
            if err != nil {
                
                DispatchQueue.main.async {
                    hud.contentView = PKHUDErrorView(title: "Error", subtitle: "Error while trying to login, please try again later")
                    hud.hide(afterDelay: 3, completion: nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                hud.contentView = PKHUDSuccessView();
                hud.hide(afterDelay: 3)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

