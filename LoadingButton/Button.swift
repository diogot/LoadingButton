//
//  LoadingButton.swift
//  LoadingButton
//
//  Created by Diogo Tridapalli on 12/11/15.
//  Copyright © 2015 Diogo Tridapalli. All rights reserved.
//

import UIKit

extension UIColor {
    func image() -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        setFill()
        UIRectFill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

extension UIControlState: Hashable {
    public var hashValue: Int {
        get {
            return Int(rawValue)
        }
    }
}

extension NSLayoutFormatOptions {
    static var None: NSLayoutFormatOptions {
        get {
            return NSLayoutFormatOptions(rawValue: 0)
        }
    }
}

public class Button: UIControl {

    public let titleLabel = UILabel()
    public let imageView = UIImageView()
    private let backgroundImageView = UIImageView()

    private var titles = [UIControlState: String]()
    private var titleColors = [UIControlState: UIColor]()
    private var images = [UIControlState: UIImage]()
    private var backgroundImages = [UIControlState: UIImage]()
    private let highlightedAlpha: CGFloat = 0.2
    private let normalAlpha: CGFloat = 1.0

    private var imageViewTitleLabelDistanceConstraint: NSLayoutConstraint?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    // MARK: - SetUp

    private func setUp() {
        setUpSubviews()
    }

    private func setUpSubviews() {

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)

        let contentView = createContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        let views = ["contentView": contentView, "background": backgroundImageView]
        let metrics: [String: AnyObject]? = nil

        let horizontalFormat = "H:|-(>=0)-[contentView]-(>=0)-|"

        addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                horizontalFormat,
                options: .AlignAllCenterY,
                metrics: metrics,
                views: views))

        addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[contentView]|",
                options: .None,
                metrics: metrics,
                views: views))

        addConstraint(
            NSLayoutConstraint(
                item: contentView,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0))

        addConstraint(
            NSLayoutConstraint(
                item: contentView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0))

        // Background

        addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[background]|",
                options: .None,
                metrics: metrics,
                views: views))

        addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[background]|",
                options: .None,
                metrics: metrics,
                views: views))
    }

    private func createContentView() -> UIView {
        let contentView = UIView();
        contentView.userInteractionEnabled = false

        setUpTitleLabel()
        contentView.addSubview(titleLabel)

        setUpImageView()
        contentView.addSubview(imageView)

        let views = ["titleLabel": titleLabel, "imageView": imageView]

        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-(>=0)-[titleLabel]-(>=0)-|",
                options: .None,
                metrics: nil,
                views: views))

        contentView.addConstraint(
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0))

        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[imageView]|",
                options: .None,
                metrics: nil,
                views: views))

        contentView.addConstraint(
            NSLayoutConstraint(
                item: imageView,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0))

        contentView.addConstraint(
            NSLayoutConstraint(
                item: imageView,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .Leading,
                multiplier: 1,
                constant: 0))

        imageViewTitleLabelDistanceConstraint =
            NSLayoutConstraint(
                item: imageView,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: titleLabel,
                attribute: .Leading,
                multiplier: 1,
                constant: 0)
        if let constraint = imageViewTitleLabelDistanceConstraint {
            contentView.addConstraint(constraint)
        }

        contentView.addConstraint(
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: contentView,
                attribute: .Trailing,
                multiplier: 1,
                constant: 0))

        return contentView
    }

    private func setUpTitleLabel() {
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        titleLabel.textAlignment = .Left
        titleLabel.contentMode = .ScaleToFill
        titleLabel.userInteractionEnabled = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.opaque = false
        titleLabel.backgroundColor = nil
    }

    private func setUpImageView()
    {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .Center
    }

    // MARK: - Title

    public func titleForState(state: UIControlState) -> String? {
        return titles[state]
    }

    public func setTitle(title: String?, forState state: UIControlState) {
        if let title = title {
            titles[state] = title
        } else {
            titles.removeValueForKey(state)
        }

        updateUI()
    }

    public func titleColorForState(state: UIControlState) -> UIColor? {
        return titleColors[state]
    }

    public func setTitleColor(color: UIColor?, forState state: UIControlState) {
        if let color = color {
            titleColors[state] = color
        } else {
            titleColors.removeValueForKey(state)
        }

        updateUI()
    }

    // MARK: - Image

    public func imageForState(state: UIControlState) -> UIImage? {
        return images[state]
    }

    public func setImage(image: UIImage?, forState state: UIControlState) {
        if let image = image {
            images[state] = image
        } else {
            images.removeValueForKey(state)
        }

        updateUI()
    }

    // MARK: - Background

    public func backgroundImageForState(state: UIControlState) -> UIImage? {
        return backgroundImages[state]
    }

    public func setBackgroundImage(image: UIImage?, forState state: UIControlState) {
        if let image = image {
            backgroundImages[state] = image
        } else {
            backgroundImages.removeValueForKey(state)
        }

        updateUI()
    }

    // MARK: - Touch tracking

    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let track = super.beginTrackingWithTouch(touch, withEvent: event)
        updateWithTouch(touch)
        return track
    }

    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let track = super.continueTrackingWithTouch(touch, withEvent: event)
        updateWithTouch(touch)
        return track
    }

    override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        if let touch = touch {
            updateWithTouch(touch)
        }
    }

    private func updateWithTouch(touch: UITouch) {
        let point = touch.locationInView(self)
        let ended = touch.phase == .Ended

        // Workaround because touchInside inside is not true on beginTrackingWithTouch
        let insideTouch = pointInside(point, withEvent: nil)

        highlighted = ended ? false : insideTouch || touchInside

        updateUI()
    }

    // MARK: - UI update

    private func updateUI() {
        let defaultState = UIControlState.Normal
        let state = self.state

        let title: String?
        let titleIsFallback: Bool
        (title, titleIsFallback) = getValeuIn(titles, forState: state, fallbackState: defaultState, fallbackValue: nil)

        let textColor: UIColor?
        let textColorIsFallback: Bool
        (textColor, textColorIsFallback) = getValeuIn(titleColors, forState: state, fallbackState: defaultState, fallbackValue: enabled ? tintColor : UIColor(white: 0.4, alpha: 0.35))

        let image: UIImage?
        let imageIsFallback: Bool
        (image, imageIsFallback) = getValeuIn(images, forState: state, fallbackState: defaultState, fallbackValue: nil)

        let backgroundImage: UIImage?
        let backgroundImageIsFallback: Bool
        (backgroundImage, backgroundImageIsFallback) = getValeuIn(backgroundImages, forState: state, fallbackState: defaultState, fallbackValue: nil)

        let textAlpha: CGFloat = highlighted && titleIsFallback && textColorIsFallback ? highlightedAlpha : normalAlpha
        let imageAlpha: CGFloat = highlighted && imageIsFallback ? highlightedAlpha : normalAlpha
        let backgroundImageAlpha: CGFloat = highlighted && backgroundImageIsFallback ? highlightedAlpha : normalAlpha

        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.alpha = textAlpha
        imageView.image = image
        imageView.alpha = imageAlpha
        backgroundImageView.image = backgroundImage
        backgroundImageView.alpha = backgroundImageAlpha
    }

    override public func tintColorDidChange() {
        updateUI()
    }

    override public var enabled: Bool {
        didSet {
            updateUI()
        }
    }

    private func getValeuIn<T>(collection: [UIControlState: T], forState state: UIControlState, fallbackState defaultState: UIControlState, fallbackValue: T?) -> (T?, Bool) {
        let thing: T?
        let thingIsFallback: Bool

        if let aThing = collection[state] {
            thing = aThing
            thingIsFallback = false
        } else {
            thing = collection[defaultState] ?? fallbackValue
            thingIsFallback = true
        }

        return (thing, thingIsFallback)
    }
}
