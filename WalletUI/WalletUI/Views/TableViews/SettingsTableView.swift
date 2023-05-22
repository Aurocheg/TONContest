//
//  SettingsTableView.swift
//  TONApp
//
//  Created by Aurocheg on 21.04.23.
//

import UIKit

public final class SettingsTableView: UITableView {
    public convenience init() {
        self.init(frame: .zero, style: .grouped)
        
        showsVerticalScrollIndicator = false
        isScrollEnabled = false
        backgroundColor = .clear
    }
}
