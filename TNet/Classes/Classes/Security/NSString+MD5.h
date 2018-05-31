//
//  NSString+MD5.h
//  MyCode
//
//  Created by methodname on 14-12-3.
//  Copyright (c) 2014年 com.rex.shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
/*
    获取字符串的MD5值
    返回32位MD5值
 */
-(NSString*) MD5;
//md5 32位 加密 （小写）
- (NSString *)md532;
- (NSString *)getMd5_32Bit;

/**
 *  Escape转码
 *
 *  @return 转码后
 */
- (NSString *)encodeToPercentEscapeString;


- (NSString *)URLEncodedString;

- (NSString*)URLDecodedString;


@end
