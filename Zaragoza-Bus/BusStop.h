//
//  BusStop.h
//  Zaragoza-Bus
//
//  Created by Giasone on 27/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BusStop : NSObject

@property (nonatomic, strong) NSString *busStopId;
@property (nonatomic, strong) NSString *busStopTitle;
@property (nonatomic, strong) NSString *busStopSubTitle;
@property (nonatomic, strong) NSNumber *busStopLat;
@property (nonatomic, strong) NSNumber *busStopLon;
@property (nonatomic, strong) NSString *busStopImageURL;
@property (nonatomic, strong) NSArray  *busStopLines;
@property (nonatomic, strong) NSArray  *busStopEstimates;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
