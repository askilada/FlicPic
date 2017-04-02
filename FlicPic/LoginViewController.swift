//
//  LoginViewController.swift
//  FlicPic
//
//  Created by Simon Jensen on 02/04/17.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit
import FPCore
import PKHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var miniToken: UITextField!

    @IBAction func showLogin(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: FPCore.shared.authUrl)!, options: [:]) { (success) in
            print("DONE")
        }
        
        
        
        
    }
    
    @IBAction func auth(_ sender: Any) {
        let pk = PKHUD.sharedHUD
        if miniToken.text == "" {
            pk.contentView = PKHUDErrorView(title: "Error", subtitle: "You need to fill token field.")
            pk.show()
            pk.hide(afterDelay: 2)
            return
        }
        
        let pgView = PKHUDProgressView()
        pgView.titleLabel.text = "Logging in"
        
        pk.contentView = pgView
        pk.show()
        
        let req = FPAuthRequest(miniToken: miniToken.text!)
        req.exec { (error, token) in
            if error != nil {
                
                DispatchQueue.main.async {
                    pk.contentView = PKHUDErrorView(title: "Error", subtitle: "something went wrong")
                    pk.hide(afterDelay: 3)
                }
                
                return
            }
            
            var vcs = self.navigationController!.viewControllers
            let _ = vcs.popLast()
            let userProfile = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewIdentifier")
            vcs.append(userProfile!)
            
            DispatchQueue.main.async {
                pk.hide(afterDelay: 1)
                self.navigationController?.setViewControllers(vcs, animated: true)
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
