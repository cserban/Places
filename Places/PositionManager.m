//
//  PositionManager.m
//  Places
//
//  Created by Serban Chiricescu on 09/07/15.
//  Copyright (c) 2015 Qualitance. All rights reserved.
//

#import "PositionManager.h"

@interface PositionManager()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation PositionManager

+ (PositionManager*)sharedInstance
{
    static PositionManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PositionManager alloc] init];
    });
    return _sharedInstance;
}

-(void)requestLocation
{
    if (!_locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
    }
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_locationManager stopUpdatingLocation];
    [_delegate myPosition:[locations lastObject]];
}
@end
