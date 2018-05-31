//
//  TMMResponse.m
//  TNet
//
//  Created by 唐明明 on 2018/5/31.
//

#import "TMMResponse.h"
#import "Security/TMMSecurity.h"
#import "Security/NSDictionary+JSON.h"
#import "Security/NSData+JSON.h"


@implementation TMMResponse

/**
 *  获取服务器的响应数据，解密后返回
 *
 *  @return data明文
 */
-(id)data
{
    if ([_data isKindOfClass:[NSString class]])
    {
        NSString* dec = [[TMMSecurity standardSecurity] AES256DecryptWithString:_data];
        return  [[dec dataUsingEncoding:NSUTF8StringEncoding] toJSONDictionary];
    }
    else
    {
        return _data;
    }
}


@end
