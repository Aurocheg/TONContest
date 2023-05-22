//
//  SettingsTableCell.swift
//  TONApp
//
//  Created by Aurocheg on 17.04.23.
//

import UIKit
import WalletEntity

public final class SettingsTableCell: UITableViewCell {
    // MARK: - Properties
    public static let reuseIdentifier = "SettingsTableCell"
    public var pickerCompletion: ((_ title: String) -> ())? = nil
    public var switchCompletion: ((_ isOn: Bool) -> ())? = nil
    
    // MARK: - UI Elements
    private var switchButton: Switch?
    private var pickerButton: NonBackgroundButton?
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension SettingsTableCell {
    func configureSwitch(with: SettingSwitchType) {
        switchButton = Switch(isOn: true)
        guard let switchButton = switchButton else { return }
        
        contentView.addSubview(switchButton)
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        
        switchButton.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    func configurePickerButton(with entity: SettingData, type: SettingPickerType) {
        guard let pickerData = entity.pickers else { return }
        
        pickerButton = NonBackgroundButton(
            text: pickerData[0].title,
            fontWeight: .regular,
            icon: UIImage(named: "arrow-up-down-12"),
            iconAlignment: .right
        )
        guard let pickerButton = pickerButton else { return }
        pickerButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
        
        var menuChildren = [UIAction]()
        
        pickerData.forEach { currentPicker in
            let action = UIAction(title: currentPicker.title) { _ in
                pickerButton.setTitle(currentPicker.title, for: .normal)
                self.pickerCompletion?(currentPicker.title)
            }
            menuChildren.append(action)
        }
        
        pickerButton.showsMenuAsPrimaryAction = true
        pickerButton.menu = UIMenu(children: menuChildren)
        
        contentView.addSubview(pickerButton)
        
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        pickerButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        pickerButton.widthAnchor.constraint(equalToConstant: 59).isActive = true
        pickerButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        pickerButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
    }
    
    @objc func switchChanged(sender: Switch) {
        switchCompletion?(sender.isOn)
    }
}

public extension SettingsTableCell {
    func configure(with type: SettingCellConfiguration, entity: SettingData) {
        switch type {
        case .switch(let type):
            configureSwitch(with: type)
        case .picker(let type):
            configurePickerButton(with: entity, type: type)
        case .disclosure:
            accessoryType = .disclosureIndicator
        default: break
        }
        
        if accessoryType != .disclosureIndicator {
            selectionStyle = .none
        }
    }
    
    func setPickerButtonTitle(_ title: String?) {
        guard let title = title else {
            return
        }
        pickerButton?.setTitle(title, for: .normal)
    }
    
    func setSwitchTurned(isOn: Bool?) {
        guard let isOn = isOn else {
            return
        }
        switchButton?.isOn = isOn
    }
}
