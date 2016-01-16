//
//  DataRequest.m
//  FM
//
//  Created by lanou3g on 15/11/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "DataRequest.h"

@implementation DataRequest

+ (void)GetListData:(NSString *)stringURL block:(void(^)(NSData *))block{
        
        NSURL *url = [NSURL URLWithString:stringURL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            //子线程
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (data) {
                    // 主线程返回数据
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (block) {
                            block(data);
                        }
                    });
                }
            });
        }];
    
        [dataTask resume];
}


@end
