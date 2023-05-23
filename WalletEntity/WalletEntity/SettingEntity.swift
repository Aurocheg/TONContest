//
//  SettingEntity.swift
//  TONApp
//
//  Created by Aurocheg on 17.04.23.
//

import Foundation

public enum SettingSwitchType {
    case notification
    case faceId
}

public enum SettingPickerType {
    case contract
    case currency
}

public enum SettingCellConfiguration {
    case `switch`(SettingSwitchType)
    case picker(SettingPickerType)
    case disclosure
    case delete
}

public protocol SettingEntity {
    var sectionIndex: Int { get }
    var sectionTitle: String? { get }
    var data: [SettingData] { get }
}

public struct Setting: SettingEntity {
    public var sectionIndex: Int
    public var sectionTitle: String?
    public var data: [SettingData]
    
    public static func getSettings() -> [SettingEntity] {
        [
            Setting(
                sectionIndex: 0,
                sectionTitle: "General",
                data: [
                    SettingData(settingName: "Notifications", configuration: .switch(.notification)),
                    SettingData(
                        settingName: "Active address",
                        configuration: .picker(.contract),
                        pickers: [
                            SettingPicker(title: ContractConstants.v4R2.rawValue),
                            SettingPicker(title: ContractConstants.v3R2.rawValue),
                            SettingPicker(title: ContractConstants.v3R1.rawValue)
                        ]
                    ),
                    SettingData(
                        settingName: "Primary currency",
                        configuration: .picker(.currency),
                        pickers: [
                            SettingPicker(title: CurrencyConstants.dollar.rawValue),
                            SettingPicker(title: CurrencyConstants.euro.rawValue)
                        ]
                    )
                ]
            ),
            Setting(
                sectionIndex: 1,
                sectionTitle: "Security",
                data: [
                    SettingData(settingName: "Show recovery phrase", configuration: .disclosure),
                    SettingData(settingName: "Change passcode", configuration: .disclosure),
                    SettingData(settingName: "Face ID", configuration: .switch(.faceId))
                ]
            ),
            Setting(
                sectionIndex: 2,
                sectionTitle: nil,
                data: [
                    SettingData(settingName: "Delete wallet", configuration: .delete)
                ]
            )
        ]
    }
}

public struct SettingData {
    public var settingName: String
    public var configuration: SettingCellConfiguration
    public var pickers: [SettingPicker]?
}

public struct SettingPicker {
    public let title: String
}
