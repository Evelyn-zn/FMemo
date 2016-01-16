//
//  AppDelegate.h
//  FM
//
//  Created by lanou3g on 15/11/25.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) Reachability *hostReach;
@property (assign,nonatomic) BOOL isReachable;

@end

