//
//  TMMAFNSecurityRequest.h
//  TNet
//
//  Created by 唐明明 on 2018/5/31.
//

#import "TMMAFNRequest.h"
#import "TMMResponse.h"
/*
 *  逻辑层回调Block，传递响应数据对象到VC
 */
typedef void (^TMMSecurityCompletionHandler)(TMMResponse * response);

@interface TMMAFNSecurityRequest : TMMAFNRequest


/*
 *  加密AFN Post请求
 *
 *  @param reqUrl            请求地址名字
 *  @param parameters        数据集合
 *  @param completionHeadler 成功回调
 *  @param errorHeadler      失败回调
 */
+(void)reqSecurityPOST :(NSString *)reqUrl parameters:(NSDictionary*)parameters completion:(TMMSecurityCompletionHandler)completionHeadler error:(TMMErrorHandler)errorHeadler;

@end
