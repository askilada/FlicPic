//
//  FullscreenImageViewController.swift
//  FlicPic
//
//  Created by Simon Jensen on 27/03/17.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit
import FPCore

class FullscreenImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: FPImageModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.getImage(type: .big) { (error, image) in
            
            if error != nil {
                // TODO: display some error message
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
            
            
            
        }
        
        
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Scroll Delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
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
