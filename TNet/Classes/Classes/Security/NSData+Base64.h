//
//  NSData+NSData_Base64.h
//  HaoShiDai
//
//  Created by 唐明明 on 16/3/23.
//  Copyright © 2016年 360haoshidai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+ (id) dataWithBase64Encoding_xcd:(NSString *)base64String;
- (NSString *) base64Encoding_xcd;

@end
