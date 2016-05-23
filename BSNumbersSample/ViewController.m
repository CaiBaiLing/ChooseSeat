//
//  ViewController.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "ViewController.h"
#import "Flight.h"
#import "BSNumbersView.h"
#import "NSObject+BSNumbersExtension.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet BSNumbersView *numbersView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"航班信息";
    
    NSArray<NSDictionary *> *flightsInfo = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flightsInfo" ofType:@"plist"]];
    
    NSMutableArray<Flight *> *flights = @[].mutableCopy;
    for (NSDictionary *flightInfo in flightsInfo) {
        Flight *flight = [[Flight alloc]initWithDictionary:flightInfo];
        [flights addObject:flight];
    }
    
    
    self.numbersView.bodyData = flights;
    
    self.numbersView.headerData = @[@"Flight Company", @"Flight Number", @"Type Of Aircraft", @"Date", @"Place Of Departure", @"Place Of Destination", @"Departure Time", @"Arrive Time", @"Price"];
    self.numbersView.freezeColumn = 1;
    self.numbersView.bodyFont = [UIFont systemFontOfSize:14];
    
    [self.numbersView reloadData];
}


@end
