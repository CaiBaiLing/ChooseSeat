//
//  BSNumbersView.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSNumbersView : UIView

///min width for each square
@property (assign, nonatomic) CGFloat minItemWidth;

///max width for each square
@property (assign, nonatomic) CGFloat maxItemWidth;

///height for each square
@property (assign, nonatomic) CGFloat itemHeight;

///horizontal margin for each square
@property (assign, nonatomic) CGFloat itemHorizontalMargin;

///the column need to freeze
@property (assign, nonatomic) NSInteger freezeColumn;

///header font
@property (strong, nonatomic) UIFont *headerFont;

///header text color
@property (strong, nonatomic) UIColor *headerTextColor;

///header background color
@property (strong, nonatomic) UIColor *headerBackgroundColor;

///body font
@property (strong, nonatomic) UIFont *bodyFont;

///body text color
@property (strong, nonatomic) UIColor *bodyTextColor;

///body background color
@property (strong, nonatomic) UIColor *bodyBackgroundColor;

///body font
@property (strong, nonatomic) UIFont *freezeBodyFont;

///body text color
@property (strong, nonatomic) UIColor *freezeBodyTextColor;

///body background color
@property (strong, nonatomic) UIColor *freezeBodyBackgroundColor;

///data

@property (strong, nonatomic) NSArray<NSString *> *headerData;
@property (strong, nonatomic) NSArray<NSObject *> *bodyData;

- (void)reloadData;

@end
