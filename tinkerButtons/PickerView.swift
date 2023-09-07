//	Created on 7/9/23.

import SwiftUI

struct PickerView: View {

	@State var selectedItem: String = ""
	let items: [String] = [
		"First",
		"Second",
		"Third"
	]
	private enum Config {
		static let listLabel = "List label here"
		static let listPlaceholder = "Select serial number"
		static let listPlaceHolderColor = Color.gray
		static let backgroundColor = Color.white
		static let textColor = Color.primary
		static let linkColor = Color(uiColor: .link)
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {

			Text(Config.listLabel)
				.font(.callout)
				.foregroundColor(Config.textColor)

			RoundedRectangle(
				cornerRadius: 7,
				style: .continuous
			)
			.fill(Config.backgroundColor)

			.overlay {
				RoundedRectangle(
					cornerRadius: 7,
					style: .continuous
				)
				.stroke(
					Color.gray,
					lineWidth: 1
				)
			}
			.overlay(alignment: .leading) {

				Menu { // Wrap Picker in a Menu
					Picker(
						selection: $selectedItem,
						label: EmptyView()
					) {
						Text(Config.listPlaceholder)
							.font(.callout).italic() // 400 16px
							.foregroundColor(Config.listPlaceHolderColor)
							.tag("") // HACK: to fix a xcode console message

						ForEach(items, id: \.self) { item in
							Text(item).tag(item)
								.font(.headline)
						}
					}

				} label: {
					HStack(spacing: 0) {
						if selectedItem.isEmpty {
							Text(Config.listPlaceholder)
								.font(.callout).italic()
								.foregroundColor(Config.listPlaceHolderColor)
						} else {
							Text(selectedItem)
								.font(.callout).bold()
								.foregroundColor(Config.textColor)
						}

						Spacer() // this expands the tapable area

						Image(systemName: "chevron.down")
							.resizable()
							.renderingMode(.template)
							.tint(Config.linkColor)
							.frame(width: 14, height: 8)
					}
					.padding(.horizontal, 16)
					.frame(width: (352), height: (50-4))
				}
				.background(Color.pink.opacity(0.1)) // this is the tapable area

			}
			.frame(width: 352, height: 50)
		}
		.padding(.vertical, 16)

	}
}

struct PickerView_Previews: PreviewProvider {
	static var previews: some View {
		PickerView()
	}
}

