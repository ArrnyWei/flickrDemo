//
//  FlickrImage.swift
//  FlickrDemo
//
//  Created by Wei Shih Chi on 2020/1/8.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit

struct FlickrImage {
    var image_id:String?
    var title:String?
    var owner:String?
    var secret:String?
    var server:String?
    var farm:Int?
    var isPublic:Bool?
    var isFriend:Bool?
    var isFamily:Bool?
    
    init(image_id:String, title:String, owner:String, secret:String, server:String, farm:Int, isPublic:Bool, isFriend:Bool, isFamily:Bool) {
        self.image_id = image_id;
        self.title = title;
        self.owner = owner;
        self.secret = secret;
        self.server = server;
        self.farm = farm;
        self.isPublic = isPublic;
        self.isFriend = isFriend;
        self.isFamily = isFamily;
    }
    
    func addToCoreData(){
        
    }
    
    func removeFromCoreData(){
        
    }
}
