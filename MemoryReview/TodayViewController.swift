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
  
  
  @IBOutlet weak var layoutAssitantorH: UIView!
  
  @IBOutlet weak var layoutAssitantor: UIView!
  
  @IBOutlet weak var wifi: UIImageView!
  
  @IBOutlet weak var wifiLabel: UILabel!
    
  @IBOutlet weak var uploadSpeedLabel: UILabel!

  @IBOutlet weak var downloadSpeedLabel: UILabel!
  
  @IBOutlet weak var uploadSpeedIcon: UIImageView!
  
  @IBOutlet weak var downloadSpeedIcon: UIImageView!
  
  var wifi_s:Float = 0.0;
  var wifi_r:Float = 0.0;
  var wwan_s:Float = 0.0;
  var wwan_r:Float = 0.0;
  
  var isWifi:Bool  = false
  var isWwan:Bool  = false
  
  var i:CGFloat = 0.0
  let hi = DRHistogramView()
  let he = DRHistogramView()
  let reachability = Reachability()!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    
    hi.backgroundColor = UIColor.clear
    hi.histogramColor  = UIColor(red: 34/255.0, green: 111/255.0, blue: 224/255.0, alpha: 1)
    hi.proportion      = 0
//    hi.showWithNumber  = true
    hi.frame           = CGRect(x: 181, y: 50, width: 162, height: 50)
    self.view.addSubview(hi)
    
    he.backgroundColor = UIColor.clear
    he.histogramColor  = UIColor(red: 154/255.0, green: 85/255.0, blue: 252/255.0, alpha: 1)
    he.proportion      = 0
    he.direction       = .left
    he.frame           = CGRect(x: 17, y: 50, width: 162, height: 50)
    self.view.addSubview(he)
    
    reachability.whenReachable = { reachability in
        DispatchQueue.main.async {
            if reachability.isReachableViaWiFi {
                print("WiFi连接")
                self.isWifi = true
                self.isWwan = false
            }
            else {
                print("WWAN连接")
                self.isWifi = false
                self.isWwan = true
            }
        }
    }
    
    do {
      try reachability.startNotifier()
    } catch {
      fatalError("Unable to start notifier")
    }
    
    // SnapKit约束 7s 414  7 375  5s 320  10.5 522  12.9 638 9.7 522
    if UIDevice.current.model.compare("iPad") == ComparisonResult.orderedSame {
      var rate = 522.0
      if self.view.frame.width>=1024 {
        rate = 638.0
      }
      he.snp.makeConstraints { (make) in
        make.width.equalTo(rate*0.5)
        make.height.equalTo(50)
        make.top.equalTo(50)
        make.right.equalTo(layoutAssitantor.snp.left).offset(-0.5)
      }
      
      hi.snp.makeConstraints { (make) in
        make.width.equalTo(rate*0.5)
        make.height.equalTo(50)
        make.top.equalTo(50)
        make.left.equalTo(layoutAssitantor.snp.right).offset(0.5)
      }
    }
    else {
      he.snp.makeConstraints { (make) in
        make.width.equalTo(self.view.frame.width*0.432)
        make.height.equalTo(50)
        make.top.equalTo(50)
        make.right.equalTo(layoutAssitantor.snp.left).offset(-0.5)
      }

      hi.snp.makeConstraints { (make) in
        make.width.equalTo(self.view.frame.width*0.432)
        make.height.equalTo(50)
        make.top.equalTo(50)
        make.left.equalTo(layoutAssitantor.snp.right).offset(0.5)
      }
    }
    
    
    let timer = Timer(timeInterval: 1, target: self, selector: #selector(time), userInfo: nil, repeats: true)
    let run = RunLoop.current
    run.add(timer, forMode: RunLoopMode.commonModes)
    timer.fire()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("\(layoutAssitantorH.frame)")
    reachability.whenReachable = { reachability in
      DispatchQueue.main.async {
        if reachability.isReachableViaWiFi {
          print("WiFi连接")
          self.isWifi = true
          self.isWwan = false
        }
        else {
          print("WWAN连接")
          self.isWifi = false
          self.isWwan = true
        }
      }
    }
    
    do {
      try reachability.startNotifier()
    } catch {
      fatalError("Unable to start notifier")
    }
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    reachability.stopNotifier()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  @objc func time() {
    
    switch reachability.currentReachabilityStatus {
    case .reachableViaWiFi:
      self.isWifi = true
      self.isWwan = false
      break
    case .reachableViaWWAN:
      self.isWifi = false
      self.isWwan = true
      break
    default:
      break
    }
    
    
    i += 10
    
    let mem = MemoryCaculate()
    let m:CGFloat = CGFloat(mem.availableMemory())

    let space = DiskSpaceCaculate()
    let s:CGFloat = space.getDiskspace()
    let total:CGFloat = space.getTotalDiskspace()
    
    hi.proportion = (s-2.3)/total * 162.0
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
    
    // wifi信息
    let wifiInfo = CurrentWIFIManager().getWIFIInfo()
    wifiLabel.text = wifiInfo.ssid
    
    // 网络上行下载速度
    let datas:[NSNumber] = NetSpeedCaculate().getDataCounters() as! [NSNumber]
    print("WIFISent:\(datas[0])\nWIFIReceive:\(datas[1])")
    
    if self.isWifi {
      let wifis = datas[0].floatValue - self.wifi_s
      let wifir = datas[1].floatValue - self.wifi_r
      
      self.uploadSpeedLabel.text = NetSpeedConvert().handleNetSpeed(value: wifis)
      self.downloadSpeedLabel.text = NetSpeedConvert().handleNetSpeed(value: wifir)
    }
    else if self.isWwan {
      let wwans = datas[2].floatValue - self.wwan_s
      let wwanr = datas[3].floatValue - self.wwan_r
      
      self.uploadSpeedLabel.text = NetSpeedConvert().handleNetSpeed(value: wwans)
      self.downloadSpeedLabel.text = NetSpeedConvert().handleNetSpeed(value: wwanr)
    }
    
    
    self.wifi_s = datas[0].floatValue
    self.wifi_r = datas[1].floatValue
    
    self.wwan_s = datas[2].floatValue
    self.wwan_r = datas[3].floatValue
    
    if wifiInfo.ssid.compare("蜂窝移动网络") == ComparisonResult.orderedSame {
        wifi.image = UIImage(named: "cellular");
      self.isWwan = true
      self.isWifi = false
    }
    else {
        wifi.image = UIImage(named: "WIFI3");
      self.isWwan = false
      self.isWifi = true
    }
    
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
      uploadSpeedIcon.isHidden    = true
      uploadSpeedLabel.isHidden   = true
      downloadSpeedIcon.isHidden  = true
      downloadSpeedLabel.isHidden = true
      uploadSpeedIcon.isHidden    = true
      uploadSpeedLabel.isHidden   = true
      downloadSpeedIcon.isHidden  = true
      downloadSpeedLabel.isHidden = true
    } else {
      self.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 150)
      wifiLabel.isHidden = false
      wifi.isHidden      = false
      uploadSpeedIcon.isHidden    = false
      uploadSpeedLabel.isHidden   = false
      downloadSpeedIcon.isHidden  = false
      downloadSpeedLabel.isHidden = false
      uploadSpeedIcon.isHidden    = false
      uploadSpeedLabel.isHidden   = false
      downloadSpeedIcon.isHidden  = false
      downloadSpeedLabel.isHidden = false
    }
    
  }
    
}
