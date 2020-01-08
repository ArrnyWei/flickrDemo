//
//  SecondViewController.swift
//  FlickrDemo
//
//  Created by Wei Shih Chi on 2020/1/8.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var favorityArray:[FavoriteImage] = []
    @IBOutlet weak var favoriteCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imageCollectionViewLayout = UICollectionViewFlowLayout();
        imageCollectionViewLayout.minimumInteritemSpacing = 10;
        imageCollectionViewLayout.minimumLineSpacing = 5;
        
        imageCollectionViewLayout.itemSize = CGSize(width: (self.view.frame.size.width - 30) / 2, height: ((self.view.frame.size.width - 30) / 2) + 30);
        //        btnCollectionViewLayout.itemSize = CGSizeMake((self.view.frame.size.width - 14) / 2, (self.view.frame.size.width) / 4 - 10);
        self.favoriteCollection.collectionViewLayout = imageCollectionViewLayout;
        favorityArray = CoreDataConnect.sharedInstance.fetch(myEntityName: "FavoriteImage", predicate: nil, sort: nil, limit: nil) as! [FavoriteImage];
        self.favoriteCollection.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCollectionViewCell", for: indexPath) as! favoriteCollectionViewCell
               
        let tempImage = favorityArray[indexPath.row]
               
        cell.imageTitle.text = tempImage.title
        cell.imageView.sd_setImage(with: URL(string: "https://farm\(String(tempImage.farm)).staticflickr.com/\(String(describing: tempImage.server!))/\(String(describing: tempImage.image_id!))_\(String(describing: tempImage.secret!)).jpg"), completed: nil);
               
        return cell
    }
    

}

