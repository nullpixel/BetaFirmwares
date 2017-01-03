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
    
    fileprivate let jsonURL = URL(string: "https://api.ipsw.me/v2.1/ota.json")!
    
    func getJSON(_ completionHandler: @escaping (JSON?) -> Void) {
        let request = URLRequest(url: jsonURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let jsonData = data {
                let json = JSON(data: jsonData)
                completionHandler(json)
            } else {
                completionHandler(nil)
            }
        }) 
        task.resume()
    }
    
}
