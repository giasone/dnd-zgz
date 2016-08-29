//
//  DetailViewController.h
//  Zaragoza-Bus
//
//  Created by Giasone on 27/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStop.h"

@interface DetailViewController : UIViewController < UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) BusStop * detailItem;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImage;
@property (weak, nonatomic) IBOutlet UITableView *estimatesTable;


@end

