//
//  BusStopLoader.h
//  Zaragoza-Bus
//
//  Created by Giasone on 28/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BusStopLoaderCallback)(id);

@interface BusStopLoader : NSObject

@property (nonatomic, copy) BusStopLoaderCallback callbackBlock;

- (id)initWithCallback:(BusStopLoaderCallback)block;

- (void)loadBusStops;
- (void)loadBusStopInfo:(NSString *)busId;

@end
