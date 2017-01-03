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
    
    @IBOutlet weak var headerView: HairlineView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    @IBOutlet weak var deviceCountLabel: UILabel!
    
    var doneHeaderView = false
    var tableHeaderHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.versionLabel.text = firmware.name
        self.buildLabel.text = "Build \(firmware.buildNumber)"
        let deviceCount = firmware.supportedDevices.count
        self.deviceCountLabel.text = "\(deviceCount) SUPPORTED DEVICE\(deviceCount == 1 ? "" : "S")"
        self.tableHeaderHeight = self.headerView.frame.size.height
        
        self.tableView.tableHeaderView = nil
        self.tableView.addSubview(self.headerView)
        
        self.tableView.contentInset.top += self.tableHeaderHeight - self.topLayoutGuide.length
        self.tableView.contentOffset.y = -self.tableHeaderHeight
        self.updateHeaderView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.updateHeaderView()
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doneHeaderView = true
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight - self.topLayoutGuide.length {
            headerRect.origin.y = tableView.contentOffset.y + self.topLayoutGuide.length
        }
        headerView.frame = headerRect
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firmware.supportedDevices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath)
        
        let device = firmware.supportedDevices[indexPath.row]
        
        cell.textLabel?.text = device.name
        cell.detailTextLabel?.text = device.identifier
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if doneHeaderView {
            updateHeaderView()
        }
    }
    
}
