//
//  DataReceiver.swift
//  BetaFirmwares
//
//  Created by AppleBetas on 2016-07-02.
//  Copyright © 2016 nullpixelLabs. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataReceiver: NSObject {
    static let sharedInstance = DataReceiver()
    
    private let jsonURL = NSURL(string: "https://api.ipsw.me/v2.1/ota.json")!
    
    func getJSON(completionHandler: (JSON?) -> Void) {
        let request = NSURLRequest(URL: jsonURL, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error -> Void in
            if let jsonData = data {
                let json = JSON(data: jsonData)
                completionHandler(json)
            } else {
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
}