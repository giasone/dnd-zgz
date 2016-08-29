//
//  BusStopLoader.m
//  Zaragoza-Bus
//
//  Created by Giasone on 28/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import "BusStopLoader.h"
#import "BusStop.h"
#import "Configuration.h"

@implementation BusStopLoader

- (id)initWithCallback:(BusStopLoaderCallback)block {
    if (self = [super init])
        self.callbackBlock = block;
    return self;
}

- (void)loadBusStops {
    NSURL *requestURL = [NSURL URLWithString:WS_BUS_ALL_URL];
    
    NSURLSessionConfiguration *session = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:session];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *sessionDataTask = [urlSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              
                                                              if (data && data.length > 0) {
                                                                  NSError *jsonError = nil;
                                                                  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                             options:NSJSONReadingMutableLeaves
                                                                                                                               error:&jsonError];
                                                                  
                                                                  if (!jsonObject) {
                                                                      self.callbackBlock(jsonError);
                                                                  } else {
                                                                      NSMutableArray *busSortedList = [NSMutableArray arrayWithArray:[jsonObject objectForKey:@"locations"]];
                                                                      [busSortedList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]]];
                                                                      NSMutableArray *reponseObjects = [NSMutableArray arrayWithCapacity:[busSortedList count]];
                                                                      for (int i=0; i<[busSortedList count]; i++) {
                                                                          [reponseObjects addObject:[[BusStop alloc] initWithDictionary:[busSortedList objectAtIndex:i]]];
                                                                      }
                                                                      
                                                                      self.callbackBlock([reponseObjects copy]);
                                                                  }
                                                              }
                                                          }];
    
    [sessionDataTask resume];
}


- (void)loadBusStopInfo:(NSString *)busId {
    
    NSString * url = [NSString stringWithFormat:WS_BUS_DETAILS_URL, busId];
    NSURL *requestURL = [NSURL URLWithString:url];
    
    NSURLSessionConfiguration *session = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:session];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *sessionDataTask = [urlSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              
                                                              if (data && data.length > 0) {
                                                                  NSError *jsonError = nil;
                                                                  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                             options:NSJSONReadingMutableLeaves
                                                                                                                               error:&jsonError];
                                                                  
                                                                  if (!jsonObject) {
                                                                      self.callbackBlock(jsonError);
                                                                  } else {
                                                                      NSMutableArray *estimatesSortedList = [NSMutableArray arrayWithArray:[jsonObject objectForKey:@"estimates"]];
                                                                      [estimatesSortedList sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"estimate" ascending:YES]]];
                                                                      self.callbackBlock(estimatesSortedList);
                                                                  }
                                                              }
                                                          }];
    
    [sessionDataTask resume];
}

@end
