//
//  OldThings.swift
//  
//
//  Created by Diogo Tridapalli on 11/20/15.
//
//

import UIKit

private extension UIView {
    func fadeTransition(duration: CFTimeInterval) {

        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.beginTime = 0.0
        fadeIn.duration = duration * 0.5
        fadeIn.fromValue = 1.0
        fadeIn.toValue = 0.0

        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.fillMode = kCAFillModeBackwards
        transition.beginTime = duration * 0.2
        transition.duration = duration

        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.beginTime = duration * 0.5
        fadeOut.duration = duration * 0.5
        fadeOut.fromValue = 0.0
        fadeOut.byValue = 0.0
        fadeOut.toValue = 1.0

        let group = CAAnimationGroup()
        group.animations = [fadeIn, fadeOut]
        group.duration = duration

        self.layer.addAnimation(group, forKey: kCATransitionFade)
    }
}

extension UILabel {
    private func setTextAnimated(text: String?) {
        let duration: NSTimeInterval = 0.3

        // Could be cleaner
        UIView.animateWithDuration(
            duration * 0.4,
            delay: 0.0,
            options: .BeginFromCurrentState,
            animations: { () -> Void in
                self.alpha = 0.0
            },
            completion: { (_) -> Void in

                self.text = text

                UIView.animateWithDuration(
                    duration * 0.4,
                    delay: duration * 0.2,
                    options: .BeginFromCurrentState,
                    animations: { () -> Void in
                        self.alpha = 1.0
                    }, completion: nil)
        })
    }
}

