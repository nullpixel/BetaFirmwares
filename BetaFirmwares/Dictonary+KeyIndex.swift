//
//  Dictonary+KeyIndex.swift
//  BetaFirmwares
//
//  Created by AppleBetas on 2016-07-02.
//  Copyright © 2016 nullpixelLabs. All rights reserved.
//

import Foundation

extension Dictionary {
    func keyOfIndex(_ index: Int) -> Key {
        let keys = Array(self.keys)
        return keys[index]
    }
}
