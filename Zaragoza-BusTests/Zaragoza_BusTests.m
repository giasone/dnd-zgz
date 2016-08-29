//
//  Zaragoza_BusTests.m
//  Zaragoza-BusTests
//
//  Created by Giasone on 27/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BusStop.h"
#import "BusStopCustomCell.h"
#import "BusStopLoader.h"
#import "MasterViewController.h"
#import "UIImageView+AFNetworking.h"

@interface Zaragoza_BusTests : XCTestCase

@property (nonatomic, strong) MasterViewController *vc;
@property (nonatomic, strong) NSDictionary *dictionaryName;

@end

@implementation Zaragoza_BusTests

- (void)setUp {
    
    [super setUp];
    // create VC for table testing
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"busStopTableView"];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    NSArray *lines = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    self.dictionaryName = [NSDictionary dictionaryWithObjectsAndKeys:@"0000", @"id", @"Example title", @"title", @"Example subtitle", @"subtitle", @"40.837453453", @"lat", @"17.9359385737", @"lon", lines, @"lines", nil];
    
}

- (void)tearDown {

    self.vc = nil;
    [super tearDown];
}

#pragma mark - Bus Stop Object loading tests

- (void)testThatCreateEmptyObjectBusStop {
    BusStop * testObj = [[BusStop alloc] init];
    
    XCTAssertNotNil(testObj, @"Object not initiated properly");
}

- (void)testThatCreateObjectBusStopFromDict {
    
    BusStop * testObj = [[BusStop alloc] initWithDictionary:self.dictionaryName];
    
    XCTAssertNotNil(testObj, @"Object not created properly");
}


#pragma mark - Master View Controller tests

-(void)testThatViewLoads
{
    XCTAssertNotNil(self.vc.view, @"View not initiated properly");
}

- (void)DISABLED_testParentViewHasTableViewSubview
{
    NSArray *subviews = self.vc.view.subviews;
    XCTAssertTrue([subviews containsObject:self.vc.tableView], @"View does not have a table subview");
}

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(self.vc.tableView, @"TableView not initiated");
}

- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.vc.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testThatTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.vc.tableView.delegate, @"Table delegate cannot be nil");
}

- (void)testThatTableViewMoreThanOneRowsLoadedInSection
{
    XCTAssertEqual([self.vc tableView:self.vc.tableView numberOfRowsInSection:0], [self.vc.objects count], @"Table list count not equal to bus stop list");
   
}

- (void)testThatTableViewHeightForRowAtIndexPath
{
    CGFloat expectedHeight = 220.0;
    CGFloat actualHeight = self.vc.tableView.rowHeight;
    XCTAssertEqual(expectedHeight, actualHeight, @"Cell should have %f height, but they have %f", expectedHeight, actualHeight);
}


#pragma mark - Bus Stop Loader tests
- (void)testThatRequestBusStopsFromServer {
    
    BusStopLoader *loaderService = [[BusStopLoader alloc] initWithCallback:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            XCTAssertTrue([responseObject count] > 0, @"Objects loaded");
        } else {
            XCTAssertTrue([responseObject isKindOfClass:[NSError class]], @"Objects loading error");
        }
    }];
    
    [loaderService loadBusStops];
    
}

- (void)testThatRequestBusStopInfoFromServer {
    
    BusStopLoader *loaderService = [[BusStopLoader alloc] initWithCallback:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            XCTAssertTrue([responseObject count] > 0, @"Estimates loaded");
        } else {
            XCTAssertTrue([responseObject isKindOfClass:[NSError class]], @"Estimates loading error");
        }
    }];
    
    [loaderService loadBusStopInfo:@"1005"];
    
}

#pragma mark - Image loader tests
- (void) testThatImageViewLoading {
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString *url = @"https://maps.googleapis.com/maps/api/staticmap?zoom=19&size=300x180&sensor=true&center=41.66256420781479,-0.8641416812942481";
    
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    XCTAssertNotNil(imageView.image, @"Image cannot be nil");
}


#pragma mark - Performance tests
- (void)testPerformanceExample {

    NSMutableArray * elements = [[NSMutableArray alloc] initWithCapacity:1000];
    
    [self measureBlock:^{
        for (int i=0; i<1000; i++) {
            BusStop * testObj = [[BusStop alloc] initWithDictionary:self.dictionaryName];
            [elements addObject:testObj];
        }
    }];
}

@end
