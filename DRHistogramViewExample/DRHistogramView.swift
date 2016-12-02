//
//  DRHistogramView.swift
//  DRHistogramViewExample
//
//  Created by xqzh on 16/11/30.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

class DRHistogramView: UIView {
  
  var histogram:CAShapeLayer!
  var path:CGPath!
  var proportion:CGFloat! {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  override func draw(_ rect: CGRect) {
    histogram = CAShapeLayer()
    histogram.frame = self.bounds
    histogram.fillColor = UIColor.red.cgColor
    histogram.strokeColor = UIColor.red.cgColor
    
    if proportion<=200 {
      // 记录原先的path
      let oldPath = path
      // 生成新的path
      path = CGPath(roundedRect: CGRect(x: 0, y: 0, width: proportion, height: 50), cornerWidth: 5, cornerHeight: 5, transform: nil)
      histogram.path = path
      // 加CABasicAnimation动画
      let animation = CABasicAnimation(keyPath: "path")
      animation.fromValue = oldPath
      animation.toValue = path
      animation.duration = 0
      histogram.add(animation, forKey: "path")
    
    }
    
    
    self.layer.addSublayer(histogram)
  }

}
