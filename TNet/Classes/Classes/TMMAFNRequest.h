//  WebRequest.h
//  Ejinrong
//  Created by dayu on 15/11/9.
//  Copyright © 2015年 pan. All rights reserved.
#import <Foundation/Foundation.h>
#import "AFAppDotNetAPIClient.h"

/**
 *  内容类型
 */
static NSString *const contentType = @"text/html;text/plain;text/json;application/json;charset=utf-8";

/*
 *  逻辑层回调Block，传递响应数据对象到VC
 */
typedef void (^TMMCompletionHandler)(id response);

/*
 *  逻辑层回调Block错误信息
 */
typedef void (^TMMErrorHandler)(NSError *error);


@interface TMMAFNRequest : NSObject



/*
 *  AFN Post请求
 *
 *  @param dic               数据集合
 *  @param ReqUrl        请求地址名字
 *  @param completionHeadler 成功回调
 *  @param errorHeadler      失败回调
 */
+(void)reqPOST: (NSDictionary*) dic ReqUrl:(NSString *)reqUrl Completion:(TMMCompletionHandler)completionHeadler Error:(TMMErrorHandler)errorHeadler;

/*
 *  AFN Get请求
 *
 *  @param dic               数据集合
 *  @param reqUrl           请求地址名字
 *  @param completionHeadler 成功回调
 *  @param errorHeadler      失败回调
 */
+(void)reqGET: (NSDictionary*) dic ReqUrl:(NSString *)reqUrl Completion:(TMMCompletionHandler)completionHeadler Error:(TMMErrorHandler)errorHeadler;

@end
