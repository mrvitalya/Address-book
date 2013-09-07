//
//  AddressViewController.h
//  Address book
//
//  Created by Sveta on 31.08.13.
//  Copyright (c) 2013 Sveta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteAccess.h"
#import "PersonDetailViewController.h"


@interface PersonsViewController : UITableViewController

@property (strong, nonatomic) PersonDetailViewController *detailViewController;
@property(nonatomic,strong)NSArray*persons;

@end
