//
//  BSNumbersCollectionFooterView.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/7.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "BSNumbersCollectionFooterView.h"

@interface BSNumbersCollectionFooterView ()

@property (strong, nonatomic) CAShapeLayer *lineLayer;

@end

@implementation BSNumbersCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.lineLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.bounds.size.height/2)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height/2)];
    path.lineWidth = 1;
    
    self.lineLayer.path = path.CGPath;
    
}

- (void)setLineStyle:(BSNumbersLineStyle)lineStyle {
    _lineStyle = lineStyle;
    
    if (lineStyle == BSNumbersLineStyleNone) {
        return;
    }
    
    [self layoutIfNeeded];
    
    if (lineStyle == BSNumbersLineStyleDotted) {
        [self.lineLayer setLineDashPattern:@[@2]];
    } else {
        [self.lineLayer setLineDashPattern:nil];
    }
    
}

- (CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    }
    return _lineLayer;
}

@end
