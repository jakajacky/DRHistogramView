//
//  ReachabilityManager.swift
//  DRHistogramViewExample
//
//  Created by XiaoQiang on 2017/6/22.
//  Copyright © 2017年 xqzh. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
  
  var reachability:Reachability!
  
  override init() {
    super.init()
  }
  
  private static let manager = ReachabilityManager()
  class var shareInstance: ReachabilityManager {
    
    manager.reachability = Reachability()!
    
    return manager
  }
  
}
