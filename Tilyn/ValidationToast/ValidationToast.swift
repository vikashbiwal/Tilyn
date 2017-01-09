//
//  ValidationToast.swift
//  manup
//
//  Created by Tom Swindell on 07/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import UIKit

class ValidationToast: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var animatingView: UIView!
    
    // MARK: - Initialisers
    class func instanceWithMessageFromNib(_ message: String, inView view: UIView, withColor color: UIColor, automaticallyAnimateIn shouldAnimate: Bool) -> ValidationToast {
        let toast = UINib(nibName: "ValidationToast", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ValidationToast
        toast.animatingViewBottomConstraint.constant = 20
        toast.layoutIfNeeded()
        toast.setToastMessage(message)
        toast.animatingView.backgroundColor = color
        view.addSubview(toast)
        var f = view.frame
        f.size.height = 20
        f.origin = CGPoint.zero
        toast.frame = f
        if shouldAnimate {
            toast.animateIn(0.2, delay: 0.0, completion: { () -> () in
                toast.animateOut(0.2, delay: 1.5, completion: { () -> () in
                    toast.removeFromSuperview()
                })
            })
        }
        return toast
    }
    
    // This will show alert message on status bar.
    class func showStatusMessage(_ message: String, inView view: UIView? = nil, withColor color: UIColor = UIColor.red) -> ValidationToast {
        let toast = UINib(nibName: "ValidationToast", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ValidationToast
        toast.animatingViewBottomConstraint.constant = 20
        toast.layoutIfNeeded()
        toast.setToastMessage(message)
        toast.animatingView.backgroundColor = color
        var f = CGRect.zero
        if let vw = view {
            vw.window!.addSubview(toast)
            f = vw.frame
        } else {
            _appDelegator.window?.addSubview(toast)
            f = UIScreen.main.bounds
        }
        f.size.height = 20
        f.origin = CGPoint.zero
        toast.frame = f
        toast.animateIn(0.2, delay: 0.2, completion: { () -> () in
            toast.animateOut(0.2, delay: 1.5, completion: { () -> () in
                toast.removeFromSuperview()
            })
        })
        return toast
    }
    
    class func showBarMessage(_ message: String, title: String, inView view: UIView?, withColor color: UIColor = UIColor.white) -> ValidationToast {
        let toast = UINib(nibName: "ValidationToastBar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ValidationToast
        toast.animatingViewBottomConstraint.constant = 44
        toast.layoutIfNeeded()
        toast.setToastMessage(message)
        toast.setToastTitle(title)
        toast.animatingView.backgroundColor = color
        var f = CGRect.zero
        if let vw = view {
            vw.window!.addSubview(toast)
            f = vw.frame
        } else {
            _appDelegator.window?.addSubview(toast)
            f = UIScreen.main.bounds
        }
//        var f = view.frame
        f.size.height = 64
        f.origin = CGPoint.zero
        toast.frame = f
        toast.animateIn(0.2, delay: 0.5, completion: { () -> () in
            toast.animateOut(0.2, delay: 2.0, completion: { () -> () in
                toast.removeFromSuperview()
            })
        })
        return toast
    }
    
    // MARK: - Toast Functions
    fileprivate func setToastMessage(_ message: String) {
        let font = UIFont(name: "Avenir-Book", size: (14.0 * _widthRatio))!
        let color = UIColor.white
        let mutableString = NSMutableAttributedString(string: message)
        let range = NSMakeRange(0, message.characters.count)
        mutableString.addAttribute(NSFontAttributeName, value: font, range: range)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        messageLabel.attributedText = mutableString
    }
    
    fileprivate func setToastTitle(_ message: String) {
        let font = UIFont(name: "Avenir-Book", size: 15.0)!
        let color = UIColor.red
        let mutableString = NSMutableAttributedString(string: message)
        let range = NSMakeRange(0, message.characters.count)
        mutableString.addAttribute(NSFontAttributeName, value: font, range: range)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        titleLabel.attributedText = mutableString
    }
    
    func animateIn(_ duration: TimeInterval, delay: TimeInterval, completion: (() -> ())?) {
        animatingViewBottomConstraint.constant = 0
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }) { (completed) -> Void in
                completion?()
        }
    }
    
    func animateOut(_ duration: TimeInterval, delay: TimeInterval, completion: (() -> ())?) {
        animatingViewBottomConstraint.constant = 44
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }) { (completed) -> Void in
                completion?()
        }
    }
    
}

func ShowToastMessage(title: String, message: String) {
     _ = ValidationToast.showBarMessage(message, title: title, inView: nil, withColor: UIColor.green)
}

func ShowToastErrorMessage(_ title: String, message: String) {
    _ = ValidationToast.showBarMessage(message, title: title, inView: nil, withColor: UIColor.red)
}

