//
//  NSData+JSON.h
//  MyCode
//
//  Created by 沈佳 on 14-12-3.
//  Copyright (c) 2014年 com.rex.shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (JSON)

/*
    将NSData中的JSON转换成NSDictionary
    解析成功返回包含了JSON数据的NSDictionary，失败则返回nil
 */
-(id) toJSONDictionary;

/*
    根据一个URL字符串创建NSData 对象
 */
+(instancetype) dataWithURLString:(NSString*)urlstring;



@end
