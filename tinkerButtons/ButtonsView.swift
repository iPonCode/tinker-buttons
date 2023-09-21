//	Created on 7/9/23.
//	See also Apple guidelines for Buttons:
//	https://developer.apple.com/design/human-interface-guidelines/buttons
//	and check sources: https://stackoverflow.com/a/76105625

import SwiftUI

struct ButtonsView: View {
	
	private let cancelKey = "Cancel"
	private let fakeAction = { print("Button tapped (random:\(Int.random(in: 0...1000)))") }
	
	/// The environment value that indicates whether the setting Button Shapes is enabled
	@Environment(\.accessibilityShowButtonShapes) private var accessibilityShowButtonShapes: Bool
	
	var body: some View {
		
		// NOTE - Button Shapes (Contorno de Botones) refers to:
		//        Settings > Accessibility > Pantalla y tamaño de texto > Button Shapes > On
		// When Button Shapes is on all the Button() instances without a
		// .buttonStyle modifier applyed will modify its appearance (bloated with a transparent grey surround)
		
		ScrollView(.vertical, showsIndicators: true) {
			VStack(spacing: 24) {
				
				// MARK: - Regular Button
				/// Call to action label or tappable content with no particular shape
				/// When Button Shapes is turned on, the button take on an enclosing gray background (increasing its size)
				VStack(spacing: 4) {
					Text("Regular Button").bold()
					HStack(spacing: 0) {
						Text("This is a ")
						Button(
							LocalizedStringKey(cancelKey),
							role: .cancel,
							action: fakeAction
						)
						Text(" Button")
					}
				}
				
				// MARK: - Traditional Shape Button
				/// RoundedRectangle, Capsule. etc… since it already looks like a button,
				/// By using a ButtonStyle, the buttons don't change shape when the device
				/// setting Button Spapes is turned on. they don't get bloated with a transparent grey surround
				VStack(spacing: 4) {
					Text("Traditional Shape .buttonStyle").bold()
					HStack(spacing: 0) {
						Text("This is a ")
						Styles.createRegularButton(
							label: "Button",
							action: fakeAction
						)
						Text(" Button")
					}
					HStack(spacing: 0) {
						Text("This is an ")
						Styles.createRegularButton(
							label: "Other Button",
							action: fakeAction
						)
						Text(" Button")
					}
				}
				
				// MARK: - Regular Button
				/// Tappable content with a well-defined shape and embedded label
				/// No visual effect when Button Shapes is turned on
				VStack(spacing: 4) {
					Text("Regular Button").bold()
					VStack(spacing: 0) {
						Text("Any tapable content")
						HStack {
							Circle()
								.fill(Color.cyan)
								.frame(width: 24)
							Circle()
								.fill(Color.green)
								.frame(width: 18)
							Circle()
								.fill(Color.brown)
								.frame(width: 12)
						}
						Text("More tappable content").italic()
					}
					.padding()
					.background(RoundedRectangle(cornerRadius: 7).strokeBorder(style: .init(lineWidth: 1)))
					.onTapGesture(perform: fakeAction)
				}
				
				// MARK: - Represented by a symbol Button
				/// Tappable call to action Image
				/// No visual effect when Button Shapes is turned on
				VStack(spacing: 4) {
					Text("Symbol Button").bold()
					Image(systemName: "ellipsis")
						.resizable()
						.scaledToFit()
						.overlay(Rectangle(	).strokeBorder())
					
					// Apple recommends 44x44 as the minimum size for a tappable area in the guidelines
						.frame(width: 170, height: 170)
						.foregroundColor(Styles.mySymbolButtonFg)
					
					// If .contentShape is NOT present, only the icon shape (the tree dots of the ellipsis)
					// will be tapable and not the pink or green zone
					
					// If .contentShape is defined here, the whole icon shape (tree dots + its transparent areas)
					// will be tapable and not the pink or green trailing paddings
					
					// PINK ZONE
						.padding(.trailing, 50)
						.background(Color.pink.opacity(0.2))
						.overlay(Rectangle().strokeBorder(style: StrokeStyle(lineWidth: 0.3, dash: [1]), antialiased: true))
					
					// Setting the content shape allows taps to work anywhere
					// within the frame, including transparent parts
						.contentShape(Rectangle()) // tapable on pink zone and not tapable on green zone
						.onTapGesture(perform: fakeAction)
					// It is good practice to provide an accessibility label too
						.accessibilityLabel(Text(LocalizedStringKey("alternative text label")))
					
					// GREEN ZONE
						.padding(.trailing, 50)
						.background(Color.green.opacity(0.2))
						.overlay(Rectangle().strokeBorder(style: StrokeStyle(lineWidth: 0.3, dash: [1]), antialiased: true))
					
					// If .contentShape is defined here, the whole icon shape + pink + geen paddings
					// will be tapables
					
					//					.background(
					//						RoundedRectangle(cornerRadius: 7)
					//							.strokeBorder(
					//								style: StrokeStyle(
					//									lineWidth: 0.3, dash: [1], dashPhase: 0), antialiased: true
					//							)
					//					)
				}
				
				// MARK: - Text Link Button
				/// Simple tappable text that behaves like an HTML link.
				/// When Button Shapes (in Accessibility Settings) is turned on, the text should be UNDERLINED
				VStack(spacing: 4) {
					Text("Text Link").bold()
					VStack(spacing: 0) {
						
						HStack(spacing: 0) {
							Text("This is ")
							Styles.textLink(
								"a text link",
								buttonShapesEnabled: accessibilityShowButtonShapes
							)
							.onTapGesture(perform: fakeAction)
							// .background(Color.pink.opacity(0.1))
							Text(" Button")
						}
					}
					.padding()
				}
				
			}
			
		}
	}
}

struct ButtonsView_Previews: PreviewProvider {
	static var previews: some View {
		ButtonsView()
	}
}

/// A ButtonStyle for a regular rectangular button with rounded corners.
/// By using a ButtonStyle, the buttons don't change shape when the device
/// setting Button Spapes is turned on. In particular, they don't get bloated
/// with a transparent grey surround
struct RegularButton: ButtonStyle {
	
	private let bgColor: Color
	private let cornerRadius: CGFloat
	
	init(
		bgColor: Color,
		cornerRadius: CGFloat = Styles.cornerRadius
	) {
		self.bgColor = bgColor
		self.cornerRadius = cornerRadius
	}
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.background(bgColor)
			.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
	}
}

struct Styles {
	
	/// Colors and configurations
	static let cornerRadius: CGFloat = 7
	static let myRegularButtonLabelColor = Color.white
	static let myRegularButtonBgColor = Color.blue
	static let mySymbolButtonFg = Color.orange
	static let myTextLinkColorLabelColor = Color.pink
	
	/// Factory method for a regular button
	static func createRegularButton(
		label: String,
		action: @escaping () -> Void
	) -> some View {
		Button(action: action) {
			Text(LocalizedStringKey(label))
				.foregroundColor(Styles.myRegularButtonLabelColor)
				.padding()
		}
		.buttonStyle(
			RegularButton(bgColor: Styles.myRegularButtonBgColor)
		)
	}
	
	/// Factory method for textLink
	static func textLink(
		_ label: String,
		buttonShapesEnabled: Bool
	) -> Text {
		(
			buttonShapesEnabled ?
			Text(LocalizedStringKey(label)).underline() :
				Text(LocalizedStringKey(label))
		)
		.foregroundColor(Styles.myTextLinkColorLabelColor)
	}
}

