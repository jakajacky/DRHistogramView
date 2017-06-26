//
//  BgProgressViewCell.swift
//  DRHistogramViewExample
//
//  Created by XiaoQiang on 2017/6/23.
//  Copyright © 2017年 xqzh. All rights reserved.
//

import UIKit

class BgProgressViewCell: UITableViewCell {
  var iconView   = UIImageView()
  var titleLable = UILabel()
  var descriptionLabel = UILabel()
  
  var bgProgressLayer:CAShapeLayer! // 进度条
  var bgGradientLayer:CAGradientLayer! // 渐变色
  
  var color:CGColor! {
    didSet {
      if color == UIColor(red: 50/255.0, green: 213/255.0, blue: 80/255.0, alpha: 0.7).cgColor {
        bgGradientLayer.colors = [UIColor.white.cgColor,UIColor(red: 50/255.0, green: 242/255.0, blue: 80/255.0, alpha: 0.7).cgColor,color]
      }
      else {
        bgGradientLayer.colors = [UIColor.white.cgColor,UIColor(red: 18/255.0, green: 183/255.0, blue: 219/255.0, alpha: 0.7).cgColor,color]
      }
    }
  }
  
  var progress:CGFloat! = 0.0 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  var oldPath:CGPath?
  var newPath:CGPath?
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    descriptionLabel.font = UIFont.systemFont(ofSize: 12)
    descriptionLabel.textColor = UIColor.darkGray
    
    self.addSubview(iconView)
    self.addSubview(titleLable)
    self.addSubview(descriptionLabel)
    
    bgProgressLayer = CAShapeLayer()
    self.contentView.layer.addSublayer(bgProgressLayer)
    
    bgGradientLayer = CAGradientLayer()
    let co = UIColor(red: 50, green: 213, blue: 80, alpha: 1).cgColor
    bgGradientLayer.colors = [UIColor.white.cgColor,UIColor.green.cgColor,co,UIColor.white.cgColor]
    bgGradientLayer.locations = [0.02,0.3,0.6,1]
    bgGradientLayer.startPoint = CGPoint(x: 0, y: 0)
    bgGradientLayer.endPoint   = CGPoint(x: 1.0, y: 0)
    bgGradientLayer.frame      = bgProgressLayer.frame
    bgProgressLayer.addSublayer(bgGradientLayer)
    
    iconView.snp.makeConstraints { (make) in
      make.left.equalTo(self).offset(10)
      make.topMargin.equalTo(self).offset(5)
      make.bottomMargin.equalTo(self).offset(-5)
      make.width.equalTo(iconView.snp.height)
    }
    titleLable.snp.makeConstraints { (make) in
      make.leading.equalTo(iconView.snp.trailing).offset(10)
      make.height.equalTo(self.frame.height)
      make.trailing.equalTo(descriptionLabel.snp.leading).offset(-10)
      make.centerY.equalTo(self)
    }
    descriptionLabel.snp.makeConstraints { (make) in
      make.trailing.equalTo(self).offset(-10)
      make.height.equalTo(self.frame.height)
      make.centerY.equalTo(self)
    }
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    oldPath = bgProgressLayer.path
    
    bgProgressLayer.fillColor   = UIColor.white.cgColor
    bgProgressLayer.strokeColor = UIColor.white.cgColor
    newPath = CGPath(roundedRect: CGRect(x:iconView.frame.maxX+10,y:0,width:(self.frame.width-iconView.frame.maxX-10)*progress,height:self.frame.height), cornerWidth: 0, cornerHeight: 0, transform: nil)
    bgProgressLayer.path = newPath
    let anim = CABasicAnimation(keyPath: "path")
    anim.fromValue = oldPath
    anim.toValue   = newPath
    anim.duration  = 1
    anim.delegate = self
    bgProgressLayer.add(anim, forKey: "path")
    
    bgGradientLayer.frame      = CGRect(x:iconView.frame.maxX+10,y:0,width:(self.frame.width-iconView.frame.maxX-10)*progress,height:self.frame.height)
    
  }
  
}

extension BgProgressViewCell:CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

  }
}
