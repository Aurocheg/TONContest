//
//  TransferTableView.swift
//  TONApp
//
//  Created by Aurocheg on 28.04.23.
//

import UIKit

public final class TransferTableView: UITableView {
    public convenience init() {
        self.init(frame: .zero, style: .plain)
        
        rowHeight = 44
        isScrollEnabled = false
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
}
