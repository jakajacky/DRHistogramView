//
//  NetSpeedCaculate.m
//  DRHistogramViewExample
//
//  Created by XiaoQiang on 2017/6/13.
//  Copyright © 2017年 xqzh. All rights reserved.
//

#import "NetSpeedCaculate.h"
#import <ifaddrs.h>
#import <sys/socket.h>
#import <net/if.h>
@implementation NetSpeedCaculate

- (NSArray *)getDataCounters
{
  BOOL success;
  struct ifaddrs *addrs;
  struct ifaddrs *cursor;
  struct if_data *networkStatisc;
  long WiFiSent = 0;
  long WiFiReceived = 0;
  long WWANSent = 0;
  long WWANReceived = 0;
  NSString *name=[[NSString alloc]init];
  success = getifaddrs(&addrs) == 0;
  if (success)
  {
    cursor = addrs;
    while (cursor != NULL)
    {
      name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
      //NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
      // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
      if (cursor->ifa_addr->sa_family == AF_LINK)
      {
        if ([name hasPrefix:@"en"])
        {
          networkStatisc = (struct if_data *) cursor->ifa_data;
          WiFiSent+=networkStatisc->ifi_obytes;
          WiFiReceived+=networkStatisc->ifi_ibytes;
          //NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
          //NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
        }
        if ([name hasPrefix:@"pdp_ip"])
        {
          networkStatisc = (struct if_data *) cursor->ifa_data;
          WWANSent+=networkStatisc->ifi_obytes;
          WWANReceived+=networkStatisc->ifi_ibytes;
          //NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
          //NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
        }
      }
      cursor = cursor->ifa_next;
    }
    freeifaddrs(addrs);
  }
  return [NSArray arrayWithObjects:[NSNumber numberWithLong:WiFiSent], [NSNumber numberWithLong:WiFiReceived],[NSNumber numberWithLong:WWANSent],[NSNumber numberWithLong:WWANReceived], nil];
}

@end
