//
//  AFAppDotNetAPIClient.m
//  HaoShiDai
//
//  Created by 唐明明 on 16/8/29.
//  Copyright © 2016年 360haoshidai. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

@implementation AFAppDotNetAPIClient


/*
 *
 *  单列AFN Manager对象
 *
 *  @return sharedClient
 */
+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //默认配置
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //延时时间
        configuration.timeoutIntervalForRequest = 15;
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithSessionConfiguration:configuration];
    });
    
    return _sharedClient;
}
@end
