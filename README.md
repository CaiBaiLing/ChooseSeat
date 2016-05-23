# BSNumbers

## Overview

if the view did not add constraints, you need to rotate the view manually when screen's orientation changed.

![BSNumbersGIF.gif](http://upload-images.jianshu.io/upload_images/1835360-2b199d749d193cff.gif?imageMogr2/auto-orient/strip)

## Installation

> pod 'BSNumbers', '~> 0.0.4'

## Usage

### Supple an array with models as datasource

```objective-c
NSArray<NSDictionary *> *flightsInfo = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flightsInfo" ofType:@"plist"]];
NSMutableArray<Flight *> *flights = @[].mutableCopy;
for (NSDictionary *flightInfo in flightsInfo) {
    Flight *flight = [[Flight alloc]initWithDictionary:flightInfo];
    [flights addObject:flight];
}
```
    
### This is the model: Flight
```objective-c
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
```
###Set the datasource and the other optional attribute
```objective-c
self.numbersView.bodyData = flights;
```
######optional attribute
```objective-c
self.numbersView.headerData = @[@"Flight Company", @"Flight Number", @"Type Of Aircraft", @"Date", @"Place Of Departure", @"Place Of Destination", @"Departure Time", @"Arrive Time", @"Price"];
self.numbersView.freezeColumn = 1;
self.numbersView.bodyFont = [UIFont systemFontOfSize:14];
```
###Display
```objective-c
[self.numbersView reloadData];
```
