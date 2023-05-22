//
//  TextField.swift
//  TONApp
//
//  Created by Aurocheg on 7.04.23.
//

import UIKit
import WalletUtils

public final class TextField: UITextField {
    public var backspaceCalled: (() -> ())?
    private let bgColor = UIColor(red: 0.937, green: 0.937, blue: 0.953, alpha: 1)

    public convenience init(phraseNumber: Int) {
        self.init(frame: .zero)
        
        configureUI()
        
        let leftView = createViewSide(size: CGSize(width: 42, height: 50))
        
        let leftViewLabel = UILabel()
        
        if phraseNumber >= 10 {
            leftViewLabel.frame = CGRect(x: 11, y: 0, width: 26, height: 50)
        } else {
            leftViewLabel.frame = CGRect(x: 16, y: 0, width: 26, height: 50)
        }
        
        leftViewLabel.text = "\(phraseNumber):"
        leftViewLabel.textColor = ThemeColors.textSecondary
        leftViewLabel.font = .systemFont(ofSize: 17)
        
        leftView.addSubview(leftViewLabel)
 
        self.leftView = leftView
        leftViewMode = .always
        
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: 26, height: 50)
        self.rightView = rightView
        rightViewMode = .always
    }
    
    public override func deleteBackward() {
        super.deleteBackward()
        backspaceCalled?()
    }
}

private extension TextField {
    func configureUI() {
        backgroundColor = bgColor
        layer.cornerRadius = 10
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
    }
    
    func createViewSide(size: CGSize) -> UIView {
        let view = UIView()
        let point = CGPoint(x: 0, y: 0)
        view.frame = CGRect(origin: point, size: size)
        return view
    }
}
