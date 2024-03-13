//
//  DottedLineShape.swift
//  iosApp
//
//  Created by Timur Karimov on 13.03.2024.
//  Copyright © 2024 SiberianPro. All rights reserved.
//

import SwiftUI

struct DottedLine: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: 0, y: rect.height))
		return path
	}
}

