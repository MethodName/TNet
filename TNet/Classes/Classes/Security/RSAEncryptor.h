//
//  RSAEncryptor.h
//  HaoShiDai
//
//  Created by 唐明明 on 16/3/23.
//  Copyright © 2016年 360haoshidai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject
#pragma mark - Instance Methods
/**
 *  通过文件路径加载公钥
 *
 *  @param derFilePath 公钥文件路径
 */
-(void) loadPublicKeyFromFile: (NSString*) derFilePath;
/**
 *  通过NSData加载公钥
 *  （此方法可用于将公钥配置在服务端，以Base64字符串传到移动端来加载）
 *  @param derData 公钥data
 */
-(void) loadPublicKeyFromData: (NSData*) derData;
/**
 *  通过文件路径加载私钥
 *
 *  @param p12FilePath 私钥文件路径
 *  @param p12Password 私钥密码
 */
-(void) loadPrivateKeyFromFile: (NSString*) p12FilePath password:(NSString*)p12Password;
/**
 *  通过NSData加载私钥
 *
 *  @param p12Data     私钥data
 *  @param p12Password 私钥密码
 */
-(void) loadPrivateKeyFromData: (NSData*) p12Data password:(NSString*)p12Password;

/**
 *  RSA加密字符串
 *
 *  @param string  要加密的明文字符串
 *
 *  @return 加密后的密文字符串
 */
-(NSString*) rsaEncryptString:(NSString*)string;

/**
 *  RSA加密NSData
 *
 *  @param data 要加密的明文data
 *
 *  @return 加密后的密文data
 */
-(NSData*) rsaEncryptData:(NSData*)data ;

/**
 *  RSA解密字符串
 *
 *  @param string  要解密的密文字符串
 *
 *  @return 解密后的明文字符串
 */
-(NSString*) rsaDecryptString:(NSString*)string;

/**
 *  RSA解密NSData
 *
 *  @param data 要解密的密文data
 *
 *  @return 解密后的明文data
 */
-(NSData*) rsaDecryptData:(NSData*)data;

-(BOOL) rsaSHA1VerifyData:(NSData *) plainData
            withSignature:(NSData *) signature;



#pragma mark - Class Methods
+(void) setSharedInstance: (RSAEncryptor*)instance;
+(RSAEncryptor*) sharedInstance;


/**
 *  融宝RSA解密
 *
 *  @param str 密文
 *
 *  @return 明文
 */
+(NSString *)rsaRBDecryptString:(NSString *)str;

/**
 *  融宝RSA加密
 *
 *  @param str 明文
 *
 *  @return 密文
 */
+(NSString *)rsaRBEncryptString:(NSString *)str;

/**
 *  获取16位随机数字密匙
 *
 *  @return 随机16为数字密匙
 */
+(NSString *)getRandomd16;

@end
