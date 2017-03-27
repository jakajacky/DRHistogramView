//
//  TodayViewController.swift
//  MemoryReview
//
//  Created by xqzh on 16/12/5.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
  @IBOutlet weak var layoutAssitantor: UIView!
  
  @IBOutlet weak var wifi: UIImageView!
  
  @IBOutlet weak var wifiLabel: UILabel!
  
  
  var i:CGFloat = 0.0
  let hi = DRHistogramView(frame: CGRect(x: 100, y: 10, width: 200, height: 50))
  let he = DRHistogramView(frame: CGRect(x: 100, y: 10, width: 200, height: 50))
  override func viewDidLoad() {
    super.viewDidLoad()

    self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    
    hi.backgroundColor = UIColor.clear
    hi.histogramColor  = UIColor(red: 34/255.0, green: 111/255.0, blue: 224/255.0, alpha: 1)
    hi.proportion      = 0
    hi.showWithNumber  = true
    hi.frame           = CGRect(x: 181, y: 50, width: 162, height: 50)
    self.view.addSubview(hi)
    
    he.backgroundColor = UIColor.clear
    he.histogramColor  = UIColor(red: 154/255.0, green: 85/255.0, blue: 252/255.0, alpha: 1)
    he.proportion      = 0
    he.direction       = .left
    he.frame           = CGRect(x: 17, y: 50, width: 162, height: 50)
    self.view.addSubview(he)
    
    // SnapKit约束
    he.snp.makeConstraints { (make) in
      make.width.equalTo(162)
      make.height.equalTo(50)
      make.top.equalTo(50)
      make.right.equalTo(layoutAssitantor.snp.left).offset(-0.5)
    }
    
    hi.snp.makeConstraints { (make) in
      make.width.equalTo(162)
      make.height.equalTo(50)
      make.top.equalTo(50)
      make.left.equalTo(layoutAssitantor.snp.right).offset(0.5)
    }
    
    
    let timer = Timer(timeInterval: 1, target: self, selector: #selector(time), userInfo: nil, repeats: true)
    let run = RunLoop.current
    run.add(timer, forMode: RunLoopMode.commonModes)
    timer.fire()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  func time() {
    i += 10
    
    let mem = MemoryCaculate()
    let m:CGFloat = CGFloat(mem.availableMemory())

    let space = DiskSpaceCaculate()
    let s:CGFloat = space.getDiskspace()
    let total:CGFloat = space.getTotalDiskspace()
    
    hi.proportion = total - s + 2.3
    he.proportion = (2048 - m) / 2048.0 * 162.0
    
    switch CurrentWIFIManager().getSignalStrength() {
    case 1:
      wifi.image = UIImage(named: "WIFI1")
      break;
    case 2:
      wifi.image = UIImage(named: "WIFI2")
      break;
    case 3:
      wifi.image = UIImage(named: "WIFI3")
      break;
    default:
      wifi.image = UIImage(named: "WIFI3")
      break;
    }
    
    let wifiInfo = CurrentWIFIManager().getWIFIInfo()
    wifiLabel.text = wifiInfo.ssid
  }
  
  private func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
      // Perform any setup necessary in order to update the view.
      
      // If an error is encountered, use NCUpdateResult.Failed
      // If there's no update required, use NCUpdateResult.NoData
      // If there's an update, use NCUpdateResult.NewData
      
      completionHandler(NCUpdateResult.newData)
  }
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {

    if (activeDisplayMode == .compact) {
      self.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 70)
      wifiLabel.isHidden = true
      wifi.isHidden      = true
    } else {
      self.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 150)
      wifiLabel.isHidden = false
      wifi.isHidden      = false
    }
    
  }
    
}
