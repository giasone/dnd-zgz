//
//  BusStopCustomCell.h
//  Zaragoza-Bus
//
//  Created by Giasone on 27/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusStopCustomCell : UITableViewCell

@property (nonatomic, strong)  IBOutlet UILabel *busTitleLabel;
@property (nonatomic, strong)  IBOutlet UILabel *busSubTitleLabel;
@property (nonatomic, strong)  IBOutlet UIImageView *busLocationImageView;

@end
