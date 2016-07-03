//
//  InfoPageController.swift
//  BetaFirmwares
//
//  Created by Jamie Bishop on 02/07/2016.
//  Copyright © 2016 nullpixelLabs. All rights reserved.
//

import UIKit

class InfoPageController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 && indexPath.section == 0 {
            if let url = NSURL(string: "https://m.reddit.com/r/iOSBeta") where UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

