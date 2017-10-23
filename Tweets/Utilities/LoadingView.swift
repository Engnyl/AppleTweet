//
//  LoadingView.swift
//  Tweets
//
//  Created by Engin Yıldız on 23/10/2017.
//  Copyright © 2017 Engin Yıldız. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    class func startSpinner() {
        DispatchQueue.main.async(execute: {
            let window: UIWindow = UIApplication.shared.keyWindow!
            
            let spinnerViewWidth: CGFloat = UtilityMethods.isDeviceiPad() ? UIScreen.main.bounds.size.width * 0.4 : UIScreen.main.bounds.size.width * 0.6
            let spinnerViewHeight: CGFloat = UtilityMethods.isDeviceiPad() ? 130 : 116
            let spinnerViewVerticalMargin: CGFloat = 8
            
            let containerView: UIView = UIView(frame: window.frame)
            containerView.tag = 1001
            containerView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
            
            let mainView: UIView = UIView(frame: CGRect(x: (window.frame.size.width - spinnerViewWidth) / 2, y: (window.frame.size.height - spinnerViewHeight) / 2, width: spinnerViewWidth, height: spinnerViewHeight))
            mainView.tag = 1002
            mainView.layer.cornerRadius = 15
            mainView.backgroundColor = UIColor(red: 249.0/255.0, green: 248.0/255.0, blue: 244.0/255.0, alpha: 0.9)
            
            let topView: UIView = UIView(frame: CGRect(x: 0, y: 8, width: mainView.frame.size.width, height: (mainView.frame.size.height * 0.50) - spinnerViewVerticalMargin))
            topView.tag = 1003
            let bottomView: UIView = UIView(frame: CGRect(x: 0, y: topView.frame.origin.y + topView.frame.size.height, width: mainView.frame.size.width, height: (mainView.frame.size.height * 0.50) - spinnerViewVerticalMargin))
            bottomView.tag = 1004
            
            let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
            activityIndicatorView.tag = 1005
            activityIndicatorView.activityIndicatorViewStyle = .whiteLarge
            activityIndicatorView.color = UIColor.darkGray
            topView.addSubview(activityIndicatorView)
            activityIndicatorView.center = topView.center
            
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: bottomView.frame.size.width, height: bottomView.frame.size.height))
            label.tag = 1006
            label.font = UIFont(name: "HelveticaNeu", size: UtilityMethods.isDeviceiPad() ? 22 : 18)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            label.text = "Loading..."
            bottomView.addSubview(label)
            
            mainView.addSubview(topView)
            mainView.addSubview(bottomView)
            containerView.addSubview(mainView)
            window.addSubview(containerView)
            
            activityIndicatorView.startAnimating()
        })
    }
    
    class func stopSpinner() {
        DispatchQueue.main.async(execute: {
            let window: UIWindow = UIApplication.shared.keyWindow!
            let containerView: UIView? = window.viewWithTag(1001)
            let mainView: UIView? = window.viewWithTag(1002)
            let topView: UIView? = window.viewWithTag(1003)
            let bottomView: UIView? = window.viewWithTag(1004)
            let activityIndicatorView: UIActivityIndicatorView? = window.viewWithTag(1005) as? UIActivityIndicatorView
            let label: UILabel? = window.viewWithTag(1006) as? UILabel
            
            activityIndicatorView?.removeFromSuperview()
            label?.removeFromSuperview()
            topView?.removeFromSuperview()
            bottomView?.removeFromSuperview()
            mainView?.removeFromSuperview()
            containerView?.removeFromSuperview()
        })
    }
}
