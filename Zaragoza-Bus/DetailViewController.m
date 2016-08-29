//
//  DetailViewController.m
//  Zaragoza-Bus
//
//  Created by Giasone on 27/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BusStopLoader.h"
#import "EstimatesCustomCell.h"
#import "CRToast.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.titleLabel.text = [self.detailItem busStopTitle];
        [self.mapImage setImageWithURL:[NSURL URLWithString:[self.detailItem busStopImageURL]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.estimatesTable.delegate = self;
    [self configureView];
    [self loadData];
}

- (void)loadData {
    
    BusStopLoader *loaderService = [[BusStopLoader alloc] initWithCallback:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if ([responseObject count] > 0) {
                
                self.detailItem.busStopEstimates = responseObject;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.estimatesTable reloadData];
                    [self showNotification:@"Bus Stop estimates loaded!" isShort:YES isAlert:NO];
                    
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showNotification:@"No Bus Stop estimates found!" isShort:YES isAlert:NO];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self showNotification:@"Bus Stops estimates loading error!" isShort:NO isAlert:YES];
            });
        }
    }];
    
    [loaderService loadBusStopInfo:self.detailItem.busStopId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.detailItem.busStopEstimates count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EstimatesCustomCell *cell = (EstimatesCustomCell *)[tableView dequeueReusableCellWithIdentifier:@"EstimatesCustomCell" forIndexPath:indexPath];
    
    NSDictionary *estimateDict = [self.detailItem.busStopEstimates objectAtIndex:indexPath.item];

    cell.busLineLabel.text = [estimateDict objectForKey:@"line"];
    cell.busDirectionLabel.text = [estimateDict objectForKey:@"direction"];
    cell.busEstimateLabel.text = [self formatEstimate:(int)[estimateDict objectForKey:@"estimate"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Next buses";
}

- (NSString *)formatEstimate:(int)min {
    
    if (min <= 0) {
        return @"n.a.";
    }
    int hours = min / 60;
    int minutes = min % 60;
    NSString *estimate = @"";
    NSLog(@"%d", min);
    if (hours>0) {
        estimate = [NSString stringWithFormat:@"%d h %d m", hours, minutes];
    } else {
        estimate = [NSString stringWithFormat:@"%d m", min];
    }
    
    return estimate;
}

-(void) showError:(NSString * )message {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {}];
        
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

-(void)showNotification:(NSString *)message isShort:(bool)isShort isAlert:(bool)isAlert
{
    
    NSMutableDictionary *options = [@{
                                      kCRToastTextKey : message,
                                      kCRToastTextAlignmentKey         : @(NSTextAlignmentCenter),
                                      kCRToastBackgroundColorKey       : isAlert ? [UIColor redColor] :[UIColor blackColor],
                                      kCRToastAnimationInTypeKey       : @(CRToastAnimationTypeSpring),
                                      kCRToastAnimationOutTypeKey      : @(CRToastAnimationTypeSpring),
                                      kCRToastAnimationInDirectionKey  : @(CRToastAnimationDirectionTop),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                      kCRToastNotificationTypeKey      : isShort ? @(CRToastTypeStatusBar) :@(CRToastTypeNavigationBar)
                                      } mutableCopy];
    
    
    if (isAlert) {
        options[kCRToastImageKey] = [UIImage imageNamed:@"alert_icon"];
        options[kCRToastImageAlignmentKey] = @(CRToastAccessoryViewAlignmentLeft);
    } else {
        options[kCRToastImageKey] = [UIImage imageNamed:@"white_checkmark"];
        options[kCRToastImageAlignmentKey] = @(CRToastAccessoryViewAlignmentLeft);
    }
    
    [CRToastManager showNotificationWithOptions:[NSDictionary dictionaryWithDictionary:options]
                                completionBlock:nil];
}

@end
