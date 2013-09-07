//
//  PersonDetailViewController.m
//  Address book
//
//  Created by Sveta on 02.09.13.
//  Copyright (c) 2013 Sveta. All rights reserved.
//

#import "PersonDetailViewController.h"

@interface PersonDetailViewController ()
    - (void)configureView;
@end

@implementation PersonDetailViewController

@synthesize detailItem = _detailItem;
@synthesize descriptionTextView,email,mobileNumber,homeNumber,lastName,firstName;

CGFloat animatedDistance;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        [self configureView];
    }
}
- (void)configureView
{
    if (self.detailItem) {
        self.firstName.text = [self.detailItem objectForKey:@"person_name"];
        self.descriptionTextView.text = [self.detailItem objectForKey:@"person_des"];
        self.homeNumber.text = [self.detailItem objectForKey:@"home_num"];
        self.mobileNumber.text = [self.detailItem objectForKey:@"mobile_num"];
        self.email.text = [self.detailItem objectForKey:@"email"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
    [self configureView];
    
    NSLog(@"%@",self.detailItem);
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.email.delegate = self;
    self.mobileNumber.delegate = self;
    self.homeNumber.delegate = self;
    self.descriptionTextView.delegate = self;

    
    self.firstName.enabled = NO;
    self.lastName.enabled = NO;
    self.email.enabled = NO;
    self.mobileNumber.enabled = NO;
    self.homeNumber.enabled = NO;
    self.descriptionTextView.editable = NO;

    
//    self.descriptionTextView.text = @"You may write here some notes about the person";
//    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    
    [[self.descriptionTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:2.3];
    [[self.descriptionTextView layer] setCornerRadius:15];
    
    


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)editButtonClick:(id)sender
{
    NSLog(@"Button EDIT click!!!!");
    self.firstName.enabled = YES;
    self.lastName.enabled = YES;
    self.email.enabled = YES;
    self.mobileNumber.enabled = YES;
    self.homeNumber.enabled = YES;
    self.descriptionTextView.editable = YES;
    
    [self.firstName setBorderStyle:UITextBorderStyleRoundedRect];
    [self.email setBorderStyle:UITextBorderStyleRoundedRect];
    [self.mobileNumber setBorderStyle:UITextBorderStyleRoundedRect];
    [self.homeNumber setBorderStyle:UITextBorderStyleRoundedRect];

    
    self.navigationItem.leftBarButtonItem.enabled=NO;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEdit:)];
}

-(void)saveEdit:(id)sender
{
    
     NSLog(@"Button SAVE click!!!!");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClick:)];
    self.navigationItem.leftBarButtonItem.enabled=YES;
    
    self.firstName.enabled = NO;
    self.lastName.enabled = NO;
    self.email.enabled = NO;
    self.mobileNumber.enabled = NO;
    self.homeNumber.enabled = NO;
    self.descriptionTextView.editable = NO;
    
    [self.firstName setBorderStyle:UITextBorderStyleNone];
    [self.email setBorderStyle:UITextBorderStyleNone];
    [self.mobileNumber setBorderStyle:UITextBorderStyleNone];
    [self.homeNumber setBorderStyle:UITextBorderStyleNone];

    NSString *personID = [self.detailItem objectForKey:@"id"];
    NSString *queryString = [NSString stringWithFormat:@"update address set person_name = '%@', mobile_num = '%@', home_num = '%@', email = '%@', person_des = '%@'  WHERE id='%@'",
                             self.firstName.text,self.mobileNumber.text,self.homeNumber.text,self.email.text,self.descriptionTextView.text, personID];
    
    [SQLiteAccess updateWithSQL:queryString];
    
 }

- (void)viewDidUnload
{
    [self setFirstName:nil];
    [self setDescriptionTextView:nil];
    [self setLastName:nil];
    [self setHomeNumber:nil];
    [self setMobileNumber:nil];
    [self setEmail:nil];
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - Phone Number Field Formatting


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    float width = [textField.text sizeWithFont:
//                   [UIFont systemFontOfSize: 17]
//                             constrainedToSize:
//                   CGSizeMake(159, textField.bounds.size.height)].width;
//    
//    textField.bounds = CGRectMake(textField.bounds.origin.x,
//                                  textField.bounds.origin.y,
//                                  width,
//                                  textField.bounds.size.height);
    
    if (textField == self.mobileNumber || textField == self.homeNumber) {
        int length = [self getLength:textField.text];
        if(length == 10) {
            if(range.length == 0)
                return NO;
        }
        if(length == 3) {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6) {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    }
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumberMask
{
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = [mobileNumberMask length];
    if(length > 10) {
        mobileNumberMask = [mobileNumberMask substringFromIndex: length-10];
    }
    return mobileNumberMask;
}


-(int)getLength:(NSString*)mobileNumberMask
{
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumberMask = [mobileNumberMask stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = [mobileNumberMask length];
    return length;
}

#pragma mark -  Sliding UITextFields around to avoid the keyboard

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


#pragma mark -  Sliding UITextView around to avoid the keyboard and add placeholder text
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect textViewRect= [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textViewRect.origin.y + 0.5 * textViewRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


//- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
//{
//    self.descriptionTextView.text = @"";
//    self.descriptionTextView.textColor = [UIColor blackColor];
//    return YES;
//}

//-(void) textViewDidChange:(UITextView *)textView
//{
//    if(self.descriptionTextView.text.length == 0){
//        self.descriptionTextView.textColor = [UIColor lightGrayColor];
//        self.descriptionTextView.text = @"You may write here some notes about the person ";
//        [self.descriptionTextView resignFirstResponder];
//    }
//}


@end
