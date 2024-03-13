//
//  ScannerIntroView.swift
//  iosApp
//
//  Created by Timur Karimov on 12.03.2024.
//  Copyright © 2024 SiberianPro. All rights reserved.
//

import SwiftUI

struct ScannerIntroView: View {
	var body: some View {
		VStack(alignment: .leading) {
			header
			Spacer()
			onboarding
				.padding(.bottom, 30)
			
			Button {
				// TODO
			} label: {
				Text("Отсканировать штрих-код")
					.padding()
					.font(Font.headline.weight(.bold))
					.frame(maxWidth: .infinity)
					.background(.black)
					.foregroundStyle(.white)
					.clipShape(.rect(cornerRadius: 10))
			}
			
			Button {
				// TODO
			} label: {
				Text("Ввести штрих код вручную")
					.padding()
					.foregroundStyle(.black)
					.frame(maxWidth: .infinity)
					.font(Font.headline.weight(.bold))
			}
		}
		.padding(.all, 15)
	}
	
	var header: some View {
		HStack {
			Text("Сканер")
				.font(Font.title)
			Spacer()
			Button {
				// todo
			} label: {
				Image("scanner_xmark", bundle: .main)
					.resizable()
					.frame(width: 24, height: 24)
					.foregroundStyle(.black)
			}
			.padding(.trailing, 10)
		}
	}
	
	var onboarding: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text("Как это работает?")
				.padding(.bottom, 30)
				.font(Font.title2)
			HStack(alignment: .center, spacing: 20) {
				Image("icon_placeholder", bundle: .main)
					.resizable()
					.frame(width: 60, height: 60)
				Text("Найдите штрих-код на упаковке товара")
					.fixedSize(horizontal: false, vertical: true)
			}
			DottedLine()
				.stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
				.frame(width: 1, height: 32)
				.foregroundColor(Color.gray)
				.offset(CGSize(width: 30.0, height: 0))
			HStack(alignment: .center, spacing: 20) {
				Image("icon_placeholder", bundle: .main)
				Text("Сканируйте его")
			}
			DottedLine()
				.stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
				.frame(width: 1, height: 32)
				.foregroundColor(Color.gray)
				.offset(CGSize(width: 30.0, height: 0))
			HStack(alignment: .center, spacing: 20) {
				Image("icon_placeholder", bundle: .main)
				Text("Узнайте информацию о товаре")
			}
		}
	}
}

#Preview {
	ScannerIntroView()
}
