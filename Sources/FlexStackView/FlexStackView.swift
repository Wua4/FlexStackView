#if canImport(UIKit)
import UIKit
#endif
/*
- [ ] Problem 1: Flexbox layout with SwiftUI
    - Need a stackview that can automically adjust for space and content size

    - [ ] Handle adjustable font, landscape, iPad
    - [ ] Criteria:
        - [ ] Max allowed per row
        - [ ] Preset for individual row (e.g. 2 for first row, but 1 for else)
*/


/// -
///
public class FlexStackView: UIStackView {
    // default number of items per row
    // will defer lower if content expands
    var views = [UIView]()
    public var defaultPerRow = 1
    public var isAdjustable = true

    // set preset for certain row
    // will defer lower if content expands
    public var presetItemsinRow = [Int: Int]()

    public func addView(_ view: UIView) {
        self.views.append(view)
    }

    public func checkIfViewFits(_ view: UIView) -> Bool {

        return false
    }

    public func adjustStacks() {
        var row = 0
        var index = 0
        while index < views.count {
            if let presetItems = presetItemsinRow[row] {
                let currentStack = UIStackView()
                currentStack.axis = .horizontal
                currentStack.distribution = .fill
                currentStack.alignment = .fill

                let num = index
                for i in num..<(num + presetItems) {
                    currentStack.addArrangedSubview(views[i])
                    index += 1
                }
                self.addArrangedSubview(currentStack)
            } else {
                let currentStack = UIStackView()
                currentStack.axis = .horizontal
                currentStack.distribution = .fill
                currentStack.alignment = .fill

                let num = index
                for i in num..<(num + defaultPerRow) {
                    currentStack.addArrangedSubview(views[i])
                    index += 1
                }
                self.addArrangedSubview(currentStack)
            }

            row += 1
        }
    }
}
