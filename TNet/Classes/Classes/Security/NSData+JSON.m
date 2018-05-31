//
//  NSData+JSON.m
//  MyCode
//
//  Created by 沈佳 on 14-12-3.
//  Copyright (c) 2014年 com.rex.shen. All rights reserved.
//

#import "NSData+JSON.h"

@implementation NSData (JSON)

+(instancetype) dataWithURLString:(NSString*)urlstring
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: urlstring]];
    
    NSData *dataResponse = [NSURLConnection sendSynchronousRequest: urlRequest returningResponse: nil error: nil];
    
    return dataResponse;
}


-(id) toJSONDictionary
{
    NSError *error;
    id dic = [NSJSONSerialization JSONObjectWithData: self options: NSJSONReadingMutableContainers error: &error];
    return dic;
}


@end
