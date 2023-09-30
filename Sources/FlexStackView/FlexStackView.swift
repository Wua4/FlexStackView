#if canImport(UIKit)
import UIKit
#endif
/*
 - [x] Problem 2: DynamicFont, Reasonable Dynamically Sized Font Library
     - [ ] See if override UILabel allowed (Care for buttons/attributed text) - NO, TOO DANGEROUS
         - [ ] Storyboard
         - [ ] ViewController (titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
     - [x] Leave iPad alone
     - [x] Ease of use prioritized
         - [x] Init functions handle Observers
         - [x] Handle storyboard button issue (Type:System/Style:Default) - CANT
         - [x] Simple naming
*/


public class ViewWithSettings {
    public var view: UIView = UIView()
    public var text: String = ""
    public var font: UIFont = UIFont.preferredFont(forTextStyle: .body)
    public var offset: Int = 0


    public init(view: UIView, text: String, font: UIFont, offset: Int = 0) {
        self.view = view
        self.text = text
        self.font = font
        self.offset = offset
    }
}

public class FlexStackView: UIStackView {
    // default number of items per row
    // will defer lower if content expands
    var views = [ViewWithSettings]()
    public var defaultPerRow = 1
    public var isAdjustable = true
    public var lineLimit: CGFloat = 2

    // set preset for certain row
    // will defer lower if content expands
    public var presetItemsinRow = [Int: Int]()

    public func addView(_ view: UIView, adjustsForText text: String, font: UIFont, _ offset: Int = 0) {
        let newView = ViewWithSettings(view: view, text: text, font: font, offset: offset)
        views.append(newView)
    }

    public func clearAllViews() {
        for subViews in self.arrangedSubviews {
            subViews.removeFromSuperview()
        }

        views = []
    }

    public func checkIfViewFits(width: CGFloat, _ view: ViewWithSettings) -> Bool {
        let font = view.font
        let textAttributes = [NSAttributedString.Key.font: font]

        var maxLines = lineLimit
        if !view.text.contains(" ") {
            maxLines = 1
        }
        let singleLineText = "A" as NSString
        let singleLineHeight = singleLineText.boundingRect(with: CGSizeMake(100, 100), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil).size.height

        let textInView = view.text as NSString
        let calculatedSize = textInView.boundingRect(with: CGSizeMake(width - CGFloat(view.offset), .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil).size

        return calculatedSize.height <= singleLineHeight * maxLines
    }

    public func adjustStacks() {
        var row = 0
        var viewIndex = 0
        while viewIndex < views.count {
            var numForRow = defaultPerRow
            if let presetItems = presetItemsinRow[row] {
                numForRow = presetItems
            }

            let currentStack = UIStackView()
            currentStack.axis = .horizontal
            currentStack.distribution = .fillEqually
            currentStack.alignment = .fill

            let width = UIScreen.main.bounds.width

            for numItemsToTry in (1...numForRow).reversed() {
                var itemsFit = true

                // if adjustable turned on, if item to try in Row > 1
                // confirm if each view will fit
                if numItemsToTry != 1, isAdjustable {
                    for i in viewIndex..<(viewIndex + numItemsToTry) where i < views.count {
                        itemsFit = itemsFit && checkIfViewFits(width: width/CGFloat(numItemsToTry), views[i])
                    }
                }

                if itemsFit {
                    let num = viewIndex
                    for i in num..<(num + numItemsToTry) where i < views.count {
                        currentStack.addArrangedSubview(views[i].view)
                        viewIndex += 1
                    }
                    self.addArrangedSubview(currentStack)
                    break
                } else {
                    continue
                }
            }
            row += 1
        }
    }
}
