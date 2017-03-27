//
//  CurrentWIFIManager.swift
//  DRHistogramViewExample
//
//  Created by xqzh on 17/3/27.
//  Copyright © 2017年 xqzh. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class CurrentWIFIManager: NSObject {

  func getWIFIInfo() -> (ssid:String, mac:String) {
    if let cfas:NSArray = CNCopySupportedInterfaces() {
      for cfa in cfas {
        if let dic = CFBridgingRetain(CNCopyCurrentNetworkInfo(cfa as! CFString)) {
          if let ssid = dic["SSID"] as? String, let bssid = dic["BSSID"] as? String {
            return (ssid, bssid)
          }
        }
      }
    }
    return ("未知", "未知")
  }
  
  func getSignalStrength() -> NSInteger {
    let app = UIApplication.shared
    let bar:NSObject = app.value(forKey: "statusBar") as! NSObject
    if let view:UIView  = bar.value(forKey: "foregroundView") as? UIView {
      var dataNetworkItemView:NSObject = NSObject();
      
      
      for subview in view.subviews {
        if subview.isKind(of: (NSClassFromString("UIStatusBarDataNetworkItemView")?.class())!) {
          dataNetworkItemView = subview;
        }
      }
      
      let signalStrengthObj = dataNetworkItemView.value(forKey: "_wifiStrengthBars")! as! NSInteger
      
      return signalStrengthObj
    }else {
      print("没有找到状态栏")
      return 3;
    }
    
  }

  
}
