//  Created on 7/9/23.

import SwiftUI

enum Screen: CaseIterable, CustomStringConvertible {
	case idle, buttons, picker, matix
	var description: String {
		switch self {
		case .idle: return "Select"
		case .buttons: return "Buttons"
		case .picker: return "Picker"
		case .matix: return "Matrix"
		}
	}
}

struct SelectionView: View {

	@State var screen: Screen = .idle

	var body: some View {
		VStack {
			Picker(
				selection: $screen,
				label: EmptyView()
			) {
				ForEach(Screen.allCases, id: \.self) { screen in
					Text(screen.description).tag(screen)
						.font(.headline)
				}
			}
			switch screen {
			case .idle: EmptyView()
			case .buttons: ButtonsView()
			case .picker: PickerView()
			case .matix: MatrixView()
			}
		}
	}
}

struct SelectionView_Previews: PreviewProvider {
	static var previews: some View {
		SelectionView()
	}
}

