//
//  DetailsViewController.h
//  Places
//
//  Created by Serban Chiricescu on 09/07/15.
//  Copyright (c) 2015 Qualitance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) GMSPlace *place;
@end
