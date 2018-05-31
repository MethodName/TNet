//
//  AFAppDotNetAPIClient.h
//  HaoShiDai
//
//  Created by 唐明明 on 16/8/29.
//  Copyright © 2016年 360haoshidai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFAppDotNetAPIClient : AFURLSessionManager

+ (instancetype)sharedClient;

@end
