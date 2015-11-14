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

//private extension UIView {
//    func fadeTransition(duration: CFTimeInterval) {
//
//        let fadeIn = CABasicAnimation(keyPath: "opacity")
//        fadeIn.beginTime = 0.0
//        fadeIn.duration = duration * 0.5
//        fadeIn.fromValue = 1.0
//        fadeIn.toValue = 0.0
//
//        let transition = CATransition()
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionFade
//        transition.fillMode = kCAFillModeBackwards
//        transition.beginTime = duration * 0.2
//        transition.duration = duration
//
//        let fadeOut = CABasicAnimation(keyPath: "opacity")
//        fadeOut.beginTime = duration * 0.5
//        fadeOut.duration = duration * 0.5
//        fadeOut.fromValue = 0.0
//        fadeOut.byValue = 0.0
//        fadeOut.toValue = 1.0
//
//        let group = CAAnimationGroup()
//        group.animations = [fadeIn, fadeOut]
//        group.duration = duration
//
//        self.layer.addAnimation(group, forKey: kCATransitionFade)
//    }
//}

extension UILabel {
    private func setText(text: String?, animated: Bool) {
        let duration: NSTimeInterval = 1.0

        UIView.animateWithDuration(
            duration * 0.2,
            animations: { () -> Void in
                self.alpha = 0.0
            },
            completion: { (_) -> Void in
                self.text = text
                UIView.animateWithDuration(duration * 0.2, delay: duration * 0.8, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.alpha = 1.0
                    }, completion: nil)
        })


//        UIView.animateKeyframesWithDuration(
//            duration,
//            delay: 0,
//            options: .BeginFromCurrentState,
//            animations: { () -> Void in
//                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.4, animations: { () -> Void in
//                    self.alpha = 0.0
//                })
//                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0, animations: { () -> Void in
//                    UIView.performWithoutAnimation({ () -> Void in
//                        self.text = text
//                    })
//                })
//                UIView.addKeyframeWithRelativeStartTime(0.6, relativeDuration: 0.4, animations: { () -> Void in
//                    self.alpha = 1.0
//                })
//            },
//            completion: nil)
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

    public var loading = false

    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let spinner = UIActivityIndicatorView()

    private var titles = [UIControlState: String]()
    private var images = [UIControlState: UIImage]()

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
        userInteractionEnabled = true
    }

    private func setUpSubviews() {

        let contentView = createContentView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)

        let views = ["contentView": contentView, "spinner": spinner]
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
                "V:|-(>=marginMin)-[contentView]-(>=marginMin)-|",
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
    }

    private func createContentView() -> UIView {
        let contentView = UIView();

        setUpTitleLabel()
        contentView.addSubview(titleLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        let views = ["titleLabel": titleLabel, "imageView": imageView]

        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[titleLabel]|",
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

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Center
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

    override public func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {

        print("sendAction for event: \(event)")
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

    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        updateWithTouch(touch, ended: false)
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }

    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        updateWithTouch(touch, ended: false)
        return super.continueTrackingWithTouch(touch, withEvent: event)
    }

    override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        updateWithTouch(touch!, ended: true)
        return super.endTrackingWithTouch(touch, withEvent: event)
    }

    private func updateWithTouch(touch: UITouch, ended: Bool) {
        let point = touch.locationInView(self)
        highlighted = ended ? false : pointInside(point, withEvent: nil)

        updateUI()
    }

    private func updateUI() {

        let textColor = tintColor
        let text = titles[state] ?? titles[.Normal]

        let image = images[state] ?? images[.Normal]

        if titleLabel.text != text {
//            titleLabel.fadeTransition(2)
            titleLabel.text = text
            titleLabel.setText(text, animated: true)
        }
        titleLabel.textColor = textColor

        imageView.image = image
    }
}
