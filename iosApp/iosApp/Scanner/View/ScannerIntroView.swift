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
			HStack {
				Text("Сканер")
					.font(Font.title)
				Spacer()
				Button {
					// todo
				} label: {
					Image(systemName: "xmark")
						.resizable()
						.frame(width: 24, height: 24)
						.foregroundStyle(.black)
				}
			}
			
			Spacer()
			
			VStack(alignment: .leading) {
				Text("Как это работает?")
					.padding(.bottom, 30)
					.font(Font.title2)
				HStack(alignment: .center, spacing: 20) {
					Image("icon_placeholder", bundle: .main)
					Text("Найдите штрих-код на упаковке товара")
						.fixedSize(horizontal: false, vertical: true)
				}
				HStack(alignment: .center, spacing: 20) {
					Image("icon_placeholder", bundle: .main)
					Text("Сканируйте его")
				}
				HStack(alignment: .center, spacing: 20) {
					Image("icon_placeholder", bundle: .main)
					Text("Узнайте информацию о товаре")
				}
			}
			.padding(.bottom, 30)
			
			Button {
				
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
				
			} label: {
				Text("Ввести штрих код вручную")
					.padding()
					.foregroundStyle(.black)
					.font(Font.headline.weight(.bold))
			}
			.frame(maxWidth: .infinity, alignment: .center)
		}
		.padding(.all, 15)
	}
}

#Preview {
	ScannerIntroView()
}
