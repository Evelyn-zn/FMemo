//
//  DataDetailRequest.h
//  FM
//
//  Created by lanou3g on 15/11/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDetailRequest : NSObject

+ (void)GetDetailData:(NSString *)stringURL block:(void(^)(NSData *, NSInteger))block;

@end
