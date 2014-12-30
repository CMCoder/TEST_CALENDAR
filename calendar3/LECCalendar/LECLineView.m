//
//  LECLineView.m
//  calendar2
//
//  Created by 唐嘉一 on 14/12/23.
//  Copyright (c) 2014年 LEC. All rights reserved.
//

#import "LECLineView.h"

@implementation LECLineView

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor whiteColor];
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    rect = CGRectInset(rect, 2, 0);
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //指定直线样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context, rect.size.height/2);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    
    //开始绘制
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.origin.x, 1);
    CGContextAddLineToPoint(context, rect.size.width, 1);
    CGContextStrokePath(context);
    
    //画image
//    UIGraphicsPushContext(context);
//    rect = CGRectInset(rect, 1, 1);
//    [self.image drawInRect:rect];
//    UIGraphicsPopContext();
}

- (void)setColor:(UIColor *)color
{
    self->_color = color;
    
    [self setNeedsDisplay];
}

@end
