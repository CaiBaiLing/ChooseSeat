//
//  BSNumbersView.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "BSNumbersView.h"
#import "BSNumbersCollectionCell.h"
#import "BSNumbersCollectionFooterView.h"
#import "NSObject+BSNumbersExtension.h"
#import "BSNumbersDataManager.h"

NSString * const CellReuseIdentifer = @"BSNumbersCollectionCell";
NSString * const FooterReuseIdentifer = @"BSNumbersCollectionFooterView";

@interface BSNumbersView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (strong, nonatomic) BSNumbersDataManager *dataManager;

@property (strong, nonatomic) UICollectionView *headerFreezeCollectionView;
@property (strong, nonatomic) UICollectionView *headerSlidingCollectionView;

@property (strong, nonatomic) UICollectionView *freezeCollectionView;
@property (strong, nonatomic) UICollectionView *slidingCollectionView;

@property (strong, nonatomic) UIScrollView *slidingScrollView;

@property (strong, nonatomic) CAShapeLayer *horizontalDivideShadowLayer;
@property (strong, nonatomic) CAShapeLayer *verticalDivideShadowLayer;

- (void)setup;
- (void)setupVars;
- (void)setupViews;

- (void)handleNotification:(NSNotification *)noti;

- (void)updateFrame;

- (void)showHorizontalDivideShadowLayer;
- (void)dismissHorizontalDivideShadowLayer;

- (void)showVerticalDivideShadowLayer;
- (void)dismissVerticalDivideShadowLayer;

- (UICollectionView *)initializeCollectionView;
- (CAShapeLayer *)initializeLayer;

@end

@implementation BSNumbersView
#pragma mark - Override

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateFrame];
}

#pragma mark - Notification

- (void)handleNotification:(NSNotification *)noti {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (orientation != UIDeviceOrientationPortraitUpsideDown) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateFrame];
        }];
    }
    
}

#pragma mark - Private

- (void)setup {
    [self setupVars];
    [self setupViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setupVars {
    self.minItemWidth = 100;
    self.maxItemWidth = 150;
    self.itemHeight = 50;
    self.itemHorizontalMargin = 10;
    self.freezeColumn = 1;
    self.headerFont = [UIFont systemFontOfSize:17];
    self.headerTextColor = [UIColor whiteColor];
    self.headerBackgroundColor = [UIColor grayColor];
    self.bodyFont = self.headerFont;
    self.bodyTextColor = [UIColor blackColor];
    self.bodyBackgroundColor = [UIColor whiteColor];
    self.freezeBodyFont = self.headerFont;
    self.freezeBodyTextColor = [UIColor whiteColor];
    self.freezeBodyBackgroundColor = [UIColor lightGrayColor];
}

- (void)setupViews {
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    [self addSubview:self.headerFreezeCollectionView];
    [self addSubview:self.freezeCollectionView];
    
    [self addSubview:self.slidingScrollView];
    [self.slidingScrollView addSubview:self.headerSlidingCollectionView];
    [self.slidingScrollView addSubview:self.slidingCollectionView];
    
    [self.layer addSublayer:self.horizontalDivideShadowLayer];
    [self.slidingScrollView.layer addSublayer:self.verticalDivideShadowLayer];
}

- (void)updateFrame {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    
    if (self.headerData) {
        CGFloat headerHeight = self.itemHeight + 1;
        
        self.headerFreezeCollectionView.frame = CGRectMake(0,
                                                           0,
                                                           self.dataManager.freezeCollectionViewWidth ,
                                                           headerHeight);
        self.freezeCollectionView.frame = CGRectMake(0,
                                                     headerHeight,
                                                     self.dataManager.freezeCollectionViewWidth,
                                                     height - headerHeight);
        
        self.slidingScrollView.frame = CGRectMake(self.dataManager.freezeCollectionViewWidth,
                                                  0,
                                                  width - self.dataManager.freezeCollectionViewWidth,
                                                  height);
        self.slidingScrollView.contentSize = CGSizeMake(self.dataManager.slidingCollectionViewWidth,
                                                        height);
        
        self.headerSlidingCollectionView.frame = CGRectMake(0,
                                                            0,
                                                            self.dataManager.slidingCollectionViewWidth,
                                                            headerHeight);
        self.slidingCollectionView.frame = CGRectMake(0,
                                                      headerHeight,
                                                      self.dataManager.slidingCollectionViewWidth,
                                                      height - headerHeight);
        
    } else {
        
        self.freezeCollectionView.frame = CGRectMake(0,
                                                     0,
                                                     self.dataManager.freezeCollectionViewWidth,
                                                     height);
        self.slidingScrollView.frame = CGRectMake(self.dataManager.freezeCollectionViewWidth,
                                                  0,
                                                  width - self.dataManager.freezeCollectionViewWidth,
                                                  height);
        self.slidingScrollView.contentSize = CGSizeMake(self.dataManager.slidingCollectionViewWidth,
                                                        height);
        self.slidingCollectionView.frame = CGRectMake(0,
                                                      0,
                                                      self.dataManager.slidingCollectionViewWidth,
                                                      height);
    }

}

- (void)showHorizontalDivideShadowLayer {
    if (self.horizontalDivideShadowLayer.path == nil) {
        CGFloat width = self.bounds.size.width;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.itemHeight)];
        [path addLineToPoint:CGPointMake(width, self.itemHeight)];
        path.lineWidth = 0.5;
        
        self.horizontalDivideShadowLayer.path = path.CGPath;
    }
}

- (void)dismissHorizontalDivideShadowLayer {
    self.horizontalDivideShadowLayer.path = nil;
}

- (void)showVerticalDivideShadowLayer {
    if (self.verticalDivideShadowLayer.path == nil) {
        CGFloat height = self.freezeCollectionView.contentSize.height;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.slidingScrollView.frame.origin.y)];
        [path addLineToPoint:CGPointMake(0, height)];
        path.lineWidth = 0.5;
        
        self.verticalDivideShadowLayer.path = path.CGPath;
    }
}

- (void)dismissVerticalDivideShadowLayer {
    self.verticalDivideShadowLayer.path = nil;
}

#pragma mark - Public

- (void)reloadData {
    [self.dataManager caculate];
    [self updateFrame];
    
    [self.headerFreezeCollectionView reloadData];
    [self.headerSlidingCollectionView reloadData];
    [self.freezeCollectionView reloadData];
    [self.slidingCollectionView reloadData];
}

#pragma mark - Setter

- (void)setMinItemWidth:(CGFloat)minItemWidth {
    _minItemWidth = minItemWidth;
    
    self.dataManager.minItemWidth = minItemWidth;
}

- (void)setMaxItemWidth:(CGFloat)maxItemWidth {
    _maxItemWidth = maxItemWidth;
    
    self.dataManager.maxItemWidth = maxItemWidth;
}

- (void)setFreezeColumn:(NSInteger)freezeColumn {
    _freezeColumn = freezeColumn;
    
    self.dataManager.freezeColumn = freezeColumn;
}

- (void)setItemHeight:(CGFloat)itemHeight {
    _itemHeight = itemHeight;
    
    self.dataManager.itemHeight = itemHeight;
}

- (void)setItemHorizontalMargin:(CGFloat)itemHorizontalMargin {
    _itemHorizontalMargin = itemHorizontalMargin;
    
    self.dataManager.itemHorizontalMargin = itemHorizontalMargin;
}

- (void)setHeaderFont:(UIFont *)headerFont {
    _headerFont = headerFont;
    
    self.dataManager.headerFont = headerFont;
}

- (void)setBodyFont:(UIFont *)bodyFont {
    _bodyFont = bodyFont;
    
    self.dataManager.bodyFont = bodyFont;
}

- (void)setHeaderData:(NSArray<NSString *> *)headerData {
    _headerData = headerData;
    
    self.dataManager.headerData = headerData;
}

- (void)setBodyData:(NSArray<NSObject *> *)bodyData {
    _bodyData = bodyData;
    
    self.dataManager.bodyData = bodyData;
}

#pragma mark - Getter

- (BSNumbersDataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [BSNumbersDataManager new];
    }
    return _dataManager;
}

- (UICollectionView *)headerFreezeCollectionView {
    if (!_headerFreezeCollectionView) {
        _headerFreezeCollectionView = [self initializeCollectionView];
    }
    return _headerFreezeCollectionView;
}

- (UICollectionView *)headerSlidingCollectionView {
    if (!_headerSlidingCollectionView) {
        _headerSlidingCollectionView = [self initializeCollectionView];
    }
    return _headerSlidingCollectionView;
}

- (UICollectionView *)freezeCollectionView {
    if (!_freezeCollectionView) {
        _freezeCollectionView = [self initializeCollectionView];
    }
    return _freezeCollectionView;
}

- (UICollectionView *)slidingCollectionView {
    if (!_slidingCollectionView) {
        _slidingCollectionView = [self initializeCollectionView];
    }
    return _slidingCollectionView;
}

- (UIScrollView *)slidingScrollView {
    if (!_slidingScrollView) {
        _slidingScrollView = [UIScrollView new];
        _slidingScrollView.bounces = NO;
        _slidingScrollView.showsHorizontalScrollIndicator = NO;
        _slidingScrollView.delegate = self;
    }
    return _slidingScrollView;
}

- (CAShapeLayer *)horizontalDivideShadowLayer {
    if (!_horizontalDivideShadowLayer) {
        _horizontalDivideShadowLayer = [self initializeLayer];
        _horizontalDivideShadowLayer.shadowOffset = CGSizeMake(0, 3);
    }
    return _horizontalDivideShadowLayer;
}

- (CAShapeLayer *)verticalDivideShadowLayer {
    if (!_verticalDivideShadowLayer) {
        _verticalDivideShadowLayer = [self initializeLayer];
    }
    return _verticalDivideShadowLayer;
}

#pragma mark - Helper

- (UICollectionView *)initializeCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1);
    
    UICollectionView *c = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    c.dataSource = self;
    c.delegate = self;
    [c registerClass:[BSNumbersCollectionCell class] forCellWithReuseIdentifier:CellReuseIdentifer];
    [c registerClass:[BSNumbersCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterReuseIdentifer];
    c.backgroundColor = [UIColor clearColor];
    c.showsVerticalScrollIndicator = NO;
    c.bounces = NO;
    c.translatesAutoresizingMaskIntoConstraints = NO;
    return c;
}

- (CAShapeLayer *)initializeLayer {
    CAShapeLayer *s = [CAShapeLayer new];
    s.strokeColor = [UIColor lightGrayColor].CGColor;
    s.shadowColor = [UIColor blackColor].CGColor;
    s.shadowOffset = CGSizeMake(2, 0);
    s.shadowOpacity = 1;
    return s;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.headerFreezeCollectionView ||
        collectionView == self.headerSlidingCollectionView) {
        return 1;
    } else {
        return self.bodyData.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (collectionView == self.headerFreezeCollectionView ||
        collectionView == self.freezeCollectionView) {
        return self.freezeColumn;
    } else {
        NSObject *firstBodyData = self.bodyData.firstObject;
        NSInteger slidingColumn = [firstBodyData getPropertiesValues].count - self.freezeColumn;
        return slidingColumn;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BSNumbersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifer forIndexPath:indexPath];
    cell.horizontalMargin = self.itemHorizontalMargin;
    
    if (collectionView == self.headerFreezeCollectionView) {
        
        cell.label.textColor = self.headerTextColor;
        cell.backgroundColor = self.headerBackgroundColor;
        cell.label.font = self.headerFont;
        
        NSString *value = self.dataManager.headerFreezeCollectionViewFlatData[indexPath.row];
        cell.label.text = value;
    } else if (collectionView == self.headerSlidingCollectionView) {
        
        
        cell.label.textColor = self.headerTextColor;
        cell.backgroundColor = self.headerBackgroundColor;
        cell.label.font = self.headerFont;
        
        NSString *value = self.dataManager.headerSlidingCollectionViewFlatData[indexPath.row];
        cell.label.text = value;
    } else if (collectionView == self.freezeCollectionView) {
        
        cell.label.textColor = self.freezeBodyTextColor;
        cell.backgroundColor = self.freezeBodyBackgroundColor;
        cell.label.font = self.freezeBodyFont;
        
        NSString *value = self.dataManager.freezeCollectionViewFlatData[indexPath.section][indexPath.row];
        cell.label.text = value;
    } else {
        cell.label.textColor = self.bodyTextColor;
        cell.backgroundColor = self.bodyBackgroundColor;
        cell.label.font = self.bodyFont;
        
        NSString *value = self.dataManager.slidingCollectionViewFlatData[indexPath.section][indexPath.row];
        cell.label.text = value;
    }
    
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        BSNumbersCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterReuseIdentifer forIndexPath:indexPath];
        
        if (collectionView == self.headerFreezeCollectionView ||
            collectionView == self.headerSlidingCollectionView) {
            footerView.lineStyle = BSNumbersLineStyleReal;
        } else {
            if (indexPath.section != self.bodyData.count - 1) {
                footerView.lineStyle = BSNumbersLineStyleDotted;
            } else {
                footerView.lineStyle = BSNumbersLineStyleReal;
            }
        }
        return footerView;
    } else {
        return nil;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bodyData.count == 0) {
        return CGSizeZero;
    } else {
        if (collectionView == self.headerFreezeCollectionView ||
            collectionView == self.freezeCollectionView) {
            return CGSizeFromString(self.dataManager.freezeCollectionViewColumnsItemSize[indexPath.row]);
        } else {
            return CGSizeFromString(self.dataManager.slidingCollectionViewColumnsItemSize[indexPath.row]);
        }
    }
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.slidingScrollView) {
        [self.freezeCollectionView setContentOffset:scrollView.contentOffset];
        [self.slidingCollectionView setContentOffset:scrollView.contentOffset];
        
        if (scrollView.contentOffset.y > 0) {
            [self showHorizontalDivideShadowLayer];
        } else {
            [self dismissHorizontalDivideShadowLayer];
        }
        
    } else {
        if (scrollView.contentOffset.x > 0) {
            [self showVerticalDivideShadowLayer];
        } else {
            [self dismissVerticalDivideShadowLayer];
        }
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.verticalDivideShadowLayer.transform = CATransform3DMakeTranslation(scrollView.contentOffset.x, 0, 0);
        [CATransaction commit];
        
    }
}

@end
