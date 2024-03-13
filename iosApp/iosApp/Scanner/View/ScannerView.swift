//
//  ScannerView.swift
//  iosApp
//
//  Created by Timur Karimov on 11.03.2024.
//  Copyright © 2024 SiberianPro. All rights reserved.
//

import SwiftUI
import AVKit

struct ScannerView: View {
	@State private var isScanning = false
	@State private var cameraPermission: CameraPermission = .idle
	
	@State private var session: AVCaptureSession = .init()
	@State private var qrOutput: AVCaptureMetadataOutput = .init()
	
	@State private var errorMessage: String = ""
	@State private var showError: Bool = false
	
	@Environment(\.openURL) private var openURL
	
	@StateObject private var scannerDelegate: ScannerDelegate = .init()
	@State private var scannedCode: String = ""
	
	var body: some View {
		ZStack {
			GeometryReader { geometry in
				CameraView(frameSize: geometry.size,
						   session: $session)
			}
			.background(.gray)
			.ignoresSafeArea()
			
			VStack(spacing: 8) {
				
				Text("Поместите штрих код в рамку")
					.font(.title3)
					.foregroundStyle(.black.opacity(0.8))
					.padding(.bottom, 30)
				
				// Camera Borders
				ZStack {
					var fractions = [0.64...0.67, 0.33...0.36, 0.14...0.17, 0.83...0.86]
					ForEach(0..<4, id: \.self) { index in
						RoundedRectangle(cornerRadius: 2, style: .circular)
							.trim(from: fractions[index].lowerBound, to: fractions[index].upperBound)
							.stroke(.white, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
					}
				}
				.aspectRatio(0.62, contentMode: .fit)
				.padding(.horizontal, 45)
				.padding(.bottom, 30)
				
				Button {
					if !session.isRunning && cameraPermission == .approved {
						startSession()
						startScannerAnimation()
					}
				} label: {
					Image(systemName: "qrcode.viewfinder")
						.font(.largeTitle)
						.foregroundStyle(.white)
				}
			}
			.onAppear(perform: checkCameraPermission)
			.alert(errorMessage, isPresented: $showError) {
				if cameraPermission == .denied {
					Button("Settings") {
						if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
							openURL(settingsURL)
						}
					}
				}
				Button("Cancel", role: .cancel, action: {})
			}
			.onChange(of: scannerDelegate.scannedCode) { newValue in
				if let code = newValue {
					scannedCode = code
					session.stopRunning()
					stopScannerAnimation()
					scannerDelegate.scannedCode = nil
				}
			}
		}
	}
	
	func checkCameraPermission() {
		Task {
			switch AVCaptureDevice.authorizationStatus(for: .video) {
			case .authorized:
				cameraPermission = .approved
				setupCamera()
			case .notDetermined:
				if await AVCaptureDevice.requestAccess(for: .video) {
					cameraPermission = .approved
					setupCamera()
				} else {
					cameraPermission = .denied
					presentError("Provide access to camera")
				}
			case .denied, .restricted:
				cameraPermission = .denied
				presentError("Provide access to camera")
			default: break
			}
		}
	}
	
	func setupCamera() {
		do {
			guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInUltraWideCamera, .builtInWideAngleCamera],
																mediaType: .video,
																position: .back).devices.first else {
				presentError("Unknown Device Camera Error")
				return
			}
			
			let input = try AVCaptureDeviceInput(device: device)
			guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
				presentError("Unknown Input/Output Error")
				return
			}
			
			session.beginConfiguration()
			session.addInput(input)
			session.addOutput(qrOutput)
			qrOutput.metadataObjectTypes = [.qr]
			qrOutput.setMetadataObjectsDelegate(scannerDelegate, queue: .main)
			session.commitConfiguration()
			
			DispatchQueue.global(qos: .background).async {
				session.startRunning()
			}
			
			startScannerAnimation()
			
		} catch {
			presentError(error.localizedDescription)
		}
	}
	
	func presentError(_ message: String) {
		errorMessage = message
		showError.toggle()
	}
	
	func startSession() {
		DispatchQueue.global(qos: .background).async {
			session.startRunning()
		}
	}
	
	func startScannerAnimation() {
		withAnimation(
			.easeInOut(duration: 0.85)
			.delay(0.1)
			.repeatForever(autoreverses: true)) {
				isScanning = true
		}
	}
	
	func stopScannerAnimation() {
		withAnimation(.easeInOut(duration: 0.85)) {
			isScanning = false
		}
	}
}

#Preview {
	ScannerView()
}
