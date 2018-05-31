//
//  NSString+JSON.h
//  HaoShiDai
//
//  Created by 唐明明 on 16/3/28.
//  Copyright © 2016年 360haoshidai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

/*
 *  将JSON字符串转成字典
 *
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */

- (NSDictionary *)dictionary;


/**
 *  将字典转成JSON字符串
 *
 *  @param dic 字典
 *
 *  @return JSON字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;


@end
