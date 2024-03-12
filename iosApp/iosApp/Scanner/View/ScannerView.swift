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
		VStack(spacing: 8) {
			Button {
				
			} label: {
				Image(systemName: "xmark")
					.font(.title3)
					.foregroundStyle(.blue)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			
			Text("Place the QR code inside the area")
				.font(.title3)
				.foregroundStyle(.black.opacity(0.8))
				.padding(.top, 20)
			
			Text("Scanning will start automatically")
				.font(.callout)
				.foregroundStyle(.gray)
			
			Spacer(minLength: 0)
			
			// Camera
			GeometryReader {
				let size = $0.size
				
				ZStack {
					CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
						.scaleEffect(0.97)
					ForEach(0..<4, id: \.self) { index in
						RoundedRectangle(cornerRadius: 2, style: .circular)
							.trim(from: 0.61, to: 0.64)
							.stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
							.rotationEffect(.degrees(Double(index) * 90))
					}
				}
				.aspectRatio(1.0, contentMode: .fit)
				.overlay(alignment: .top, content: {
					Rectangle()
						.fill(.blue)
						.frame(height: 2.5)
						.shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
						.offset(y: isScanning ? size.width : 0)
				})
				.frame(width: size.width, height: size.height)
			}
			.padding(.horizontal, 45)
			
			Spacer(minLength: 15)
			
			Button {
				if !session.isRunning && cameraPermission == .approved {
					startSession()
					startScannerAnimation()
				}
			} label: {
				Image(systemName: "qrcode.viewfinder")
					.font(.largeTitle)
					.foregroundStyle(.gray)
			}
			
			Spacer(minLength: 45)
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
