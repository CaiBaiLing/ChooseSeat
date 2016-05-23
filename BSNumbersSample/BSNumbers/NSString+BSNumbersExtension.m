//
//  NSString+BSNumbersExtension.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "NSString+BSNumbersExtension.h"

@implementation NSString (BSNumbersExtension)

- (CGSize)sizeWithFont:(UIFont *)font constraint:(CGSize)constraint {
    CGSize size;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary *attributes = @{ NSFontAttributeName: font };
    CGRect bounds = [self boundingRectWithSize:constraint options:options attributes:attributes context:nil];
    size = bounds.size;
#else
    size = [self sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
#endif
    return size;
}

@end
