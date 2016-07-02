/*
    ViewController.swift
    BetaFirmwares
 
    Created by Jamie Bishop on 29/06/2016.
    Copyright © 2016 nullpixelLabs. All rights reserved.
 
    Thanks to reddit.com/u/AppleBetas & ipsw.me
    Thanks also to the people who made SwiftyJSON, my favourite open-source JSON parsing framework.
*/

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.parseJSON() //Parses all the JSON
        //Will add pull to refresh soon.
    }
    
    
    //I like to setup global variables here
    var betaFirmwares = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Table View Population.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.betaFirmwares.count;
        /*
            This function counts how many firmwares are in betaFirmwares array, and makes the table have that many rows.
         */
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"cell")
        cell.textLabel?.text = betaFirmwares[indexPath.row]
        
        return cell
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
                    if let version = firmware["version"].string where !betaFirmwares.contains(version) {
                        betaFirmwares.append(version)
                    }
                }
            }
        }
        
        debugPrint(betaFirmwares)
    }
}