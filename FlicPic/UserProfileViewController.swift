//
//  UserProfileViewController.swift
//  FlicPic
//
//  Created by Simon Jensen on 02/04/17.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit
import FPCore

class UserProfileViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!

    @IBAction func logout(_ sender: Any) {
        FPCore.shared.token = nil
        let _ = self.navigationController?.popViewController(animated: true)
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = FPCore.shared.token?.userName

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
