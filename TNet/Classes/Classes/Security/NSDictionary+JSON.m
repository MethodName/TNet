//
//  NSDictionary+JSON.m
//  HaoShiDai
//
//  Created by 沈佳 on 14-12-9.
//  Copyright (c) 2014年 shenjia. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

#pragma mark -将字典转为json
-(NSString *) toJSONString
{
 
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        return json;
    }
    return nil;
}



@end
