//
//  CameraView.swift
//  iosApp
//
//  Created by Timur Karimov on 12.03.2024.
//  Copyright © 2024 SiberianPro. All rights reserved.
//

import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
	var frameSize: CGSize
	@Binding var session: AVCaptureSession
	
	func makeUIView(context: Context) -> some UIView {
		let view = UIView(frame: CGRect(origin: .zero, size: frameSize))
		view.backgroundColor = .clear
		
		let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
		cameraLayer.frame = .init(origin: .zero, size: frameSize)
		cameraLayer.videoGravity = .resizeAspectFill
		cameraLayer.masksToBounds = true
		view.layer.addSublayer(cameraLayer)
		
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
}

