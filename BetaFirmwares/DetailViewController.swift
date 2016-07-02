//
//  DetailViewController.swift
//  BetaFirmwares
//
//  Created by AppleBetas on 2016-07-02.
//  Copyright © 2016 nullpixelLabs. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    var firmware: Firmware!
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var deviceCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.versionLabel.text = firmware.name
        self.buildLabel.text = "Build \(firmware.buildNumber)"
        let deviceCount = firmware.supportedDevices.count
        self.deviceCountLabel.text = "\(deviceCount) SUPPORTED DEVICE\(deviceCount == 1 ? "" : "S")"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firmware.supportedDevices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DeviceCell", forIndexPath: indexPath)
        
        let device = firmware.supportedDevices[indexPath.row]
        
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = device.identifier
        
        return cell
    }

}
