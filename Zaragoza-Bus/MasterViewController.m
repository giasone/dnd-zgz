//
//  MasterViewController.m
//  Zaragoza-Bus
//
//  Created by Giasone on 27/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "BusStopCustomCell.h"
#import "BusStop.h"
#import "BusStopLoader.h"
#import "Configuration.h"
#import "UIImageView+AFNetworking.h"
#import "CRToast.h"


@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewConfiguration {
    self.title = @"Bus Stops";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:150.0f/255.0f
                                                                           green:40.0f/255.0f
                                                                            blue:27.0f/255.0f
                                                                           alpha:1.0f];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.objects count]];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.active = NO;
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.definesPresentationContext = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewConfiguration];
    
    [self loadData];
    
}

- (void)loadData {
    
    BusStopLoader *loaderService = [[BusStopLoader alloc] initWithCallback:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if ([responseObject count] > 0) {
                
                self.objects = responseObject;
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    [self showNotification:@"Bus Stops list loaded!" isShort:YES isAlert:NO];
                    
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showNotification:@"No Bus Stops found!" isShort:YES isAlert:NO];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{

                [self showNotification:@"Bus Stops list loading error!" isShort:NO isAlert:YES];
            });
        }
    }];
    
    [loaderService loadBusStops];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        if (self.searchController.active) {
            [controller setDetailItem:self.searchResults[indexPath.row]];
        } else {
            [controller setDetailItem:self.objects[indexPath.row]];
        }
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [self.searchResults count];
    } else {
        return [self.objects count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusStopCustomCell *cell = (BusStopCustomCell *)[tableView dequeueReusableCellWithIdentifier:@"BusStopCustomCell" forIndexPath:indexPath];

    BusStop *busStopValue = nil;
    if (self.searchController.active) {
        busStopValue = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        busStopValue = [self.objects objectAtIndex:indexPath.row];
    }

    cell.busTitleLabel.text = busStopValue.busStopTitle;
    cell.busSubTitleLabel.text = busStopValue.busStopSubTitle;

    [cell.busLocationImageView setImageWithURL:[NSURL URLWithString:busStopValue.busStopImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self updateFilteredContent:[self.searchController.searchBar text]];
    [self.tableView reloadData];
}

- (void)updateFilteredContent:(NSString *)searchString {
    
    if ((searchString == nil) || [searchString length] == 0) {
        self.searchResults = [self.objects mutableCopy];
        return;
    }
    [self.searchResults removeAllObjects];
    
    for (BusStop *busStop in self.objects) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange searchRange = NSMakeRange(0, busStop.busStopTitle.length);
        NSRange foundRange = [busStop.busStopTitle rangeOfString:searchString
                                                         options:searchOptions
                                                           range:searchRange];
        if (foundRange.length > 0) {
            [self.searchResults addObject:busStop];
        }
        
    }
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
