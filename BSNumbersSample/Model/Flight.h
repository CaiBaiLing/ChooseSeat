//
//  Flight.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flight : NSObject

@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *typeOfAircraft;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *placeOfDeparture;
@property (strong, nonatomic) NSString *placeOfDestination;
@property (strong, nonatomic) NSString *departureTime;
@property (strong, nonatomic) NSString *arriveTime;
@property (strong, nonatomic) NSString *price;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
