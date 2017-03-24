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
    @IBOutlet var loginView: UIView!
    @IBOutlet var logoutView: UIView!
    @IBOutlet var usernameLabel: UILabel!
    
    var loggedIn: Bool = false
    
    @IBAction func loginAction(sender: UIButton) {
        let urlStr = FPCore.shared.authUrl
        let url = URL(string: urlStr)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func logoutAction(sender: UIButton) {
        FPCore.shared.token = nil
        self.loggedIn = false
        updateLoginView()
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
            
            let authToken = authToken as? FPToken
            
            self.loggedIn = true
            
            DispatchQueue.main.async {
                hud.contentView = PKHUDSuccessView();
                hud.hide(afterDelay: 3)
                self.usernameLabel.text = authToken!.userName
                self.updateLoginView()
                self.miniTokenTF.text = ""
            }
        }
    }
    
    func updateLoginView() {
        if self.loggedIn {
            self.loginView.isHidden = true
            self.logoutView.isHidden = false
        } else {
            self.loginView.isHidden = false
            self.logoutView.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let token = FPCore.shared.token {
            usernameLabel.text = token.userName
            self.loggedIn = true
        }
        
        updateLoginView()
        
        
        super.viewWillAppear(animated)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

