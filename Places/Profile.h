//
//  Profile.h
//  Places
//
//  Created by Serban Chiricescu on 29/06/15.
//  Copyright (c) 2015 Qualitance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Profile : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) UIImage *photo;
@end
