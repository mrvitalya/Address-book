//
//  PersonDetailViewController.h
//  Address book
//
//  Created by Sveta on 31.08.13.
//  Copyright (c) 2013 Sveta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SQLiteAccess.h"

@interface AddPersonViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *homeNumber;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

- (IBAction)savePerson:(id)sender;


@end

