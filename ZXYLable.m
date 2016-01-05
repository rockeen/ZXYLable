//
//  ZXYLable.m
//  ProjectSecond
//
//  Created by Rockeen on 16/1/5.
//  Copyright © 2016年 gunmm. All rights reserved.
//

#import "ZXYLable.h"

@implementation ZXYLable{

    NSMutableDictionary *_iconDic;


}


/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createTextView];
        self.backgroundColor=[UIColor clearColor];
        
        _textView.textColor=[UIColor blackColor];
        
        [self loadIconDic];
        
    }
    return self;
}


/**
 * 解析数据
 */
- (void)loadIconDic{

    NSString *path=[[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];

    NSArray *arr=[NSArray arrayWithContentsOfFile:path];
    
    _iconDic=[NSMutableDictionary dictionary];
    
    for (NSDictionary *dic in arr) {
        
        NSString *imgNameKey=[dic objectForKey:@"chs"];
        
        NSString *imgNameValue=[dic objectForKey:@"png"];
        
        [_iconDic setValue:imgNameValue forKey:imgNameKey];
        
    }

}



/**
 *创建textView
 */
- (void)createTextView{


    _textView=[[UITextView alloc]initWithFrame:self.bounds];
    
    _textView.scrollEnabled=NO;
    
    _textView.editable=NO;
    
    _textView.delegate=self;
    
    _textView.backgroundColor=[UIColor clearColor];
    
    [self addSubview:_textView];
    


}

/**
 * text内容的set方法
 */
- (void)setText:(NSString *)text{
    
    
    _text=[text copy];
    
    [self loadAttributedString];
    
    
}

/**
 *计算高度
 */
- (void)loadAttributedString{

    //富文本字符串
    NSMutableAttributedString *arr;
    
    if (self.textAttributes) {
        
        arr=[[NSMutableAttributedString alloc]initWithString:_text attributes:self.textAttributes];
    }else{
    
    
        arr=[[NSMutableAttributedString alloc]initWithString:_text];
    
    
    }
    
    
    //图文混排
    [self praseString:arr];
    
    [self height:arr];
    
    
    //计算高度
    _textView.attributedText=arr;
    
    self.height=_textView.height;



}

//实现图文混排
- (void)praseString:(NSMutableAttributedString *)arr{

   NSArray *ranges=[self rangeOfString:@"\\[\\w{1,5}\\]"];
   
    for (int i=(int)ranges.count-1; i>=0; i--) {
        
        NSRange range=[ranges[i]rangeValue];
        
        NSString *substr=[_text substringWithRange:range];
        
        NSString *iconName=[_iconDic objectForKey:substr];
        
        ZXYTextAttachMent *attachment=[[ZXYTextAttachMent alloc]init];
        
        attachment.image=[UIImage imageNamed:iconName];
        
        if (iconName) {
            
            [arr deleteCharactersInRange:range];
            
            
        }
        
        NSAttributedString *insertStr=[NSAttributedString attributedStringWithAttachment:attachment];
        
        [arr insertAttributedString:insertStr atIndex:range.location];
        
    }





}

//查找符合要求的字符串 并且返回一组range范围
-(NSArray *)rangeOfString:(NSString *)str
{
    //将传入的字符串初始化为正则表达式对象
    NSRegularExpression *reguler = [[NSRegularExpression alloc] initWithPattern:str options:NSRegularExpressionCaseInsensitive error:nil];
    
    //通过正则表达式到字符串中匹配正确对象
    NSArray *results = [reguler matchesInString:self.text options:NSMatchingReportProgress range:NSMakeRange(0, self.text.length)];
    
    NSMutableArray *ranges = [NSMutableArray array];
    
    //遍历匹配结果 获取range并放入新的数组
    for (NSTextCheckingResult *result in results) {
        //获取到匹配字符串的range范围
        NSRange range = result.range;
        
        //将range转化为oc对象  目的：放入数组中
        NSValue *value = [NSValue valueWithRange:range];
        
        [ranges addObject:value];
        
    }
    
    //返回数组
    return ranges;
}

- (void)height:(NSMutableAttributedString *)arr{

    CGRect frame=[arr boundingRectWithSize:CGSizeMake(_textView.bounds.size.width, 999.f) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGRect textFrame=_textView.frame;
    
    textFrame.size.height=frame.size.height+20;
    
    _textView.frame=textFrame;




}


@end

@implementation ZXYTextAttachMent

//修改图像文本的大小
-(CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake(0, 0, lineFrag.size.height, lineFrag.size.height);
}


@end

