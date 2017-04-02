//
//  MenuTableViewController.swift
//  FlicPic
//
//  Created by Simon Jensen on 24/03/2017.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit
import FPCore

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "public_images" {
            let destCon = segue.destination as! PhotosCollectionViewController
            destCon.loadImages(ofType: .Public)
            print("Public images are now loading")
        } else if segue.identifier == "private_images" {
            let destCon = segue.destination as! PhotosCollectionViewController
            destCon.loadImages(ofType: .Private)
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.reuseIdentifier == "myProfile" {
            if FPCore.shared.token == nil {
                let loginView = storyboard?.instantiateViewController(withIdentifier: "LoginViewIdentifier") as! LoginViewController
                self.show(loginView, sender: self)
            } else {
                let userView = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewIdentifier") as! UserProfileViewController
                self.show(userView, sender: self)
            }
        }
        
    }

}
