//
//  MasterViewController.h
//  Zaragoza-Bus
//
//  Created by Giasone on 27/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController < UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate >

@property (strong, nonatomic) NSArray *objects;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) UISearchController *searchController;



@end

