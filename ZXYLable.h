//
//  ZXYLable.h
//  ProjectSecond
//
//  Created by Rockeen on 16/1/5.
//  Copyright © 2016年 gunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXYLable : UIView<UITextViewDelegate>{

    UITextView *_textView;


}

/**
 *文字信息
 */
@property (nonatomic, copy) NSString *text;

/**
 * 文字的属性
 */
@property (nonatomic, strong) NSDictionary *textAttributes;


@end

@interface ZXYTextAttachMent : NSTextAttachment

@end
