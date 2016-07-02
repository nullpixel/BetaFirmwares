//
//  BetaViewController.swift
//  BetaFirmwares
//
//  Created by Jamie Bishop on 02/07/2016.
//  Copyright © 2016 nullpixelLabs. All rights reserved.
//

import UIKit
import SwiftyJSON

class BetaViewController: UITableViewController {
    
    var betaFirmwares = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parseJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"cell")
        cell.textLabel?.text = betaFirmwares[indexPath.row]
        
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.betaFirmwares.count;
    }
    
    //MARK: Parse JSON
    func parseJSON() {
        //Setup Parsing variables.
        let urlToParse = "https://api.ipsw.me/v2.1/ota.json" //Thanks to ipsw.me for having a cool API.
        let url = NSURL(string: urlToParse)
        let OTAJSON = try! NSData(contentsOfURL: url!)
        let json = JSON(data: OTAJSON!)
        // Loop through every device
        // Thanks to /u/AppleBeta's for this part.
        for (_, device) in json.dictionaryValue {
            if let firmwares = device["firmwares"].array {
                for firmware in firmwares {
                    if let version = firmware["version"].string, releaseType = firmware["releasetype"].string where !betaFirmwares.contains(version) && releaseType == "Beta" {
                        betaFirmwares.append(version)
                    }
                }
            }
        }
        
        debugPrint(betaFirmwares)
    }

   
}
