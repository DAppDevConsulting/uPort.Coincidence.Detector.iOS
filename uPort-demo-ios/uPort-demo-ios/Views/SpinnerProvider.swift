//
//  SpinnerProvider.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/18/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit

struct SpinnerConstants {
    static let Alpha: CGFloat = 0.6
    static let CornerRadius: CGFloat = 5
    static let Delay: Double = 0.0
}

class SpinnerProvider: NSObject {
    private var shouldShowSpinner: Bool = true
    private var spinner : UIActivityIndicatorView!
    private var spinnerBackgroundView : UIView!
    
    override init() {
        super.init()
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinnerBackgroundView = UIView()
    }
    
    func startSpinner() {
        shouldShowSpinner = true
        perform(#selector(startSpinnerAnimation), with: nil, afterDelay: SpinnerConstants.Delay)
        stopSpinnerIfNoNetwork()
    }
    
    func stopSpinner() {
        shouldShowSpinner = false
        stopSpinnerAnimation()
    }
    
    private func stopSpinnerIfNoNetwork() {
        Reachability.isConnectedToNetwork(completion: { [weak self] result in
            if !result {
                self?.stopSpinner()
            }
        })
    }
    
    @objc private func startSpinnerAnimation() {
        if shouldShowSpinner {
            if !spinner.isAnimating {
                spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                let window = UIApplication.shared.keyWindow
                spinnerBackgroundView.frame = (window?.frame)!
                spinnerBackgroundView.center = CGPoint(x: window!.frame.size.width/2, y: window!.frame.size.height/2)
                spinner.center = CGPoint(x: spinnerBackgroundView!.frame.size.width/2, y: spinnerBackgroundView!.frame.size.height/2)
                spinnerBackgroundView.layer.cornerRadius = SpinnerConstants.CornerRadius
                spinnerBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(SpinnerConstants.Alpha)
                
                spinnerBackgroundView.addSubview(spinner)
                window?.addSubview(spinnerBackgroundView)
                spinner.startAnimating()
            }
        }
    }
    
    private func stopSpinnerAnimation() {
        if spinner.isAnimating {
            spinner.stopAnimating()
            spinnerBackgroundView.removeFromSuperview()
        }
    }
}
