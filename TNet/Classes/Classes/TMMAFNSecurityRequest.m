//
//  TMMAFNSecurityRequest.m
//  TNet
//
//  Created by 唐明明 on 2018/5/31.
//

#import "TMMAFNSecurityRequest.h"
#import "Security/TMMSecurity.h"
#import "Security/NSDictionary+JSON.h"
#import "Security/NSObject+BindProperty.h"

@implementation TMMAFNSecurityRequest

/*
 *  加密AFN Post请求  使用加密请求，请先实现TMMSecurity的代理方法设置密钥
 *
 *  @param reqUrl            请求地址名字
 *  @param parameters        数据集合
 *  @param completionHeadler 成功回调
 *  @param errorHeadler      失败回调
 */
+(void)reqSecurityPOST :(NSString *)reqUrl parameters:(NSDictionary*)parameters completion:(TMMSecurityCompletionHandler)completionHeadler error:(TMMErrorHandler)errorHeadler
{
    //加密数据
    NSDictionary *dncryptDic = [TMMAFNSecurityRequest getRequestBodyWithDictionary:parameters];
    
    __weak AFURLSessionManager *manager = [AFAppDotNetAPIClient sharedClient];
    
    //创建请求对象
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:reqUrl parameters:dncryptDic error:nil];
    
    //请求头
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
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
            TMMResponse *resp = [TMMAFNSecurityRequest getResponseWithRequest:responseObject];
            if (completionHeadler) {
                completionHeadler(resp);
            }
        }
    }];
    [dataTask resume];
#pragma clang diagnostic pop
}

/*
 *  对请求参数进行封装
 *
 *  @param dictionary 参数列表
 *
 *  @return 封装后的参数列表
 */
+(NSDictionary*) getRequestBodyWithDictionary:(NSDictionary *) dictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //用户令牌 取 NSUserDefaults中key为_UserDefaultKeyToken的值
    [dic setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"_UserDefaultKeyToken"] forKey:@"token"];
    //设备
    [dic setObject:@"iOS" forKey:@"device"];
    //数据【加密】
    [dic setObject:[[TMMSecurity standardSecurity] AES256EncryptWithString:[dictionary toJSONString]] forKey:@"data"];
    return dic;
}

/*
 *  对接口返回值进行解密
 *
 *  @param responseObject 参数列表
 *
 *  @return 封装后的参数列表
 */
+(TMMResponse*) getResponseWithRequest:(id)responseObject
{
    TMMResponse * res = [[TMMResponse alloc] init];
    [res reflectDataFromDictionary:responseObject];
    return res;
}



@end
