//
//  HSDSecurity.h
//  HaoShiDai
//
//  Created by methodname on 14-12-9.
//  Copyright (c) 2014年 shenjia. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TMMSecurityDelegate<NSObject>

-(NSString *)AES256Key;
-(NSString *)DECKey;

@end


#pragma mark -安全类
@interface TMMSecurity : NSObject

@property(nonatomic,weak)id<TMMSecurityDelegate>delegate;

+(instancetype)standardSecurity;

#pragma mark -加密
-(NSString *) AES256EncryptWithString:(NSString *) str;

#pragma mark -解密
-(NSString *) AES256DecryptWithString:(NSString *) str;



/**
 *  AES加密
 *
 *  @param str 加密内容
 *  @param key 密匙
 *
 *  @return 密文
 */
-(NSString *) AES256EncryptWithString:(NSString *) str Key:(NSString *)key;

/**
 *  AES解密
 *
 *  @param str 密文
 *  @param key 密匙
 *
 *  @return 原文
 */
-(NSString *) AES256DecryptWithString:(NSString *) str Key:(NSString *)key;



/**
 *  DES加密
 *
 *  @param text 明文
 *
 *  @return 密文
 */
+ (NSString *)DESEncrypt:(NSString *)text;

/**
 *  DES解密
 *
 *  @param text 密文
 *
 *  @return 明文
 */
+ (NSString *)DESDecrypt:(NSString *)text;


/**
 *  DES加密
 *
 *  @param data 要加密的数据
 *  @param key  密匙
 *
 *  @return 解密后的数据
 */
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;
/**
 *  DES解密
 *
 *  @param data 解密数据
 *  @param key  密匙
 *
 *  @return 解密后的数据
 */
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;


/**
 *  DES加密2⃣️
 *
 *  @param clearText 明文
 *  @param key       密匙
 *
 *  @return 密文
 */
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;

/**
 *  DES解密2⃣️
 *
 *  @param plainText 密文
 *  @param key       密匙
 *
 *  @return 明文
 */
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;




+ (NSData *)replaceNoUtf8:(NSData *)data;







@end
