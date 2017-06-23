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
  
  var histogram:CAShapeLayer!   = CAShapeLayer()   // 占用条
  var backHisto:CAShapeLayer!   = CAShapeLayer()   // 总量条
  var textLayer:HistogramLayer! = HistogramLayer() // 文字
  var direction:Direction!      = .right           // 控件动画方向,默认往右
  var path:CGPath!                                 // 路径
  var text:NSString!                               // 显示
  var histogramColor:UIColor!   = UIColor.red      // 颜色,默认红色
  var showWithNumber:Bool!      = false            // 以实际数值显示，默认false（按比例显示）
  var proportion:CGFloat! {                        // 占比
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
    let width = self.bounds.size.width
//    histogramColor = UIColor(red: 154/255.0, green: 85/255.0, blue: 252/255.0, alpha: 1)
    
    backHisto.frame       = self.bounds
    backHisto.fillColor   = UIColor(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 0.5).cgColor
    backHisto.strokeColor = UIColor(red: 169/255.0, green: 169/255.0, blue: 169/255.0, alpha: 0.5).cgColor
    let backPath          = CGPath(roundedRect: self.bounds,
                                   cornerWidth: 5,
                                   cornerHeight: 5,
                                   transform: nil)
    backHisto.path        = backPath
    
    let x                     = (width - 50) / 2.0
    textLayer.frame           = CGRect(x: x, y: 12, width: 50, height: 26)
    textLayer.bounds          = CGRect(x:0, y:12,width: 50, height: 26);
    textLayer.borderColor     = UIColor.lightGray.cgColor
    textLayer.cornerRadius    = 5
    textLayer.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5).cgColor
    
    histogram.frame       = self.bounds
    histogram.fillColor   = histogramColor.cgColor
    histogram.strokeColor = histogramColor.cgColor
    if proportion <= width {
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
        path = CGPath(roundedRect: CGRect(x: width - proportion, y: 0, width: proportion, height: 50),
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
    
      let pro:Int    = Int(proportion / width * 100)
      let value      = NSString(format: "%.1fG", proportion!)
      if showWithNumber! {
        textLayer.text = value
      }
      else {
        textLayer.text = "\(pro)%" as NSString!
      }
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
    
    // 解决渲染文字不清楚的bug
    self.contentsScale = 2.0

    // 渲染
    context.strokePath()
    
    // 文字颜色 文字背景颜色 文字大小
    let md = [NSAttributedStringKey.foregroundColor:UIColor.white,
              NSAttributedStringKey.backgroundColor:UIColor.clear,
              NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)]
    
    //计算文字宽度
    let size:CGSize = text.boundingRect(with: CGSize(width: Double(MAXFLOAT), height: 26.0),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)],
                                        context: nil).size
    
    // 将文字绘制到指定位置
    text!.draw(in: CGRect(x: (50 - size.width) / 2.0, y: 16, width: 50, height: 26), withAttributes: md)
    
    UIGraphicsPopContext() // 退出当前上下文

  }
}
