//
//  TMMViewController.m
//  TNet
//
//  Created by methodname@qq.com on 05/30/2018.
//  Copyright (c) 2018 methodname@qq.com. All rights reserved.
//

#import "TMMViewController.h"
#import "TMMAFNSecurityRequest.h"

@interface TMMViewController ()

@end

@implementation TMMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults]setObject:@"2017012641" forKey:@"_UserDefaultKeyToken"];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSNumber numberWithInteger:0] forKey:@"current"];
    [param setObject:[NSNumber numberWithInteger:10] forKey:@"psize"];
    [param setObject:[NSNumber numberWithUnsignedInteger:1] forKey:@"btype"];
    
    [TMMAFNSecurityRequest reqSecurityPOST:@"http://192.168.1.252:889/api/invest/blist"
                                parameters:param
                                completion:^(TMMResponse *response) {
                                    NSLog(@"%@",response.data);
    } error:^(NSError *error) {
        
    }];
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
