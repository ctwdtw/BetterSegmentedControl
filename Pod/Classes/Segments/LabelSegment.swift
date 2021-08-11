//
//  LabelSegment.swift
//  BetterSegmentedControl
//
//  Created by George Marmaridis on 08/10/2017.
//

#if canImport(UIKit)

import UIKit

open class LabelSegment: BetterSegmentedControlSegment {
    // MARK: Constants
    private struct DefaultValues {
        static let normalBackgroundColor: UIColor = .clear
        static let normalTextColor: UIColor = .black
        static let normalFont: UIFont = .systemFont(ofSize: 13)
        static var normalAttributes: ((UIFont?, UIColor?) -> [NSAttributedString.Key: Any]) = { (normalFont, normalTextColor) in
            var attrs = [NSAttributedString.Key: Any]()
            attrs[NSAttributedString.Key.font] = normalFont == nil ? DefaultValues.normalFont : normalFont!
            attrs[NSAttributedString.Key.foregroundColor] =  normalTextColor == nil ? DefaultValues.normalTextColor : normalTextColor!
            return attrs
        }
        
        static let selectedBackgroundColor: UIColor = .clear
        static let selectedTextColor: UIColor = .black
        static let selectedFont: UIFont = .systemFont(ofSize: 13, weight: .medium)
        static var selectedAttributes: ((UIFont?, UIColor?) -> [NSAttributedString.Key: Any]) = { (selectedFont, selectedTextColor) in
            var attrs = [NSAttributedString.Key: Any]()
            attrs[NSAttributedString.Key.font] = selectedFont == nil ? DefaultValues.selectedFont : selectedFont!
            attrs[NSAttributedString.Key.foregroundColor] = selectedTextColor == nil ? DefaultValues.selectedTextColor : selectedTextColor!
            return attrs
        }
        
        static let zeroPaddings = Paddings(top: 0, right: 0, bottom: 0, left: 0)
    }
    
    public struct Paddings {
        public let top: CGFloat
        public let right: CGFloat
        public let bottom: CGFloat
        public let left: CGFloat
        
        public init(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
            self.top = top
            self.right = right
            self.bottom = bottom
            self.left = left
        }
    }
    
    // MARK: Properties
    public let text: String?
    
    public let normalFont: UIFont
    public let normalTextColor: UIColor
    public let normalBackgroundColor: UIColor
    public let normalAttributes: [NSAttributedString.Key: Any]
    
    public let selectedFont: UIFont
    public let selectedTextColor: UIColor
    public let selectedBackgroundColor: UIColor
    public let selectedAttributes: [NSAttributedString.Key: Any]
    
    private let numberOfLines: Int
    private let accessibilityIdentifier: String?
    
    private let paddings: Paddings
    
    private let minimumScaleFactor: CGFloat?
    
    // MARK: Lifecycle
    public init(text: String? = nil,
                paddings: Paddings? = nil,
                numberOfLines: Int = 1,
                minimumScaleFactor: CGFloat? = nil,
                normalBackgroundColor: UIColor? = nil,
                normalFont: UIFont? = nil,
                normalTextColor: UIColor? = nil,
                normalAttributes: [NSAttributedString.Key: Any]? = nil,
                selectedBackgroundColor: UIColor? = nil,
                selectedFont: UIFont? = nil,
                selectedTextColor: UIColor? = nil,
                selectedAttributes: [NSAttributedString.Key: Any]? = nil,
                accessibilityIdentifier: String? = nil) {
        self.text = text
        self.paddings = paddings ?? DefaultValues.zeroPaddings
        self.numberOfLines = numberOfLines
        self.minimumScaleFactor = minimumScaleFactor
        self.normalBackgroundColor = normalBackgroundColor ?? DefaultValues.normalBackgroundColor
        self.normalFont = normalFont ?? DefaultValues.normalFont
        self.normalTextColor = normalTextColor ?? DefaultValues.normalTextColor
        self.normalAttributes = normalAttributes ?? DefaultValues.normalAttributes(normalFont, normalTextColor)
        self.selectedBackgroundColor = selectedBackgroundColor ?? DefaultValues.selectedBackgroundColor
        self.selectedFont = selectedFont ?? DefaultValues.selectedFont
        self.selectedTextColor = selectedTextColor ?? DefaultValues.selectedTextColor
        self.selectedAttributes = selectedAttributes ?? DefaultValues.selectedAttributes(selectedFont, selectedTextColor)
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
    // MARK: BetterSegmentedControlSegment
    public var intrinsicContentSize: CGSize? {
        selectedView.intrinsicContentSize
    }
    
    public lazy var normalView: UIView = {
        createLabel(withText: text,
                    backgroundColor: normalBackgroundColor,
                    font: normalFont,
                    textColor: normalTextColor,
                    attributes: normalAttributes,
                    accessibilityIdentifier: accessibilityIdentifier)
    }()
    public lazy var selectedView: UIView = {
        createLabel(withText: text,
                    backgroundColor: selectedBackgroundColor,
                    font: selectedFont,
                    textColor: selectedTextColor,
                    attributes: selectedAttributes,
                    accessibilityIdentifier: accessibilityIdentifier)
    }()
    open func createLabel(withText text: String?,
                          backgroundColor: UIColor,
                          font: UIFont,
                          textColor: UIColor,
                          attributes: [NSAttributedString.Key: Any],
                          accessibilityIdentifier: String?) -> UILabel {
        
        let label = PaddingLabel()
        label.paddingTop = paddings.top
        label.paddingRight = paddings.right
        label.paddingBottom = paddings.bottom
        label.paddingLeft = paddings.left
        label.numberOfLines = numberOfLines
        
        if let f = minimumScaleFactor {
            label.minimumScaleFactor = f
            label.adjustsFontSizeToFitWidth = true
        }
        
        label.text = text
        label.backgroundColor = backgroundColor
        label.font = font
        label.textColor = textColor
        label.attributedText = text == nil ? nil : NSAttributedString(string: text!, attributes: attributes)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.accessibilityIdentifier = accessibilityIdentifier
        return label
    }
}

public extension LabelSegment {
    class func segments(withTitles titles: [String],
                        paddings: Paddings? = nil,
                        numberOfLines: Int = 1,
                        minimumScaleFactor: CGFloat? = nil,
                        normalBackgroundColor: UIColor? = nil,
                        normalFont: UIFont? = nil,
                        normalTextColor: UIColor? = nil,
                        normalAttributes: [NSAttributedString.Key: Any]? = nil,
                        selectedBackgroundColor: UIColor? = nil,
                        selectedFont: UIFont? = nil,
                        selectedTextColor: UIColor? = nil,
                        selectedAttributes: [NSAttributedString.Key: Any]? = nil) -> [BetterSegmentedControlSegment] {
        titles.map {
            LabelSegment(text: $0,
                         paddings: paddings,
                         numberOfLines: numberOfLines,
                         minimumScaleFactor: minimumScaleFactor,
                         normalBackgroundColor: normalBackgroundColor,
                         normalFont: normalFont,
                         normalTextColor: normalTextColor,
                         normalAttributes: normalAttributes,
                         selectedBackgroundColor: selectedBackgroundColor,
                         selectedFont: selectedFont,
                         selectedTextColor: selectedTextColor,
                         selectedAttributes: selectedAttributes)
        }
    }
}

extension LabelSegment {
    @IBDesignable
    class PaddingLabel: UILabel {
        var textEdgeInsets = UIEdgeInsets.zero {
            didSet { invalidateIntrinsicContentSize() }
        }
        
        open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
            let insetRect = bounds.inset(by: textEdgeInsets)
            let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
            let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
            return textRect.inset(by: invertedInsets)
        }
        
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: textEdgeInsets))
        }
        
        @IBInspectable
        var paddingLeft: CGFloat {
            set { textEdgeInsets.left = newValue }
            get { return textEdgeInsets.left }
        }
        
        @IBInspectable
        var paddingRight: CGFloat {
            set { textEdgeInsets.right = newValue }
            get { return textEdgeInsets.right }
        }
        
        @IBInspectable
        var paddingTop: CGFloat {
            set { textEdgeInsets.top = newValue }
            get { return textEdgeInsets.top }
        }
        
        @IBInspectable
        var paddingBottom: CGFloat {
            set { textEdgeInsets.bottom = newValue }
            get { return textEdgeInsets.bottom }
        }
    }
}

#endif
