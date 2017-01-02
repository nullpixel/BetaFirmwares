//
//  InfoPageController.swift
//  BetaFirmwares
//
//  Created by Jamie Bishop on 02/07/2016.
//  Copyright © 2016 nullpixelLabs. All rights reserved.
//

import UIKit

class InfoPageController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 && indexPath.section == 0 {
            if let url = URL(string: "https://m.reddit.com/r/iOSBeta"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

