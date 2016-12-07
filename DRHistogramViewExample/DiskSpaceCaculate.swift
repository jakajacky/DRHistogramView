//
//  DiskSpaceCaculate.swift
//  DRHistogramViewExample
//
//  Created by xqzh on 16/12/7.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

class DiskSpaceCaculate: NSObject {

  func getDiskspace() -> CGFloat {
    
    let home = NSHomeDirectory()
    var space_use:CGFloat = 0
  
    do {
      let dic:NSDictionary = try FileManager.default.attributesOfFileSystem(forPath: home) as NSDictionary
      let fileSystemSizeInBytes:AnyObject = dic.object(forKey: "NSFileSystemSize")! as AnyObject
      let freeFileSystemSizeInBytes:AnyObject = dic.object(forKey: "NSFileSystemFreeSize")! as AnyObject
      let totalSpace = fileSystemSizeInBytes.floatValue
      let freeSpace  = freeFileSystemSizeInBytes.floatValue
      let total = totalSpace!/1024.0/1024.0/1024.0
      let free  = freeSpace!/1024.0/1024.0/1024.0
      space_use = space_use + CGFloat(total) - CGFloat(free)
    } catch {
      space_use = 0.0
    }
    
    return space_use
  }
  
  func getTotalDiskspace() -> CGFloat {
    
    let home = NSHomeDirectory()
    do {
      let dic:NSDictionary = try FileManager.default.attributesOfFileSystem(forPath: home) as NSDictionary
      let fileSystemSizeInBytes:AnyObject = dic.object(forKey: "NSFileSystemSize")! as AnyObject
      let totalSpace = fileSystemSizeInBytes.floatValue
      
      let total = totalSpace!/1024.0/1024.0/1024.0
      
      return CGFloat(total)
    } catch {
      return 0.0
    }
  
  }
  
}
