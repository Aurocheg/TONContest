//
//  SendTableView.swift
//  TONApp
//
//  Created by Aurocheg on 23.04.23.
//

import UIKit

public final class SendTableView: UITableView {
    public convenience init() {
        self.init(frame: .zero, style: .grouped)
        
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        backgroundColor = .clear
        rowHeight = 44
    }
}
