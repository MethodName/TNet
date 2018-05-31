//
//  TMMAppDelegate.h
//  TNet
//
//  Created by methodname@qq.com on 05/30/2018.
//  Copyright (c) 2018 methodname@qq.com. All rights reserved.
//

@import UIKit;
#import "TMMSecurity.h"

@interface TMMAppDelegate : UIResponder <UIApplicationDelegate,TMMSecurityDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
