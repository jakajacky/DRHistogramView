//
//  NetSpeedConvert.swift
//  DRHistogramViewExample
//
//  Created by XiaoQiang on 2017/6/13.
//  Copyright © 2017年 xqzh. All rights reserved.
//

import UIKit

class NetSpeedConvert: NSObject {
  
  func handleNetSpeed(value:Float) -> String {
    var speed = value
    var unit_s = "B/s";
    if speed>=1024.0 {
      unit_s = "KB/s"
      speed = speed/1024.0
      if speed>=1024.0 {
        unit_s = "M/s"
        speed = speed/1024.0
      }
    }
    return String(format: "%.1f%@", speed,unit_s)
  }
  
}
