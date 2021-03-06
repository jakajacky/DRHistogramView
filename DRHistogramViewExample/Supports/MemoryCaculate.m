//
//  MemoryCaculate.m
//  DRHistogramViewExample
//
//  Created by xqzh on 16/12/7.
//  Copyright © 2016年 xqzh. All rights reserved.
//

#import "MemoryCaculate.h"

#import <sys/sysctl.h>
#import <mach/mach.h>
@import Darwin.sys.mount;

@implementation MemoryCaculate

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
  vm_statistics_data_t vmStats;
  mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
  kern_return_t kernReturn = host_statistics(mach_host_self(),
                                             HOST_VM_INFO,
                                             (host_info_t)&vmStats,
                                             &infoCount);
  
  if (kernReturn != KERN_SUCCESS) {
    return NSNotFound;
  }
  
  return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
  task_basic_info_data_t taskInfo;
  mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
  kern_return_t kernReturn = task_info(mach_task_self(),
                                       TASK_BASIC_INFO,
                                       (task_info_t)&taskInfo,
                                       &infoCount);
  
  if (kernReturn != KERN_SUCCESS
      ) {
    return NSNotFound;
  }
  
  return taskInfo.resident_size / 1024.0 / 1024.0;
}

// 获取剩余存储空间
- (NSString *) freeDiskSpaceInBytes{
  struct statfs buf;
  long long freespace = -1;
  if(statfs("/var", &buf) >= 0){
    freespace = (double)(buf.f_bsize * buf.f_bfree);
  }
  return [NSString stringWithFormat:@"手机剩余存储空间为：%lf MB" ,freespace/1024.0/1024.0];
}

@end
