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

    public static var Loading: UIControlState {
        get {
            // UIControlStateApplication maks is 0x00FF0000
            // so anything between 1 << 16 e 1 << 23 should be save
            return UIControlState(rawValue: 1 << 20);
        }
    }

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

public class LoadingButton: UIControl {

    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let spinner = UIActivityIndicatorView()
    private let backgroundImageView = UIImageView()

    private var titles = [UIControlState: String]()
    private var titleColors = [UIControlState: UIColor]()
    private var images = [UIControlState: UIImage]()
    private var backgroundImages = [UIControlState: UIImage]()

    private var contentViewCenterConstraint: NSLayoutConstraint?
    private var imageViewTitleLabelDistanceConstraint: NSLayoutConstraint?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        setUpSubviews()

        titleLabel.text = "Placeholder"
    }

    private func setUpSubviews() {

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundImageView)

        let contentView = createContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.activityIndicatorViewStyle = .White
        addSubview(spinner)

        let views = ["contentView": contentView, "spinner": spinner, "background": backgroundImageView]
        let metrics = ["marginMin": 10, "space": 5]

        let horizontalFormat = "H:|-(>=marginMin)-[spinner]-(space)-[contentView]-(>=marginMin)-|"

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

        contentViewCenterConstraint =
            NSLayoutConstraint(
                item: contentView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0)
        if let constraint = contentViewCenterConstraint {
            addConstraint(constraint)
        }


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
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
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

    override public func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {

//        print("sendAction for event: \(event)")
        super.sendAction(action, to: target, forEvent: event)
    }

    override public var state: UIControlState {
        get {
            if self.loading {
                return .Loading
            } else {
                return super.state
            }
        }
    }

    override public var enabled: Bool {
        didSet {
            updateUI()
        }
    }

    public var loading = false {
        didSet {
            enabled = !loading
        }
    }

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

//        print(highlighted)

        updateUI()
    }

    private func updateUI() {
        let defaultState = UIControlState.Normal
        let state = self.state
        let loading = self.loading

        let title: String?
        let titleIsFallback: Bool
        (title, titleIsFallback) = getValeuIn(titles, forState: state, fallbackState: defaultState, fallbackValue: nil)

        let textColor: UIColor?
        let textColorIsFallback: Bool
        (textColor, textColorIsFallback) = getValeuIn(titleColors, forState: state, fallbackState: defaultState, fallbackValue: tintColor)

        let image: UIImage?
        let imageIsFallback: Bool
        (image, imageIsFallback) = getValeuIn(images, forState: state, fallbackState: defaultState, fallbackValue: nil)

        let backgroundImage: UIImage?
        let backgroundImageIsFallback: Bool
        (backgroundImage, backgroundImageIsFallback) = getValeuIn(backgroundImages, forState: state, fallbackState: defaultState, fallbackValue: nil)


        let textAlpha: CGFloat = highlighted && titleIsFallback && textColorIsFallback ? 0.2 : 1.0;
        let imageAlpha: CGFloat = highlighted && imageIsFallback ? 0.2 : 1.0
        let backgrounImageAlpha: CGFloat = highlighted && backgroundImageIsFallback ? 0.2 : 1.0;


        if loading {
            spinner.startAnimating()
            contentViewCenterConstraint?.constant = CGRectGetWidth(spinner.frame) / 2.0
        } else {
            spinner.stopAnimating()
            contentViewCenterConstraint?.constant = 0
        }

        titleLabel.text = title
        titleLabel.textColor = textColor
        titleLabel.alpha = textAlpha
        imageView.image = image
        imageView.alpha = imageAlpha
        backgroundImageView.image = backgroundImage
        backgroundImageView.alpha = backgrounImageAlpha
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
