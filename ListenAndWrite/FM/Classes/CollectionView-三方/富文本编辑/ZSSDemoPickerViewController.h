//
//  ZSSDemoPickerViewController.h
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 1/30/14.
//  Copyright (c) 2014 Zed Said Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextZSSRichTextEditor.h"
@interface ZSSDemoPickerViewController : UIViewController

@property (strong,nonatomic) TextZSSRichTextEditor *demoView;
@property (nonatomic) BOOL isInsertImagePicker;

@end
