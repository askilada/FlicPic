//
//  MenuTableViewController.swift
//  FlicPic
//
//  Created by Simon Jensen on 24/03/2017.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit

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
    

}
