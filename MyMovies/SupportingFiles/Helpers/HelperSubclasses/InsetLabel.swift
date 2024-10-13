//
//  InsetLabel.swift
//  MyMovies
//
//  Created by Andrei Shpartou on 13/10/2024.
//

import UIKit

final class InsetLabel: UILabel {

    var textInsets = UIEdgeInsets.zero {
        didSet {
            // Redraw the label when insets are changed
            setNeedsDisplay()
        }
    }

    // Override the drawText method to apply insets
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    // Override intrinsicContentSize to account for insets
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let width = originalContentSize.width + textInsets.left + textInsets.right
        let height = originalContentSize.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: height)
    }
}

extension InsetLabel {
    static func createInsetLabel(
        font: UIFont,
        numberOfLines: Int = 1,
        textAlignment: NSTextAlignment = .left,
        textColor: UIColor? = nil,
        text: String? = nil,
        borderWidth: CGFloat? = nil,
        borderColor: CGColor? = nil
    ) -> InsetLabel {
        let label = InsetLabel()
        label.font = font
        label.numberOfLines = numberOfLines
        label.textAlignment = textAlignment
        label.text = text
        if let textColor = textColor {
            label.textColor = textColor
        }
        if let borderWidth = borderWidth {
            label.layer.borderWidth = borderWidth
        }
        if let borderColor = borderColor {
            label.layer.borderColor = borderColor
        }

        return label
    }
}
