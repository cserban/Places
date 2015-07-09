//
//  PositionManager.h
//  Places
//
//  Created by Serban Chiricescu on 09/07/15.
//  Copyright (c) 2015 Qualitance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol PositionProtocol;

@interface PositionManager : NSObject <CLLocationManagerDelegate>
+ (PositionManager *)sharedInstance;
-(void)requestLocation;
@property (strong, nonatomic) id<PositionProtocol> delegate;
@end

@protocol PositionProtocol
-(void)myPosition:(CLLocation *)currentLocation;
@end