//
//  DataDetailRequest.m
//  FM
//
//  Created by lanou3g on 15/11/26.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "DataDetailRequest.h"

@implementation DataDetailRequest

+ (void)GetDetailData:(NSString *)stringURL block:(void(^)(NSData *, NSInteger))block {
    
        
        
        NSURL *url = [NSURL URLWithString:stringURL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
    
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if (data) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:0  ];
                    NSInteger page =[[dic valueForKey:@"maxPageId"] intValue];// 获取解析数据页
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (block) {
                            block(data,page);
                        }
                    });
                }
            });
        }];
        [dataTask resume];
}


@end
