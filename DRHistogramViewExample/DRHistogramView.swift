//
//  DRHistogramView.swift
//  DRHistogramViewExample
//
//  Created by xqzh on 16/11/30.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

enum Direction {
  case left
  case right
}

class DRHistogramView: UIView {
  
  var histogram:CAShapeLayer!   = CAShapeLayer()  // 占用条
  var backHisto:CAShapeLayer!   = CAShapeLayer()  // 总量条
  var textLayer:HistogramLayer! = HistogramLayer()// 文字
  var path:CGPath!                                // 路径
  var text:NSString!                              // 显示
  var direction:Direction!      = .right           // 控件动画方向,默认往右
  var proportion:CGFloat! {                       // 占比
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.layer.addSublayer(backHisto)
    self.layer.addSublayer(histogram)
    self.layer.addSublayer(textLayer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    
    
    backHisto.frame       = self.bounds
    backHisto.fillColor   = UIColor.gray.cgColor
    backHisto.strokeColor = UIColor.gray.cgColor
    let backPath          = CGPath(roundedRect: self.bounds,
                                   cornerWidth: 5,
                                   cornerHeight: 5,
                                   transform: nil)
    backHisto.path        = backPath
    
    let x                     = (self.bounds.size.width - 70) / 2.0
    textLayer.frame           = CGRect(x: x, y: 12, width: 70, height: 26)
    let red:CGFloat           = 255/255.0
    let blue:CGFloat          = 255/255.0
    let green:CGFloat         = 255/255.0
    textLayer.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.5).cgColor
    textLayer.borderColor     = UIColor.lightGray.cgColor
    textLayer.bounds          = CGRect(x:0, y:12,width: 70, height: 26);
    textLayer.cornerRadius    = 5
    
    histogram.frame       = self.bounds
    histogram.fillColor   = UIColor.red.cgColor
    histogram.strokeColor = UIColor.red.cgColor
    if proportion<=200 {
      // 记录原先的path
      let oldPath = path
      // 生成新的path
      if direction == .right {
        path = CGPath(roundedRect: CGRect(x: 0, y: 0, width: proportion, height: 50),
                      cornerWidth: 5,
                      cornerHeight: 5,
                      transform: nil)
      }
      else {
        path = CGPath(roundedRect: CGRect(x: 200 - proportion, y: 0, width: proportion, height: 50),
                      cornerWidth: 5,
                      cornerHeight: 5,
                      transform: nil)
      }
      histogram.path = path
      
      // 加CABasicAnimation动画
      let animation       = CABasicAnimation(keyPath: "path")
      animation.fromValue = oldPath
      animation.toValue   = path
      animation.duration  = 0
      histogram.add(animation, forKey: "path")
    
      let pro:Int    = Int(proportion / 200 * 100)
      textLayer.text = "\(pro)%" as NSString!
      textLayer.setNeedsDisplay()
      
    }
   
  }
  

}

class HistogramLayer: CALayer {
  
  var text:NSString!
  
  override func draw(in ctx: CGContext) {
    UIGraphicsPushContext(ctx) // 指到当前上下文，否则当前的ctx是父layer的上下文
    let context = ctx
    // 绘图
    // 可画一些图形

    // 渲染
    context.strokePath()
    
    // 文字颜色 文字背景颜色 文字大小
    let md = [NSForegroundColorAttributeName:UIColor.white,
              NSBackgroundColorAttributeName:UIColor.clear,
              NSFontAttributeName:UIFont.systemFont(ofSize: 20)]
    
    //计算文字宽度
    let size:CGSize = text.boundingRect(with: CGSize(width: Double(MAXFLOAT), height: 26.0),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20)],
                                        context: nil).size
    
    // 将文字绘制到指定位置
    text!.draw(in: CGRect(x: (70 - size.width) / 2.0, y: 12, width: 70, height: 26), withAttributes: md)
    
    UIGraphicsPopContext() // 退出当前上下文

  }
}
