//
//  BusStop.m
//  Zaragoza-Bus
//
//  Created by Giasone on 27/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import "BusStop.h"
#import "Configuration.h"

@implementation BusStop


@synthesize busStopId;
@synthesize busStopTitle;
@synthesize busStopSubTitle;
@synthesize busStopLat;
@synthesize busStopLon;
@synthesize busStopImageURL;
@synthesize busStopLines;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.busStopId = dictionary[@"id"];
        self.busStopTitle = [NSString stringWithFormat:@"%@ - %@", dictionary[@"id"], dictionary[@"title"]];
        NSString *subtitle = [dictionary[@"subtitle"] stringByReplacingOccurrencesOfString:@","
                                                                               withString:@" -"];
        NSString * busId = [NSString stringWithFormat:@"(%@) ", dictionary[@"id"]];
        subtitle = [subtitle stringByReplacingOccurrencesOfString:busId
                                                       withString:@""];
        self.busStopSubTitle = subtitle;
        self.busStopLat = dictionary[@"lat"];
        self.busStopLon = dictionary[@"lon"];
        self.busStopImageURL = [NSString stringWithFormat:MAP_IMAGE_URL, MAP_IMAGE_ZOOM, MAP_IMAGE_SIZE, dictionary[@"lat"], dictionary[@"lon"]];
        self.busStopLines = dictionary[@"lines"];
    }
    return self;
}

@end
