//
//  BackgroundButton.swift
//  TONApp
//
//  Created by Aurocheg on 29.03.23.
//

import UIKit

public final class BackgroundButton: UIButton {
    private var circularIndicatorView: CircularIndicatorView?
    private var checkmarkView: CheckmarkView?
    
    public init(
        text: String? = nil,
        titleColor: UIColor = ThemeColors.textOverlay,
        background: UIColor = ThemeColors.accent,
        icon: UIImage? = nil
    ) {
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel?.textAlignment = .center
        
        backgroundColor = background
        layer.cornerRadius = 12
        
        if let icon = icon {
            setImage(icon, for: .normal)
            
            imageView?.contentMode = .scaleAspectFit
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            
            if text != nil {
                contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
            }
        }
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addIndicatorView() {
        circularIndicatorView = CircularIndicatorView()
        guard let circularIndicatorView = circularIndicatorView else { return }
        
        addSubview(circularIndicatorView)
        
        circularIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        circularIndicatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -17).isActive = true
        circularIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circularIndicatorView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        circularIndicatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    public func removeIndicatorView() {
        circularIndicatorView?.removeFromSuperview()
    }
    
    public func addCheckmark() {
        checkmarkView = CheckmarkView()
        guard let checkmarkView = checkmarkView else { return }
        
        addSubview(checkmarkView)
        
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        checkmarkView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkmarkView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        checkmarkView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        checkmarkView.animateCheckmark()
    }
}

private extension BackgroundButton {
    @objc func buttonTapped() {
        UIView.animate(withDuration: 0.1) {
            self.alpha = 0.6
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.alpha = 1.0
                self.transform = CGAffineTransform.identity
            }
        }

    }
}
