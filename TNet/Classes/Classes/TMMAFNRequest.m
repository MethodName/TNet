//
//  WebRequest.m
//  Ejinrong
//
//  Created by dayu on 15/11/9.
//  Copyright © 2015年 pan. All rights reserved.
//

#import "TMMAFNRequest.h"

@implementation TMMAFNRequest






/*
 *  AFN Post请求
 *
 *  @param dic               数据集合
 *  @param ReqUrl        请求地址名字
 *  @param completionHeadler 成功回调
 *  @param errorHeadler      失败回调
 */
+(void)reqPOST: (NSDictionary*) dic ReqUrl:(NSString *)reqUrl Completion:(TMMCompletionHandler)completionHeadler Error:(TMMErrorHandler)errorHeadler
{
    __weak AFURLSessionManager *manager = [AFAppDotNetAPIClient sharedClient];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //创建请求对象
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:reqUrl parameters:dic error:nil];
    
    //请求头
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"iphone" forHTTPHeaderField:@"User-Agent"];
    __block NSString * blockrequrl = reqUrl;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"❌❌❌❌❌%@  [网络请求失败]❌❌❌❌❌",blockrequrl);
            if (errorHeadler) {
                errorHeadler(error);
            }
        }
        else
        {
            NSLog(@"✅✅✅✅✅%@  [网络请求成功]✅✅✅✅✅",blockrequrl);
            if (completionHeadler) {
                completionHeadler(responseObject);
            }
        }
    }];
    [dataTask resume];
#pragma clang diagnostic pop
}

/*
 *  AFN Get请求
 *
 *  @param dic               数据集合
 *  @param reqUrl           请求地址名字
 *  @param completionHeadler 成功回调
 *  @param errorHeadler      失败回调
 */
+(void)reqGET: (NSDictionary*) dic ReqUrl:(NSString *)reqUrl Completion:(TMMCompletionHandler)completionHeadler Error:(TMMErrorHandler)errorHeadler
{
    __weak AFURLSessionManager *manager = [AFAppDotNetAPIClient sharedClient];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //创建请求对象
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:reqUrl parameters:dic error:nil];
    
    //请求头
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"iphone" forHTTPHeaderField:@"User-Agent"];
    __block NSString * blockrequrl = reqUrl;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"❌❌❌❌❌%@  [网络请求失败]❌❌❌❌❌",blockrequrl);
            if (errorHeadler) {
                errorHeadler(error);
            }
        }
        else
        {
            NSLog(@"✅✅✅✅✅%@  [网络请求成功]✅✅✅✅✅",blockrequrl);
            if (completionHeadler) {
                completionHeadler(responseObject);
            }
        }
    }];
    [dataTask resume];
#pragma clang diagnostic pop
}





@end
