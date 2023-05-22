//
//  SendTableCell.swift
//  TONApp
//
//  Created by Aurocheg on 24.04.23.
//

import UIKit

public final class SendTableCell: UITableViewCell {
    // MARK: - Properties
    public static let reuseIdentifier = "SendTableCell"
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
