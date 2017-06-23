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
  let reachability = Reachability()!
  
  var wifi_s:Float = 0.0;
  var wifi_r:Float = 0.0;
  var wwan_s:Float = 0.0;
  var wwan_r:Float = 0.0;
  
  var isWifi:Bool  = false
  var isWwan:Bool  = false
  
  var m:CGFloat = 0.0
  var s:CGFloat = 0.0
  var total:CGFloat = 0.0
  var wifiInfo:(ssid:String,mac:String)!
  var datas:[NSNumber]!
  
  var wifis:Float = 0.0
  var wifir:Float = 0.0
  var wwans:Float = 0.0
  var wwanr:Float = 0.0
  
  @IBOutlet weak var table: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
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
    
    let timer = Timer(timeInterval: 1, target: self, selector: #selector(time), userInfo: nil, repeats: true)
    let run = RunLoop.current
    run.add(timer, forMode: RunLoopMode.commonModes)
    timer.fire()
  }
  
  override func viewDidAppear(_ animated: Bool) {
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
    // Dispose of any resources that can be recreated.
  }

  @objc func time() {
    i += 5
    
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
    
    let mem = MemoryCaculate()
    m = CGFloat(mem.availableMemory())
    
    let space = DiskSpaceCaculate()
    s = space.getDiskspace()
    total = space.getTotalDiskspace()
    
    // wifi信息
    wifiInfo = CurrentWIFIManager().getWIFIInfo()
    
    // 网络上行下载速度
    datas = NetSpeedCaculate().getDataCounters() as! [NSNumber]
    print("WIFISent:\(datas[0])\nWIFIReceive:\(datas[1])")
    
    if self.isWifi {
      wifis = datas[0].floatValue - self.wifi_s
      wifir = datas[1].floatValue - self.wifi_r
    }
    else if self.isWwan {
      wwans = datas[2].floatValue - self.wwan_s
      wwanr = datas[3].floatValue - self.wwan_r
    }
    
    
    self.wifi_s = datas[0].floatValue
    self.wifi_r = datas[1].floatValue
    
    self.wwan_s = datas[2].floatValue
    self.wwan_r = datas[3].floatValue
    
    if wifiInfo.ssid.compare("蜂窝移动网络") == ComparisonResult.orderedSame {
      
      self.isWwan = true
      self.isWifi = false
    }
    else {
      
      self.isWwan = false
      self.isWifi = true
    }
    
    table.reloadData()
  }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
  @available(iOS 2.0, *)
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 2
    case 1:
      return 1
    case 2:
      return 2
    default:
      return 0
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3;
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "MEMORY"
    case 1:
      return "WIFI"
    case 2:
      return "SPEED"
    default:
      return "OTHER"
    }
  }
  
  @available(iOS 2.0, *)
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      var cell = tableView.dequeueReusableCell(withIdentifier: "review") as? BgProgressViewCell
      if cell==nil {
        cell = BgProgressViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "review")
      }
      if indexPath.row == 0 {
        cell?.titleLable.text = "内存占用"
        cell?.iconView.image  = UIImage(named: "set_ram")
        cell?.descriptionLabel.text = NSString(format: "%@\\2G", NetSpeedConvert.handleMemory(value: Float(2048 - m))) as String //""
        cell?.color = UIColor(red: 50/255.0, green: 213/255.0, blue: 80/255.0, alpha: 0.8).cgColor
        cell?.progress = (2048 - m) / 2048.0
      }
      else {
        cell?.titleLable.text = "空间占用"
        cell?.iconView.image  = UIImage(named: "set_mem")
        cell?.descriptionLabel.text = NSString(format: "%.1fG\\%.fG", s-2.3,total) as String //""
        cell?.color = UIColor(red: 18/255.0, green: 150/255.0, blue: 219/255.0, alpha: 0.8).cgColor
        cell?.progress = (s-2.3)/total
      }
      cell?.selectionStyle = .none
      return cell!;
    }
    else if indexPath.section == 1 {
      var cell = tableView.dequeueReusableCell(withIdentifier: "review") as? BgProgressViewCell
      if cell==nil {
        cell = BgProgressViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "review")
      }
      cell?.titleLable.text = "无线局域网"
      cell?.iconView.image  = UIImage(named: "set_wifi")
      cell?.descriptionLabel.text = wifiInfo.ssid
      cell?.selectionStyle = .none
      return cell!;
    }
    else {
      var cell = tableView.dequeueReusableCell(withIdentifier: "review") as? BgProgressViewCell
      if cell==nil {
        cell = BgProgressViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "review")
      }
      
      if self.isWifi {
        
        if indexPath.row == 0 {
          cell?.titleLable.text = "上行速度"
          cell?.iconView.image  = UIImage(named: "set_up")
          cell?.descriptionLabel.text = NetSpeedConvert().handleNetSpeed(value: wifis)
        }
        else {
          cell?.titleLable.text = "下行速度"
          cell?.iconView.image  = UIImage(named: "set_down")
          cell?.descriptionLabel.text = NetSpeedConvert().handleNetSpeed(value: wifir)
        }
      }
      else if self.isWwan {
        
        if indexPath.row == 0 {
          cell?.titleLable.text = "上行速度"
          cell?.iconView.image  = UIImage(named: "set_up")
          cell?.descriptionLabel.text = NetSpeedConvert().handleNetSpeed(value: wwans)
        }
        else {
          cell?.titleLable.text = "下行速度"
          cell?.iconView.image  = UIImage(named: "set_down")
          cell?.descriptionLabel.text = NetSpeedConvert().handleNetSpeed(value: wwanr)
        }
      }
      
      
      cell?.selectionStyle = .none
      return cell!;
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50.0;
  }
  
}

