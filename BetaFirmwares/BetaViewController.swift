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
    
    var debugMode = false
    
    var betaFirmwares = [String: Firmware]()
    var hasAppeared = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !hasAppeared {
            self.refreshControl?.beginRefreshing()
            self.startReceive()
      
            hasAppeared = true
        }
    }
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let firmware = betaFirmwares[betaFirmwares.keyOfIndex(indexPath.row)]!
        
        cell.textLabel?.text = firmware.name
        let deviceCount = firmware.supportedDevices.count
        cell.detailTextLabel?.text = "\(firmware.buildNumber) - \(deviceCount) device\(deviceCount == 1 ? "" : "s")"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let firmware = betaFirmwares[betaFirmwares.keyOfIndex(indexPath.row)]
        self.performSegueWithIdentifier("ShowDetail", sender: firmware)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.betaFirmwares.count
    }
    
    // MARK: - Start receiving JSON
    func startReceive() {
        if debugMode {
            self.betaFirmwares = ["10.0": Firmware(name: "10.0", buildNumber: "M4d3Up", supportedDevices: [Device(name: "FakePhone 6", identifier: "FakePhone7,2")])]
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        } else {
            DataReceiver.sharedInstance.getJSON() { json in
                guard let json = json else {
                    let alert = UIAlertController(title: "Couldn't receive betas", message: "An error occurred while trying ot receive a list of the current betas on the OTA server.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Try Again", style: .Cancel, handler: { _ in
                        self.startReceive()
                    })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                self.betaFirmwares = [String: Firmware]()
                for (deviceID, device) in json.dictionaryValue {
                    if let firmwares = device["firmwares"].array, deviceName = device["name"].string {
                        for firmware in firmwares {
                            if let version = firmware["version"].string, releaseType = firmware["releasetype"].string, buildNumber = firmware["buildid"].string where releaseType == "Beta" {
                                let device = Device(name: deviceName, identifier: deviceID)
                                if !self.betaFirmwares.keys.contains(version) {
                                    self.betaFirmwares[version] = Firmware(name: version, buildNumber: buildNumber, supportedDevices: [device])
                                } else if !self.betaFirmwares[version]!.supportedDevices.contains(device) {
                                    self.betaFirmwares[version]!.supportedDevices.append(device)
                                }
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }

    @IBAction func refreshCalled(sender: AnyObject) {
        self.startReceive()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let firmware = sender as? Firmware, let destVC = segue.destinationViewController as? DetailViewController where segue.identifier == "ShowDetail" {
            destVC.firmware = firmware
        }
    }
    
}
