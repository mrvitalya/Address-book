//
//  PersonDetailViewController.h
//  Address book
//
//  Created by Sveta on 02.09.13.
//  Copyright (c) 2013 Sveta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteAccess.h"
#import <QuartzCore/QuartzCore.h>


@class Person;

@interface PersonDetailViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary *detailItem;

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *homeNumber;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

- (IBAction)editButtonClick:(id)sender;
@end
