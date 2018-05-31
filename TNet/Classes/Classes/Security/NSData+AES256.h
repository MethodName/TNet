//
//  NSData+AES256.h
//  MyCode
//
//  Created by methodname on 14-12-3.
//  Copyright (c) 2014年 com.rex.shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

/*
    加密
    (NSString*)key 32位秘钥
    返回加密后的 NSData
 */
- (NSData*)AES256EncryptWithKey:(NSString*)key ;

- (NSData*)AES256EncryptWithKey2:(NSString*)key;
- (NSData*)AES256DecryptWithKey2:(NSString*)key;

/*
 解密
 (NSString*)key 32位秘钥
 返回解密后的 NSData
 */
- (NSData*)AES256DecryptWithKey:(NSString*)key ;

@end
