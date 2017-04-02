//
//  PhotosCollectionViewController.swift
//  FlicPic
//
//  Created by Simon Jensen on 23/03/2017.
//  Copyright © 2017 Simon Jensen. All rights reserved.
//

import UIKit
import FPCore
import PKHUD

private let reuseIdentifier = "Cell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 5.0, bottom: 50.0, right: 5.0)
private let itemsPerRow: CGFloat = 3


extension UIImageView {
    func loadImageFrom(url: URL, withCompleationHandler compleationHandler: (() -> ())?) {
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 1200)
        self.image = nil
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                let image =  UIImage(data: data!)
                self.image = image
            }
            if let compleationHandler = compleationHandler {
                compleationHandler()
            }
            
        }.resume()
        
    }
    func loadImageFrom(url: URL) {
        self.loadImageFrom(url: url, withCompleationHandler: nil)
    }
}


enum PhotosToLoad {
    case Public
    case Private
}

class PhotosCollectionViewController: UICollectionViewController {
    var photos: [FPPhoto] = []
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selectedIndexPaths = self.collectionView?.indexPathsForSelectedItems
            , let indexPath = selectedIndexPaths.first {
            
            let photo = photos[indexPath.row]
            let dest = segue.destination as! FullscreenImageViewController
            dest.image = photo
            
            
        }
        
    }
    
    
    func loadImages(ofType type: PhotosToLoad) {
        let request: FPRequest
        switch type {
        case .Public:
            self.navigationItem.title = "Public images"
            request = FPPublicPhotosRequest()
            break
        case .Private:
            self.navigationItem.title = "Private images"
            request = FPPrivatePhotosRequest()
            break
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        request.exec { (err, result) in
            if err != nil {
                DispatchQueue.main.async {
                    PKHUD.sharedHUD.contentView = PKHUDErrorView(title: "Error", subtitle: "An error had happend")
                    PKHUD.sharedHUD.hide(afterDelay: 2)
                    let _ = self.navigationController?.popViewController(animated: true)
                }
                return
            }
            
            let photos = result as! [FPPhoto]
            self.photos = photos
            
            DispatchQueue.main.async {
                PKHUD.sharedHUD.hide()
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotosCollectionViewCell
    
        // Configure the cell
        let index = indexPath.row
        let photo = photos[index]
        cell.imageView.image = nil
        photo.getImage(type: .medium) { (error, image) in
            if error != nil {
                //TODO: Something with error handling
                return
            }
            
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
    
        return cell
    }
    
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: Maybe load bigger image in future
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCollectionViewCell
        let image = cell.imageView.image
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(dismissImageView(sender:)))
        imageView.addGestureRecognizer(tab)
        
        imageView.frame = self.view.frame
        self.view.addSubview(imageView)
        
    }
     */   
 
    func dismissImageView(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
}
