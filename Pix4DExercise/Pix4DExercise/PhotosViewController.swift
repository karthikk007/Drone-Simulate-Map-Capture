//
//  PhotosViewController.swift
//  Pix4DExercise
//
//  Created by Karthik Kumar on 23/04/18.
//  Copyright © 2018 pix4d. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionViewCell"

class PhotosViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photos: [P4DDroneMediaDescriptor] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photos"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        if indexPath.row < photos.count {
            cell.loadImage(id: photos[indexPath.row].mediaId)
        }
        
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 200)
    }

}
