//
//  Firmware.swift
//  BetaFirmwares
//
//  Created by AppleBetas on 2016-07-02.
//  Copyright © 2016 nullpixelLabs. All rights reserved.
//

import Foundation

class Firmware {
    let name: String, buildNumber: String
    var supportedDevices = [Device]()
    
    init(name: String, buildNumber: String, supportedDevices: [Device] = []) {
        self.name = name
        self.buildNumber = buildNumber
        self.supportedDevices = supportedDevices
    }
}