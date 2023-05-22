//
//  SettingViewController.swift
//  TONApp
//
//  Created by Aurocheg on 17.04.23.
//

import UIKit
import WalletEntity
import WalletUtils
import WalletUI

protocol SettingViewProtocol: AnyObject {}

final class SettingViewController: UIViewController {
    // MARK: - Properties
    public var presenter: SettingPresenterProtocol!
    public var configurator = SettingConfigurator()
    
    private let tableView = SettingsTableView()
        
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        setupHierarchy()
        setupProperties()
        setupLayout()
        setupTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Wallet Settings"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        
        presenter.configureSettingsIfPossible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        title = nil
    }
}

// MARK: - Private methods
private extension SettingViewController {
    func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    func setupProperties() {
        view.backgroundColor = ThemeColors.backgroundGrouped
    }
    
    func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupTargets() {
        presenter.getSettings()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableCell.self, forCellReuseIdentifier: SettingsTableCell.reuseIdentifier)
    }
    
    func switchChanged(configuration: SettingCellConfiguration, isOn: Bool) {
        switch configuration {
        case .switch(let type):
            presenter.switchChanged(type, isOn: isOn)
        default:
            break
        }
    }
    
    func pickerChanged(configuration: SettingCellConfiguration, title: String) {
        switch configuration {
        case .picker(let type):
            presenter.pickerChanged(type, title: title)
        default:
            break
        }
    }
    
    @objc func closeButtonTapped() {
        presenter.closeButtonTapped()
    }
}

// MARK: - SettingViewProtocol
extension SettingViewController: SettingViewProtocol {}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.applyCorners(to: [.topLeft, .topRight], with: view.bounds)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = tableView.numberOfRows(inSection: indexPath.section) - 1 == indexPath.row
        
        if isLastCell {
            cell.applyCorners(to: [.bottomLeft, .bottomRight], with: cell.bounds)
        } else {
            cell.removeCorners()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = presenter.settings[indexPath.section].data[indexPath.row]
        
        switch currentItem.configuration {
        case .disclosure:
            if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    presenter.recoveryPhraseTapped()
                case 1:
                    presenter.changePasscodeTapped()
                default:
                    break
                }
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.settings.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.settings[section].sectionTitle?.uppercased()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if presenter.settings[section].sectionTitle == nil {
            return 0.0
        }
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.settings[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableCell.reuseIdentifier) as? SettingsTableCell else {
            return SettingsTableCell()
        }
        let currentSetting = presenter.settings[indexPath.section].data[indexPath.row]
                
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.prefersSideBySideTextAndSecondaryText = true
        
        contentConfiguration.text = currentSetting.settingName
                
        switch currentSetting.configuration {
        case .delete:
            contentConfiguration.textProperties.color = ThemeColors.systemRed
        default:
            break
        }
 
        cell.contentConfiguration = contentConfiguration
        
        cell.configure(with: currentSetting.configuration, entity: currentSetting)
        
        switch currentSetting.configuration {
        case .picker(let type):
            switch type {
            case .contract:
                cell.setPickerButtonTitle(presenter.currentContract)
            case .currency:
                cell.setPickerButtonTitle(presenter.currentCurrency)
            }
        case .switch(let type):
            switch type {
            case .notification:
                cell.setSwitchTurned(isOn: presenter.isNotificationsEnabled)
            case .faceId:
                cell.setSwitchTurned(isOn: presenter.isFaceIdEstablished)
            }
        
        case .delete:
            contentConfiguration.textProperties.color = ThemeColors.systemRed
        default:
            break
        }
        
        cell.switchCompletion = { [weak self] isOn in
            guard let strongSelf = self else {
                return
            }
            strongSelf.switchChanged(configuration: currentSetting.configuration, isOn: isOn)
        }
        
        cell.pickerCompletion = { [weak self] title in
            guard let strongSelf = self else {
                return
            }
            strongSelf.pickerChanged(configuration: currentSetting.configuration, title: title)
        }
        
        return cell
    }
}
