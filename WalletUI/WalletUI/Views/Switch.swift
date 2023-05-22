//
//  Switch.swift
//  TONApp
//
//  Created by Aurocheg on 21.04.23.
//

import UIKit

public final class Switch: UISwitch {
    public convenience init(isOn: Bool = false) {
        self.init(frame: .zero)
        
        self.isOn = isOn
    }
}
