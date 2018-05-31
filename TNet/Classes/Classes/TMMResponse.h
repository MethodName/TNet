//
//  TMMResponse.h
//  TNet
//
//  Created by 唐明明 on 2018/5/31.
//

#import <Foundation/Foundation.h>

@interface TMMResponse : NSObject

/**
 *  响应状态
 */
@property (nonatomic,strong) NSString* status;
/**
 *  消息
 */
@property (nonatomic,strong) NSString* message;
/**
 *  数据
 */
@property (nonatomic,strong) id data;


@end
