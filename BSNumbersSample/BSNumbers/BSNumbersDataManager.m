//
//  BSNumbersDataManager.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "BSNumbersDataManager.h"
#import "NSObject+BSNumbersExtension.h"
#import "NSString+BSNumbersExtension.h"
@interface BSNumbersDataManager ()

@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *flatData;

- (void)setupFlatData;

- (void)configureFlatData;
- (void)caculateWidths;

@end

@implementation BSNumbersDataManager

#pragma mark - Override


#pragma mark - Private

- (void)setupFlatData {
    NSMutableArray *flatData = @[].mutableCopy;
    if (self.headerData) {
        [flatData addObject:self.headerData];
    }
    if (self.bodyData) {
        for (NSObject *bodyData in self.bodyData) {
            [flatData addObject:[bodyData getPropertiesValues]];
        }
    }
    self.flatData = flatData.copy;
}

- (void)configureFlatData {
    NSMutableArray *freezeCollectionViewFlatData = @[].mutableCopy;
    NSMutableArray *slidingCollectionViewFlatData = @[].mutableCopy;
    
    for (NSInteger i = 0; i < self.flatData.count; i ++) {
        
        NSMutableArray *freezeCollectionViewSectionFlatData = @[].mutableCopy;
        NSMutableArray *slidingCollectionViewSectionFlatData = @[].mutableCopy;
        
        NSArray<NSString *> *flatData = self.flatData[i];
        
        for (NSInteger j = 0; j < flatData.count; j ++) {
            
            NSString *value = flatData[j];
            
            if (j < self.freezeColumn) {
                [freezeCollectionViewSectionFlatData addObject:value];
            } else {
                [slidingCollectionViewSectionFlatData addObject:value];
            }
        }
        [freezeCollectionViewFlatData addObject:freezeCollectionViewSectionFlatData];
        [slidingCollectionViewFlatData addObject:slidingCollectionViewSectionFlatData];
        
    }
    
    if (self.headerData) {
        _headerFreezeCollectionViewFlatData = freezeCollectionViewFlatData.firstObject;
        _headerSlidingCollectionViewFlatData = slidingCollectionViewFlatData.firstObject;
        
        _freezeCollectionViewFlatData = [freezeCollectionViewFlatData subarrayWithRange:NSMakeRange(1, freezeCollectionViewFlatData.count - 1)];
        _slidingCollectionViewFlatData = [slidingCollectionViewFlatData subarrayWithRange:NSMakeRange(1, freezeCollectionViewFlatData.count - 1)];
    } else {
        _freezeCollectionViewFlatData = freezeCollectionViewFlatData.copy;
        _slidingCollectionViewFlatData = slidingCollectionViewFlatData.copy;
    }

}

- (void)caculateWidths {
    NSMutableArray<NSString *> *freezeCollectionViewColumnsItemSize = @[].mutableCopy;
    NSMutableArray<NSString *> *slidingCollectionViewColumnsItemSize = @[].mutableCopy;

    NSInteger columnsCount = self.flatData.firstObject.count;
    
    //遍历列
    for (NSInteger i = 0; i < columnsCount; i ++) {
        
        CGFloat columnMaxWidth = 0;
        
        //遍历行
        for (NSInteger j = 0; j < self.flatData.count; j ++) {
            
            NSString *columnValue = self.flatData[j][i];
            
            CGSize size = [columnValue sizeWithFont:self.bodyFont constraint:CGSizeMake(self.maxItemWidth, self.itemHeight)];
            if (j == 0) {
                size = [columnValue sizeWithFont:self.headerFont constraint:CGSizeMake(self.maxItemWidth, self.itemHeight)];
            }
            
            CGFloat targetWidth = size.width + 2 * self.itemHorizontalMargin;
            
            if (targetWidth >= columnMaxWidth) {
                columnMaxWidth = targetWidth;
            }
            
            columnMaxWidth = MAX(self.minItemWidth, MIN(self.maxItemWidth, columnMaxWidth));
        }
        
        if (i < self.freezeColumn) {
            [freezeCollectionViewColumnsItemSize addObject:NSStringFromCGSize(CGSizeMake(columnMaxWidth, self.itemHeight))];
            _freezeCollectionViewWidth += columnMaxWidth;
        } else {
            [slidingCollectionViewColumnsItemSize addObject:NSStringFromCGSize(CGSizeMake(columnMaxWidth, self.itemHeight))];
            _slidingCollectionViewWidth += columnMaxWidth;
        }
    }
    
    _freezeCollectionViewColumnsItemSize = freezeCollectionViewColumnsItemSize.copy;
    _slidingCollectionViewColumnsItemSize = slidingCollectionViewColumnsItemSize.copy;
}

#pragma mark - Public

- (void)caculate {
    [self configureFlatData];
    [self caculateWidths];
}

#pragma mark - Setter

- (void)setHeaderData:(NSArray<NSString *> *)headerData {
    _headerData = headerData;
    
    [self setupFlatData];
}

- (void)setBodyData:(NSArray<NSObject *> *)bodyData {
    _bodyData = bodyData;
    
    [self setupFlatData];
}

#pragma mark - Getter
@end
