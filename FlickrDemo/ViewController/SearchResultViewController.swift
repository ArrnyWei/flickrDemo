//
//  SearchResultViewController.swift
//  FlickrDemo
//
//  Created by Wei Shih Chi on 2020/1/8.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var searchContent = ""
    var searchNumberofPage = "0";
    var page = 1;
    
    var imageArray:[FlickrImage] = []
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "搜尋結果 \(searchContent)"
        reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imageCollectionViewLayout = UICollectionViewFlowLayout();
        imageCollectionViewLayout.minimumInteritemSpacing = 10;
        imageCollectionViewLayout.minimumLineSpacing = 5;
        
        imageCollectionViewLayout.itemSize = CGSize(width: (self.view.frame.size.width - 30) / 2, height: ((self.view.frame.size.width - 30) / 2) + 30);
        //        btnCollectionViewLayout.itemSize = CGSizeMake((self.view.frame.size.width - 14) / 2, (self.view.frame.size.width) / 4 - 10);
        self.imageCollectionView.collectionViewLayout = imageCollectionViewLayout;
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        let tempImage = imageArray[indexPath.row]
        
        cell.imageTitle.text = tempImage.title
        cell.imageView.sd_setImage(with: URL(string: "https://farm\(tempImage.farm!).staticflickr.com/\(tempImage.server!)/\(tempImage.image_id!)_\(tempImage.secret!).jpg"), completed: nil);
        cell.favoriteBtn.tag = indexPath.row
        cell.favoriteBtn.addTarget(self, action: #selector(SearchResultViewController.addFav(_:)), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.imageArray.count - 1) {
            page += 1
            reloadData()
        }
    }
    
    @objc
    func addFav(_ sender:UIButton){
        let tmepImage = imageArray[sender.tag]
        let arrtibute = ["image_id":tmepImage.image_id!,"title":tmepImage.title!,"owner":tmepImage.owner!,"secret":tmepImage.secret!,"server":tmepImage.server!,"farm":"\(tmepImage.farm!)","ispublic":"\(String(describing: tmepImage.isPublic!))","isfriend":"\(String(describing: tmepImage.isFriend!))","isfamily":"\(String(describing: tmepImage.isFamily!))"]
        let result = CoreDataConnect.sharedInstance.insert("FavoriteImage", attributeInfo: arrtibute)
        
        if result == true {
            let alertContoller = UIAlertController(title: "成功", message: "已加入收藏", preferredStyle: UIAlertController.Style.alert)
            
            alertContoller.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil));
            self.present(alertContoller, animated: true, completion: nil);
        }
        else {
            let alertContoller = UIAlertController(title: "失敗", message: "加入失敗", preferredStyle: UIAlertController.Style.alert)
            
            alertContoller.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil));
            self.present(alertContoller, animated: true, completion: nil);
        }
        
            
    }
    
    func reloadData(){
        HttpRequestTools.sharedInstance.get(searchContent, per_page: searchNumberofPage, page: page) { (result, error) in
            if error == nil {
                if let finalResult = result {
                    
                    if finalResult["stat"] as! String == "ok" {
                        let photoArray = (finalResult["photos"]  as! [String:Any])["photo"] as! [[String:Any]];
                        
                        for tempImage in photoArray {
                            let newImage = FlickrImage(image_id: tempImage["id"] as! String, title: tempImage["title"] as! String, owner: tempImage["owner"] as! String, secret: tempImage["secret"] as! String, server: tempImage["server"] as! String, farm: tempImage["farm"] as! Int, isPublic: tempImage["ispublic"] as! Bool, isFriend: tempImage["isfriend"] as! Bool, isFamily: tempImage["isfamily"] as! Bool)

                            self.imageArray.append(newImage)
                        }
                        DispatchQueue.main.sync{
                            self.imageCollectionView.reloadData()
                        }
                    }
                    else {
                        DispatchQueue.main.sync {
                            let alertContoller = UIAlertController(title: "錯誤", message: "\(finalResult["code"] as! NSNumber) - \(finalResult["message"] as! String)", preferredStyle: UIAlertController.Style.alert)
                            
                            alertContoller.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil));
                            self.present(alertContoller, animated: true, completion: nil);
                        }
                    }
                }
            }
            else {
                //warning
            }
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
