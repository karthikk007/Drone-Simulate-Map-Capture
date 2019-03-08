//
//  CollectionViewCell.swift
//  Pix4DExercise
//
//  Created by Karthik Kumar on 23/04/18.
//  Copyright © 2018 pix4d. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    func loadImage(id: String) {
        backgroundColor = UIColor.red
        getImage(id: id)
    }
    
    func getDocumentsDirectory() -> String {
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("pix4d")
        print("kk path = \(paths)")
        return paths
    }
    
    func getImage(id: String) {
        let fileManager = FileManager.default
        let imagePath = getDocumentsDirectory().appending("/\(id)")
        
        if fileManager.fileExists(atPath: imagePath) {
            self.photoImageView?.image = UIImage(contentsOfFile: imagePath)
        } else {
            print("kk no image")
        }
    }
}
