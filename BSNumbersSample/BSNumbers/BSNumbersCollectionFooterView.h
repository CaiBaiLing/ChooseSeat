//
//  BSNumbersCollectionFooterView.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/7.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BSNumbersLineStyle) {
    BSNumbersLineStyleNone,
    BSNumbersLineStyleReal,
    BSNumbersLineStyleDotted
};

@interface BSNumbersCollectionFooterView : UICollectionReusableView

@property (assign, nonatomic) BSNumbersLineStyle lineStyle;

@end
