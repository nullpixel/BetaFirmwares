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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !hasAppeared {
            self.refreshControl?.beginRefreshing()
            self.startReceive()
      
            hasAppeared = true
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let firmware = betaFirmwares[betaFirmwares.keyOfIndex(indexPath.row)]!
        
        cell.textLabel?.text = firmware.name
        let deviceCount = firmware.supportedDevices.count
        cell.detailTextLabel?.text = "\(firmware.buildNumber) - \(deviceCount) device\(deviceCount == 1 ? "" : "s")"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firmware = betaFirmwares[betaFirmwares.keyOfIndex(indexPath.row)]
        self.performSegue(withIdentifier: "ShowDetail", sender: firmware)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                    let alert = UIAlertController(title: "Couldn't receive betas", message: "An error occurred while trying ot receive a list of the current betas on the OTA server.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Try Again", style: .cancel, handler: { _ in
                        self.startReceive()
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.betaFirmwares = [String: Firmware]()
                for (deviceID, device) in json.dictionaryValue {
                    if let firmwares = device["firmwares"].array, let deviceName = device["name"].string {
                        for firmware in firmwares {
                            if let version = firmware["version"].string, let releaseType = firmware["releasetype"].string, let buildNumber = firmware["buildid"].string, releaseType == "Beta" {
                                let device = Device(name: deviceName, identifier: deviceID)
                                if !self.betaFirmwares.keys.contains(buildNumber) {
                                    self.betaFirmwares[buildNumber] = Firmware(name: version, buildNumber: buildNumber, supportedDevices: [device])
                                } else if !self.betaFirmwares[buildNumber]!.supportedDevices.contains(device) {
                                    self.betaFirmwares[buildNumber]!.supportedDevices.append(device)
                                }
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
                
            }
        }
    }

    @IBAction func refreshCalled(_ sender: AnyObject) {
        self.startReceive()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let firmware = sender as? Firmware, let destVC = segue.destination as? DetailViewController, segue.identifier == "ShowDetail" {
            destVC.firmware = firmware
        }
    }
    
}
