//
//  ViewController.swift
//  LoadingButton
//
//  Created by Diogo Tridapalli on 12/11/15.
//  Copyright © 2015 Diogo Tridapalli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = LoadingButton(frame: CGRect(x: 30, y: 50, width: 200, height: 50))
        view.addSubview(button)

        button.setTitle("Normal", forState: .Normal)
        button.setTitle("Highlighted", forState: .Highlighted)
        button.setTitle("Loading", forState: .Loading)
        button.setTitle("Disabled", forState: .Disabled)

//        button.backgroundColor = UIColor.redColor()

        let aButton = UIButton(type: .System)
        aButton.frame = CGRect(x: 30, y: 150, width: 200, height: 50)
        view.addSubview(aButton)
        aButton.setTitle("Normal", forState: .Normal)
        aButton.setTitle("Highlighted", forState: .Highlighted)
        aButton.setTitle("Disabled", forState: .Disabled)

        aButton.adjustsImageWhenHighlighted = false
        aButton.setTitleColor(aButton.tintColor, forState: .Highlighted)
//        aButton.backgroundColor = aButton.tintColor
//        aButton.setBackgroundImage(UIColor.blackColor().image(), forState: .Normal)
//        aButton.setBackgroundImage(UIColor.blackColor().image(), forState: .Highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

