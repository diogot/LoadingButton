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

        let aButton = UIButton(type: .System)
        aButton.frame = CGRect(x: 30, y: 150, width: 200, height: 50)
        view.addSubview(aButton)

        button.setTitle("Normal", forState: .Normal)
        aButton.setTitle("Normal", forState: .Normal)

//        button.setTitle("Highlighted", forState: .Highlighted)
//        aButton.setTitle("Highlighted", forState: .Highlighted)

        button.setTitle("Loading", forState: .Loading)

//        button.setTitle("Disabled", forState: .Disabled)
//        aButton.setTitle("Disabled", forState: .Disabled)

//        button.setTitleColor(UIColor.greenColor(), forState: .Normal)
//        aButton.setTitleColor(UIColor.greenColor(), forState: .Normal)

//        button.setTitleColor(UIColor.greenColor(), forState: .Disabled)
//        aButton.setTitleColor(UIColor.greenColor(), forState: .Disabled)


        button.setImage(UIImage(named: "invariante"), forState: .Normal)
        aButton.setImage(UIImage(named: "invariante")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
//        button.setImage(UIImage(named: "invariante"), forState: .Highlighted)
//        aButton.setImage(UIImage(named: "invariante")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Highlighted)

        button.setBackgroundImage(UIColor.redColor().image(), forState: .Normal)
        aButton.setBackgroundImage(UIColor.redColor().image(), forState: .Normal)
//        button.setBackgroundImage(UIColor.greenColor().image(), forState: .Highlighted)
//        aButton.setBackgroundImage(UIColor.greenColor().image(), forState: .Highlighted)

//        button.enabled = false
//        aButton.enabled = false


        button.addTarget(self, action: "touchUpInside:", forControlEvents: .TouchUpInside)
        aButton.addTarget(self, action: "touchUpInside:", forControlEvents: .TouchUpInside)
    }


    func touchUpInside(aSender: AnyObject?) {
//        if let sender = aSender {
//            if sender.isKindOfClass(LoadingButton) {
//                let button = sender as! LoadingButton
//                button.loading = !button.loading
//            }
//        }

        print("TouchUpInside \(aSender)")
    }

}

