//
//  DRPullToRefreshView.swift
//  DRHistogramViewExample
//
//  Created by XiaoQiang on 2017/6/27.
//  Copyright © 2017年 xqzh. All rights reserved.
//

import UIKit

enum RefreshStatus {
  case stoped
  case loading
}

class DRPullToRefreshView: UIView {
  
  var scrollView:UIScrollView!
  var RefreshHandler:()->() = {()in}
  var status:RefreshStatus = .stoped
  // MARK: - 观察者回调
  open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath?.compare("contentOffset")==ComparisonResult.orderedSame {
      let changeKindValue = change?[NSKeyValueChangeKey.newKey] as! CGPoint
      print("offset:\(changeKindValue)")
      scrollViewDidScroll(contentOffset: changeKindValue)
    }
    else if keyPath?.compare("contentSize")==ComparisonResult.orderedSame {
      let changeKindValue = change?[NSKeyValueChangeKey.newKey] as! CGSize
      print("size:\(changeKindValue)")
    }
    else if keyPath?.compare("frame")==ComparisonResult.orderedSame {
      let changeKindValue = change?[NSKeyValueChangeKey.newKey] as! CGRect
      print("frame:\(changeKindValue)")
    }
    else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
  }
  
  // MARK: 处理contentOffset.y
  func scrollViewDidScroll(contentOffset:CGPoint) {
    
    if contentOffset.y <= -120 {
      if self.scrollView.isDragging == false { // 手指离开
        refreshViewDidStartAnimation()
      }
    }
    else {
      if self.scrollView.isDragging == false { // 手指离开
        // 没达到触发标准，并抬起手指，则恢复
        refreshViewDidDisappear()
      }
    }
  }
  
  // MARK: 松手后开始刷新
  func refreshViewDidStartAnimation() {
    if self.status != .loading {
      UIView.animate(withDuration: 0.15, animations: {
        let contentInset = self.scrollView.contentInset
        self.scrollView.contentInset = UIEdgeInsetsMake(124, contentInset.left, contentInset.bottom, contentInset.right)
      }, completion: { (success) in
        self.status = .loading
        self.RefreshHandler()
      })
    }
  }
  
  // MARK: 结束刷新时 取消刷新视图
  func refreshViewDidDisappear() {
    if self.status == .loading {
      UIView.animate(withDuration: 0.37) {
        let contentInset = self.scrollView.contentInset
        self.scrollView.contentInset = UIEdgeInsetsMake(64, contentInset.left, contentInset.bottom, contentInset.right)
        self.status = .stoped
      }
    }
  }
  
  

}
