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

// MARK: UIScrollView Category
private var UIScrollViewPullToRefreshView:uint = 0

extension UIScrollView {
  // MARK: - 运行时添加属性
  var pullRefreshView:DRPullToRefreshView {
    set(newValue) {
      objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    get {
      return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView) as! DRPullToRefreshView
    }
  }
  
  // MARK: - 添加刷新控件
  /// 为tableView、scrollView添加刷新控件
  /// - parameter complete : 触发刷新的回调
  func pullToRefreshWithCompletion(complete:@escaping ()->()) {
    
    setUpRefreshViews(complete: complete)
    
    setUpObservers()
  }
  
  // MARK: - 结束刷新
  /// 结束刷新
  func endRefresh() {
    //    removeObservers()
    self.pullRefreshView.refreshViewDidDisappear()
  }
  
  open override func willMove(toSuperview newSuperview: UIView?) {
    
  }
  
  // MARK: - 设置刷新视图
  /// 设置刷新视图
  func setUpRefreshViews(complete:@escaping ()->()) {
    let view = DRPullToRefreshView(frame: CGRect(x: 0, y: -60, width: self.frame.width, height: 60))
    self.addSubview(view)
    
    let acti = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    acti.frame = CGRect(x: view.frame.width/2.0-10, y: 20, width: 20, height: 20)
    acti.startAnimating()
    view.addSubview(acti)
    self.pullRefreshView = view
    self.pullRefreshView.scrollView = self
    self.pullRefreshView.RefreshHandler = complete
  }
  
  // MARK: - 管理观察者
  /// 设置观察者
  func setUpObservers() {
    
    self.addObserver(self.pullRefreshView, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    self.addObserver(self.pullRefreshView, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    self.addObserver(self.pullRefreshView, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
  }
  /// 取消观察者
  func removeObservers() {
    self.removeObserver(self.pullRefreshView, forKeyPath: "contentOffset")
    self.removeObserver(self.pullRefreshView, forKeyPath: "contentSize")
    self.removeObserver(self.pullRefreshView, forKeyPath: "frame")
  }
  
}
