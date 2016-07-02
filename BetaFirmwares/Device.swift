//
//  Device.swift
//  BetaFirmwares
//
//  Created by AppleBetas on 2016-07-02.
//  Copyright © 2016 nullpixelLabs. All rights reserved.
//

import Foundation

struct Device: Equatable {
    let name: String, identifier: String
}

func ==(lhs: Device, rhs: Device) -> Bool {
    return lhs.identifier == rhs.identifier
}