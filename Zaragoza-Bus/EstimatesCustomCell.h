//
//  EstimatesCustomCell.h
//  Zaragoza-Bus
//
//  Created by Giasone on 28/08/16.
//  Copyright © 2016 Gianluca Urgese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstimatesCustomCell : UITableViewCell

@property (nonatomic, strong)  IBOutlet UILabel *busLineLabel;
@property (nonatomic, strong)  IBOutlet UILabel *busDirectionLabel;
@property (nonatomic, strong)  IBOutlet UILabel *busEstimateLabel;

@end
