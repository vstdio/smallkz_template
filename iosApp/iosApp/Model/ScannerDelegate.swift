//
//  ScannerDelegate.swift
//  iosApp
//
//  Created by Timur Karimov on 12.03.2024.
//  Copyright © 2024 SiberianPro. All rights reserved.
//

import AVKit

class ScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
	@Published var scannedCode: String?
	
	func metadataOutput(_ output: AVCaptureMetadataOutput,
						didOutput metadataObjects: [AVMetadataObject],
						from connection: AVCaptureConnection) {
		if let metaObject = metadataObjects.first {
			guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else { return }
			guard let code = readableObject.stringValue else { return }
			scannedCode = code
			print(scannedCode)
		}
	}
}
