//
//  RSAEncryptor.m
//  HaoShiDai
//
//  Created by 唐明明 on 16/3/23.
//  Copyright © 2016年 360haoshidai. All rights reserved.
//

#import "RSAEncryptor.h"
#import <Security/Security.h>
#import "NSData+Base64.h"
#import <CommonCrypto/CommonCrypto.h>



@implementation RSAEncryptor
{
    /**
     *  公钥
     */
    SecKeyRef publicKey;
    /**
     *  私钥
     */
    SecKeyRef privateKey;
}

/**
 *  释放公钥私钥
 */
-(void)dealloc
{
    if (nil != publicKey) {
        CFRelease(publicKey);
    }
    if (nil != privateKey) {
        CFRelease(privateKey);
    }
}


/**
 *  获取公钥
 *
 *  @return 公钥
 */
-(SecKeyRef) getPublicKey {
    return publicKey;
}

/**
 *  获取私钥
 *
 *  @return 私钥
 */
-(SecKeyRef) getPrivateKey {
    return privateKey;
}


/**
 *  通过文件路径加载公钥
 *
 *  @param derFilePath 公钥文件路径
 */
-(void) loadPublicKeyFromFile: (NSString*) derFilePath
{
    NSData *derData = [[NSData alloc] initWithContentsOfFile:derFilePath];
    [self loadPublicKeyFromData: derData];
}

/**
 *  通过NSData加载公钥
 *  （此方法可用于将公钥配置在服务端，以Base64字符串传到移动端来加载）
 *  @param derData 公钥data
 */
-(void) loadPublicKeyFromData: (NSData*) derData
{
    publicKey = [self getPublicKeyRefrenceFromeData: derData];
}


/**
 *  通过文件路径加载私钥
 *
 *  @param p12FilePath 私钥文件路径
 *  @param p12Password 私钥密码
 */
-(void) loadPrivateKeyFromFile: (NSString*) p12FilePath password:(NSString*)p12Password
{
    NSData *p12Data = [NSData dataWithContentsOfFile:p12FilePath];
    [self loadPrivateKeyFromData: p12Data password:p12Password];
}

/**
 *  通过NSData加载私钥
 *
 *  @param p12Data     私钥data
 *  @param p12Password 私钥密码
 */
-(void) loadPrivateKeyFromData: (NSData*) p12Data password:(NSString*)p12Password
{
    privateKey = [self getPrivateKeyRefrenceFromData: p12Data password: p12Password];
}




#pragma mark - Private Methods

/**
 *  （私有方法）从data获取公钥
 *
 *  @param derData data
 *
 *  @return 公钥
 */
-(SecKeyRef) getPublicKeyRefrenceFromeData: (NSData*)derData
{
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)derData);
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) {
        status = SecTrustEvaluate(myTrust, &trustResult);
    }
    SecKeyRef securityKey = SecTrustCopyPublicKey(myTrust);
    CFRelease(myCertificate);
    CFRelease(myPolicy);
    CFRelease(myTrust);
    
    return securityKey;
}


/**
 *  （私有方法）从data获取私钥
 *
 *  @param p12Data data
 *  @param password 密码
 *
 *  @return 私钥
 */
-(SecKeyRef) getPrivateKeyRefrenceFromData: (NSData*)p12Data password:(NSString*)password
{
    SecKeyRef privateKeyRef = NULL;
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject: password forKey:(__bridge id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) p12Data, (__bridge CFDictionaryRef)options, &items);
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
    CFRelease(items);
    
    return privateKeyRef;
}



#pragma mark - Encrypt

/**
 *  字符串加密
 *
 *  @param string 明文
 *
 *  @return 密文（base64防止乱码）
 */
-(NSString*) rsaEncryptString:(NSString*)string
{
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encryptedData = [self rsaEncryptData: data];
    NSString* base64EncryptedString = [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64EncryptedString;
}

// 加密的大小受限于SecKeyEncrypt函数，SecKeyEncrypt要求明文和密钥的长度一致，如果要加密更长的内容，需要把内容按密钥长度分成多份，然后多次调用SecKeyEncrypt来实现
-(NSData*) rsaEncryptData:(NSData*)data
{
    SecKeyRef key = [self getPublicKey];
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(key) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(key,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {//0为成功
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    return ret;
}




#pragma mark - Decrypt

/**
 *  解密字符串
 *
 *  @param string 密文
 *
 *  @return 明文
 */
-(NSString*) rsaDecryptString:(NSString*)string {
    
    NSData* data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData* decryptData = [self rsaDecryptData: data];
    NSString* result = [[NSString alloc] initWithData: decryptData encoding:NSUTF8StringEncoding];
    return result;
}

/**
 *  解密
 *
 *  @param data 密文data
 *
 *  @return  明文data
 */
-(NSData*) rsaDecryptData:(NSData*)data
{
    SecKeyRef key = [self getPrivateKey];
    size_t cipherLen = [data length];
    void *cipher = malloc(cipherLen);
    [data getBytes:cipher length:cipherLen];
    size_t plainLen = SecKeyGetBlockSize(key) - 12;
    void *plain = malloc(plainLen);
    OSStatus status = SecKeyDecrypt(key, kSecPaddingPKCS1, cipher, cipherLen, plain, &plainLen);
    
    if (status != noErr) {
        return nil;
    }
    NSData *decryptedData = [[NSData alloc] initWithBytes:(const void *)plain length:plainLen];
    return decryptedData;
}

#pragma marke - verify file SHA1
/**
 *  验证公钥私钥是否被篡改
 *
 *  @param plainData 公钥
 *  @param signature 私钥
 *
 *  @return 是否被篡改
 */
-(BOOL) rsaSHA1VerifyData:(NSData *) plainData
            withSignature:(NSData *) signature {
    
    size_t signedHashBytesSize = SecKeyGetBlockSize([self getPublicKey]);
    const void* signedHashBytes = [signature bytes];
    
    size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
    uint8_t* hashBytes = malloc(hashBytesSize);
    if (!CC_SHA1([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return NO;
    }
    
    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingPKCS1SHA1,
                                      hashBytes,
                                      hashBytesSize,
                                      signedHashBytes,
                                      signedHashBytesSize);
    
    return status == errSecSuccess;
}

#pragma mark - Class Methods

static RSAEncryptor* sharedInstance = nil;

+(void) setSharedInstance: (RSAEncryptor*)instance
{
    sharedInstance = instance;
}

+(RSAEncryptor*) sharedInstance
{
    return sharedInstance;
}


/**
 *  融宝RSA解密
 *
 *  @param str 密文
 *
 *  @return 明文
 */
+(NSString *)rsaRBDecryptString:(NSString *)str
{
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    //获取融宝私钥
    NSString *privateKeyPath = [[NSBundle mainBundle] pathForResource:@"" ofType:nil];
    [rsa loadPrivateKeyFromFile:privateKeyPath password:@""];
    //解密获取数据密匙
    NSString *key =  [rsa rsaDecryptString:str];
    return key;
}

/**
 *  融宝RSA加密
 *
 *  @param str 明文
 *
 *  @return 密文
 */
+(NSString *)rsaRBEncryptString:(NSString *)str
{
    RSAEncryptor *rsa = [[RSAEncryptor alloc] init];
    //获取融宝公钥
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"" ofType:nil];
    [rsa loadPublicKeyFromFile:publicKeyPath];
    //用融宝公钥对随机生成的秘钥进行加密
    NSString *encryptedString = [rsa rsaEncryptString:str];
    return encryptedString;
}


/**
 *  获取16位随机数字密匙
 *
 *  @return 16位随机数字密匙
 */
+(NSString *)getRandomd16
{
    //随机生成16数字
    NSString *strRandom = @"";
    for(int i=0; i<16; i++)
    {
        strRandom = [ strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    return strRandom;
}








@end
