
//
//  HttpRequestTools.swift
//  river
//
//  Created by shih-yenWei on 24/7/16.
//  Copyright © 2016年 Rytass. All rights reserved.
//

import UIKit
import Security

class HttpRequestTools:NSObject {
    
    static let sharedInstance = HttpRequestTools();
    
    private override init() {
    }
   
    deinit {
    }
    
    private let hostUrl = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=09744724c2fbdc5f572f6ab830e09233";
    
    private let getHeaders = [
        "cache-control": "no-cache"
    ]
    
    //https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=09744724c2fbdc5f572f6ab830e09233&text=食物&per_page=20&page=2&format=json
    func get(_ text:String, per_page:String, page:Int, completion:@escaping (_ result:[String:Any]?,_ error:String?) ->Void) {
       let request = NSMutableURLRequest(url: URL(string: "\(hostUrl)&text=\(text)&per_page=\(per_page)&page=\(page)&format=json&nojsoncallback=1".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = getHeaders
        
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(nil,(error?.localizedDescription)!);
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                if httpResponse?.statusCode == 200 {

                    do {
                        let resultString = String(data: data!, encoding: String.Encoding.utf8)!;
                        let resultData = resultString.data(using: String.Encoding.utf8);
                        let json = try JSONSerialization.jsonObject(with: resultData!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        completion((json as! [String : Any]),nil);
                        
                    }
                    catch{
                        
                        completion(nil,"JSON Error");
                        print(error);
                    }
                }
                else {
                    
                    completion(["error":"YES"],nil);
                }
                
                
            }
        }).resume()
    }
}
