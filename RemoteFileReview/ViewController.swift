//
//  ViewController.swift
//  RemoteFileReview
//
//  Created by hjliu on 2016/2/15.
//  Copyright © 2016年 hjliu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// UI
    private let button = UIButton()
    private let progressBar = UIProgressView()
    
    /// DATA
    private let url = "https://www.adobe.com/enterprise/accessibility/pdfs/acro6_pg_ue.pdf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        button.setTitle("下載", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blueColor()
        button.addTarget(self, action: "Tap", forControlEvents: UIControlEvents.TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        progressBar.hidden = true
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(progressBar)
        
        let views = [
            "super" : self.view,
            "button" : button,
            "progressBar" : progressBar,
            ] as [String:AnyObject]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[super]-(<=0)-[button(200)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[super]-(<=0)-[button(100)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[progressBar]|", options: [], metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[progressBar(5)]|", options: [], metrics: nil, views: views))
    }
    
    func Tap(){
        
        progressBar.hidden = false
        
        openFile(url) { progress in
            
            self.progressBar.progress = progress
            
            if progress == 1{
                self.progressBar.hidden = true
            }
        }
    }
}

