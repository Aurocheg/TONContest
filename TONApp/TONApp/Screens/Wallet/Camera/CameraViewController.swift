//
//  CameraViewController.swift
//  TONApp
//
//  Created by Aurocheg on 1.05.23.
//

import UIKit
import Foundation
import WalletUI
import WalletUtils
import AVFoundation

protocol CameraViewProtocol: AnyObject {
    
}

final class CameraViewController: UIViewController {
    // MARK: - Properties
    public var presenter: CameraPresenterProtocol!
    public var configurator = CameraConfigurator()
    
    private let captureDevice = AVCaptureDevice.default(for: .video)
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - UI Elements
    private let titleLabel = TitleLabel(
        text: "Scan QR code",
        fontSize: 28,
        textColor: ThemeColors.textOverlay
    )
    private var scanView: ScanView?
    private var overlayView: UIView?
    private let stackView = StackView(distribution: .equalSpacing)
    private lazy var actionButtons = [galleryButton, flashlightButton]
    private let galleryButton = ActionButton(with: .gallery)
    private let flashlightButton = ActionButton(with: .flashlight)
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        
        guard let captureDevice = captureDevice else {
            print("Захватывающее устройство недоступно")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            scanView = ScanView()
            if let scanView = scanView {
                view.addSubview(scanView)
                view.bringSubviewToFront(scanView)
                
                let scanFrameSize = CGSize(width: 258, height: 258)
                scanView.frame = CGRect(x: view.bounds.midX - scanFrameSize.width/2,
                                        y: view.bounds.midY - scanFrameSize.height/2,
                                        width: scanFrameSize.width,
                                        height: scanFrameSize.height)
            }
            
            overlayView = UIView(frame: view.bounds)
            if let overlayView = overlayView {
                let maskLayer = CAShapeLayer()
                let path = UIBezierPath(rect: view.bounds)
                path.append(UIBezierPath(rect: scanView?.frame ?? .zero).reversing())
                maskLayer.path = path.cgPath
                maskLayer.fillRule = .evenOdd
                overlayView.layer.mask = maskLayer
                 
                overlayView.backgroundColor = .black.withAlphaComponent(0.6)
                view.addSubview(overlayView)
                view.bringSubviewToFront(overlayView)
            }
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession?.startRunning()
            }
        } catch {
            print("Ошибка при настройке захватывающего устройства: \(error.localizedDescription)")
        }
        
        if captureDevice.hasTorch == true {
             do {
                 try captureDevice.lockForConfiguration()
                 captureDevice.torchMode = .on
                 captureDevice.torchMode = .auto
                 captureDevice.unlockForConfiguration()
             } catch {
                 print("Устройство недоступно")
             }
         } else {
             print("Устройство не поддерживает фонарик")
         }
                                
        setupHierarchy()
        setupLayout()
        setupProperties()
        setupTargets()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = view.layer.bounds
        overlayView?.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .white
        changeNavBarBackground(to: .black)
        
        if captureSession?.isRunning == false {
            captureSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }
    }
}

// MARK: - Private methods
private extension CameraViewController {
    func setupHierarchy() {
        view.addSubviews(titleLabel, stackView)
        stackView.addArrangedSubviews(galleryButton, flashlightButton)
    }
    
    func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenSize.height * 0.142).isActive = true
    
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -107).isActive = true
        
        actionButtons.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 72).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 72).isActive = true
        }
    }
    
    func setupProperties() {
        stackView.backgroundColor = .clear
        actionButtons.forEach { $0.layer.cornerRadius = 36 }
    }
    
    func setupTargets() {
        flashlightButton.addTarget(self, action: #selector(flashlightButtonTapped), for: .touchUpInside)
    }
    
    @objc func flashlightButtonTapped() {
        if captureDevice?.hasTorch == true {
            do {
                try captureDevice?.lockForConfiguration()
                if captureDevice?.isTorchActive == true {
                    captureDevice?.torchMode = .off
                } else {
                    captureDevice?.torchMode = .on
                }
                captureDevice?.unlockForConfiguration()
            } catch {
                print("Устройство недоступно")
            }

        }
    }
}

// MARK: - CameraViewProtocol
extension CameraViewController: CameraViewProtocol {
    
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Проверка, что получены метаданные
        if metadataObjects.count == 0 {
            scanView?.frame = CGRect.zero
            print("QR-код не обнаружен")
            return
        }
        
        // Получение метаданных и их преобразование в объекты маштабируемых метаданных
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            scanView?.frame = CGRect.zero
            print("Невозможно прочитать метаданные")
            return
        }
        
        // Проверка, что метаданные являются QR-кодом
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // Если метаданные содержат строку, то выводится ее значение
            if let qrCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) {
                scanView?.frame = qrCodeObject.bounds
                
                if let qrCodeString = metadataObj.stringValue, qrCodeString.contains("ton") {
                    presenter.qrCodeFound(qrCodeString)
                }
            }
        }
    }
}
