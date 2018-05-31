//
//  HSDSecurity.m
//  HaoShiDai
//
//  Created by methodname on 14-12-9.
//  Copyright (c) 2014年 shenjia. All rights reserved.
//

#import "TMMSecurity.h"
#import "NSData+AES256.h"
#import "NSString+MD5.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "RSA.h"


#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]


/**
 *      1、通信加密：
          密匙  密匙明文+MD5
          加密方式1：AES256
          加密方式2：Base64
 *
        2、ID加密
        密匙：明文
        加密方式：DES
 *
 */
@implementation TMMSecurity


static TMMSecurity * _standardSecurity;

+(instancetype)standardSecurity
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _standardSecurity = [TMMSecurity new];
    });
    return _standardSecurity;
}




/**
 *  AES256加密
 *
 *  @param str 明文
 *
 *  @return 密文
 */
-(NSString *) AES256EncryptWithString:(NSString *) str
{
    NSAssert([TMMSecurity standardSecurity].delegate != nil, @"standardSecurity没有delegate对象，无法获取加密的密钥！");
    NSData *dt1 = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dt2 = [dt1 AES256EncryptWithKey:[[TMMSecurity standardSecurity].delegate.AES256Key MD5]];
    NSString *str2 = [dt2 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return str2;
}

/**
 *  AES加密
 *
 *  @param str 加密内容
 *  @param key 密匙
 *
 *  @return 密文
 */
-(NSString *) AES256EncryptWithString:(NSString *) str Key:(NSString *)key
{
    NSData *dt1 = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dt2 = [dt1 AES256EncryptWithKey2:key];
    NSString *str2 = [GTMBase64 stringByEncodingData:dt2];
    return str2;
}







/**
 *  AES解密
 *
 *  @param str 密文
 *  @param key 密匙
 *
 *  @return 原文
 */
-(NSString *) AES256DecryptWithString:(NSString *) str Key:(NSString *)key
{
    NSData *dt3 = [GTMBase64 decodeString:str Encoding:NSUTF8StringEncoding];
    NSData *dt4 = [dt3 AES256DecryptWithKey2: key];
    NSString *str4 = [[NSString alloc] initWithData:dt4 encoding:NSUTF8StringEncoding];
    return str4;
}








/**
 *  AES解密
 *
 *  @param str  密文
 *
 *  @return 明文
 */
-(NSString *) AES256DecryptWithString:(NSString *) str
{
    NSAssert([TMMSecurity standardSecurity].delegate != nil, @"standardSecurity没有delegate对象，无法获取加密的密钥！");
    NSData *dt3 = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *dt4 = [dt3 AES256DecryptWithKey:[[TMMSecurity standardSecurity].delegate.AES256Key MD5]];
    NSString *str4 = [[NSString alloc] initWithData:dt4 encoding:NSUTF8StringEncoding];
    return str4;
}




#pragma mark -=============================【C#，iOS，安卓通用加密】DES=============================


/**
 *  DES加密
 *
 *  @param text 明文
 *
 *  @return 密文
 */
+ (NSString *)DESEncrypt:(NSString *)text
{
    NSAssert([TMMSecurity standardSecurity].delegate != nil, @"standardSecurity没有delegate对象，无法获取加密的密钥！");
    return [TMMSecurity encryptWithContent:text type:kCCEncrypt key:[TMMSecurity standardSecurity].delegate.DECKey];
}


/**
 *  DES解密
 *
 *  @param text 密文
 *
 *  @return 明文
 */
+ (NSString *)DESDecrypt:(NSString *)text
{
    NSAssert([TMMSecurity standardSecurity].delegate != nil, @"standardSecurity没有delegate对象，无法获取加密的密钥！");
    return [TMMSecurity encryptWithContent:text type:kCCDecrypt key:[TMMSecurity standardSecurity].delegate.DECKey];
}







/**
 *  DES加密解密
 *
 *  @param content 加解密内容
 *  @param type    加/解密
 *  @param aKey    密匙
 *
 *  @return 加/解密后的内容
 */
+(NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey
{
    const char * contentChar =[content UTF8String];
    char * keyChar =(char*)[aKey UTF8String];
    const char *miChar;
    miChar = encryptWithKeyAndType(contentChar, type, keyChar);
    return [NSString stringWithCString:miChar encoding:NSUTF8StringEncoding];
}





/**
 *  DES加密解密
 *
 *  @param text             需要加/解密的内容
 *  @param encryptOperation 加/解密
 *  @param key              密匙
 *
 *  @return 加/解密后的内容
 */
static const char* encryptWithKeyAndType(const char *text,CCOperation encryptOperation,char *key)
{
    NSString *textString=[[NSString alloc]initWithCString:text encoding:NSUTF8StringEncoding];
    const void *dataIn;//
    size_t dataInLength;
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64   //   !!!!!!!!!!!!!!!!!-------->【解密进行了Base64字符串处理】，加密时使用，如要使用，去除Base64即可
        NSData *decryptData = [GTMBase64 decodeData:[textString dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
     }
    else //encrypt
     {
         NSData* encryptData = [textString dataUsingEncoding:NSUTF8StringEncoding];
         dataInLength = [encryptData length];
         dataIn = (const void *)[encryptData bytes];
     }


     CCCryptorStatus ccStatus;
     uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
     size_t dataOutAvailable = 0; //size_t 是操作符sizeof返回的结果类型
     size_t dataOutMoved = 0;

     dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
     dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
     memset((void *)dataOut, 00, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
     const void *vkey = key;
    const void *iv = (const void *) key; //[initIv UTF8String];

    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,// 加密/解密
                kCCAlgorithmDES,// 加密根据哪个标准（des，3des，aes。。。。）
                kCCOptionPKCS7Padding,// 选项分组密码算法(des:对每块分组加一次密 3DES：对每块分组加三个不同的密)
                vkey, //密钥 加密和解密的密钥必须一致
                kCCKeySizeDES,// DES 密钥的大小（kCCKeySizeDES=8）
                iv, // 可选的初始矢量
                dataIn, // 数据的存储单元
                dataInLength,// 数据的大小
                (void *)dataOut,// 用于返回数据
                dataOutAvailable,
                &dataOutMoved);

     NSString *result = nil;

     if (encryptOperation == kCCDecrypt)//encryptOperation==1 解码
     {
                 //得到解密出来的data数据，改变为utf-8的字符串
         result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
     else //encryptOperation==0 （加密过程中，把加好密的数据转成base64的）
     {
         //编码 base64
         NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
         result = [TMMSecurity stringWithHexBytes2:data];
     }
 
    return [result UTF8String];
}






#pragma mark -=============================【字符串，字节数组转换】=============================
/**
 *  NSData转成16进制字符串
 *
 *  @param sender  NSData
 *
 *  @return 16进制字符串
 */
+ (NSString*)stringWithHexBytes2:(NSData *)sender {
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    
    free(strbuf);
    return hexBytes;
}


/**
 *  将16进制数据转化成NSData 数组
 *
 *  @param hexString 16进制字符串
 *
 *  @return NSData
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}


/**
 *  将字节*类型转换为字符串
 *
 *  @param bytes  字节*
 *
 *  @return 字符串
 */
+(NSString *) parseByte2HexString:(Byte *) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return hexStr;
}

/**
 *  将字节数组转换为字符串
 *
 *  @param bytes 字节数组
 *
 *  @return 字符串
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    int i = 0;
    if(bytes)
    {
        while (bytes[i] != '\0')
        {
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                [hexStr appendFormat:@"0%@", hexByte];
            else
                [hexStr appendFormat:@"%@", hexByte];
            
            i++;
        }
    }
    return [hexStr uppercaseString];
}












/**
 *  去除NSData中的非UTF-8内容
 *
 *  @param data 数据
 *
 *  @return 去除后的数据
 */
+ (NSData *)replaceNoUtf8:(NSData *)data
{
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}






#pragma mark -=============================【DES加密1】=============================

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSData *dt =[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return dt;
    }
    
    free(buffer);
    return nil;
}



/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}



#pragma mark -=============================【DES加密2】=============================

/******************************************************************************
 函数描述 : 文本数据进行DES加密
 ******************************************************************************/
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void * buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCBlockSizeDES,
                                          NULL,
                                          [textData bytes]  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES加密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self stringWithHexBytes2:data];
        
    }else{
        NSLog(@"DES加密失败");
    }
    
    free(buffer);
    return ciphertext;
}

/******************************************************************************
 函数描述 : 文本数据进行DES解密
 ******************************************************************************/
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *cleartext = nil;
    NSData *textData = [self parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes]  , dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"DES解密失败");
    }
    
    free(buffer);
    return cleartext;
}




- (NSData *)UTF8Data:(NSData *)data
{
    //保存结果
    NSMutableData *resData = [[NSMutableData alloc] initWithCapacity:data.length];
    
    //无效编码替代符号(常见 � □ ?)
    NSData *replacement = [@"�" dataUsingEncoding:NSUTF8StringEncoding];
    
    uint64_t index = 0;
    const uint8_t *bytes = data.bytes;
    
    while (index < data.length)
    {
        uint8_t len = 0;
        uint8_t header = bytes[index];
        
        //单字节
        if ((header&0x80) == 0)
        {
            len = 1;
        }
        //2字节(并且不能为C0,C1)
        else if ((header&0xE0) == 0xC0)
        {
            if (header != 0xC0 && header != 0xC1)
            {
                len = 2;
            }
        }
        //3字节
        else if((header&0xF0) == 0xE0)
        {
            len = 3;
        }
        //4字节(并且不能为F5,F6,F7)
        else if ((header&0xF8) == 0xF0)
        {
            if (header != 0xF5 && header != 0xF6 && header != 0xF7)
            {
                len = 4;
            }
        }
        
        //无法识别
        if (len == 0)
        {
            [resData appendData:replacement];
            index++;
            continue;
        }
        
        //检测有效的数据长度(后面还有多少个10xxxxxx这样的字节)
        uint8_t validLen = 1;
        while (validLen < len && index+validLen < data.length)
        {
            if ((bytes[index+validLen] & 0xC0) != 0x80)
                break;
            validLen++;
        }
        
        //有效字节等于编码要求的字节数表示合法,否则不合法
        if (validLen == len)
        {
            [resData appendBytes:bytes+index length:len];
        }else
        {
            [resData appendData:replacement];
        }
        
        //移动下标
        index += validLen;
    }
    
    return resData;
}


- (NSData *)replaceNoUtf8:(NSData *)data
{
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}








@end


