//
//  NSObject+BindProperty.m
//  MyCode
//
//  Created by 沈佳 on 14-12-3.
//  Copyright (c) 2014年 com.rex.shen. All rights reserved.
//

#import "NSObject+BindProperty.h"
#import <objc/runtime.h> 

@implementation NSObject (BindProperty)

- (NSMutableArray*)propertyKeys

{
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [keys addObject:propertyName];
        
    }
    
    free(properties);

    return keys;
    
}

- (NSDictionary*) toDictionary
{
    NSArray *keys = [self propertyKeys];
    if (keys) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:keys.count];
        for (NSString *key in keys) {
            [dic setObject:[self valueForKey:key] forKey:key];
        }
        return dic;
    }
    return nil;
}


- (BOOL)reflectDataFromDictionary:(NSDictionary*)dataSource

{
    
    BOOL ret = NO;
 
    for (NSString *key in [self propertyKeys]) {
        
        ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        
        if (ret) {
            
            id propertyValue = [dataSource valueForKey:key];
//            nil：指向oc中对象的空指针
//            Nil：指向oc中类的空指针
//            NULL：指向其他类型的空指针，如一个c类型的内存指针
//            NSNull：在集合对象中，表示空值的对
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil&& propertyValue!=Nil&& propertyValue!=NULL) {
                
                [self setValue:propertyValue forKey:key];
                
            }           
            
        }
        
    }
    
    return ret;
    
}

@end
