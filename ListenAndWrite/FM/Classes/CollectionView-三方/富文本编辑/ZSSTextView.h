//
//  ZSSTextView.h
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 1/29/14.
//  Copyright (c) 2014 Zed Said Studio. All rights reserved.
//

#import "CYRTextView.h"

@interface ZSSTextView : CYRTextView

@property (nonatomic, strong) UIFont *defaultFont;
@property (nonatomic, strong) UIFont *boldFont; // 黑体
@property (nonatomic, strong) UIFont *italicFont; // 斜体字

@end
