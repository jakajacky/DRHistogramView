//
//  ViewController.swift
//  DRHistogramViewExample
//
//  Created by xqzh on 16/11/30.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var i:CGFloat = 0.0
  let hi = DRHistogramView(frame: CGRect(x: 100, y: 10, width: 200, height: 50))
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
//    let hi = DRHistogramView(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
    hi.backgroundColor = UIColor.clear
    hi.histogramColor  = UIColor(red: 154/255.0, green: 85/255.0, blue: 252/255.0, alpha: 1)
    hi.proportion = 0
    self.view.addSubview(hi)
    
    let timer = Timer(timeInterval: 1, target: self, selector: #selector(time), userInfo: nil, repeats: true)
    let run = RunLoop.current
    run.add(timer, forMode: RunLoopMode.commonModes)
    timer.fire()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func time() {
    i += 10
    
    hi.proportion = self.i
  }

}

