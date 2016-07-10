//
//  MaterialView+Extension.swift
//  EventBuilder
//
//  Created by Buu Bui on 7/9/16.
//  Copyright © 2016 Buu Bui. All rights reserved.
//

import UIKit
import Material


extension MaterialView {
  var maskTag: Int { return 19841 }
  var indicatorTag: Int { return 19843 }

  func loadingView() -> UIActivityIndicatorView {
    if let maskView = viewWithTag(maskTag), indicatorView = maskView.viewWithTag(indicatorTag) as? UIActivityIndicatorView {
      return indicatorView
    }
    let maskView = UIView(frame: bounds)
    maskView.tag = maskTag
    maskView.backgroundColor = UIColor.flatWhiteColor()
    maskView.alpha = 0.8
    maskView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    maskView.hidden = true
    addSubview(maskView)

    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    indicatorView.tag = indicatorTag
    indicatorView.sizeToFit()
    indicatorView.center = CGPoint(x: width/2, y: height/2)
    indicatorView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]
    indicatorView.hidesWhenStopped = true
    maskView.addSubview(indicatorView)

    return indicatorView
  }

  func setImageFromUrl(url: NSURL, placeHolder: UIImage?, errorImage: UIImage?) {
    image = placeHolder
    let indicatorView = loadingView()
    indicatorView.superview?.hidden = false
    indicatorView.startAnimating()
    UIImage.contentsOfURL(url) { (image, error) in
      indicatorView.superview?.hidden = true
      indicatorView.stopAnimating()
      guard let remoteImage = image else {
        if let errorImage = errorImage {
          self.image = errorImage
        }
        return
      }
      self.image = remoteImage
    }
  }
}
