//
//  PersonDetailViewController.m
//  Address book
//
//  Created by Sveta on 31.08.13.
//  Copyright (c) 2013 Sveta. All rights reserved.
//

#import "AddPersonViewController.h"

@interface AddPersonViewController ()

@end

@implementation AddPersonViewController

@synthesize firstName, lastName, descriptionTextView, homeNumber, mobileNumber, email;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.    
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.email.delegate = self;
    self.mobileNumber.delegate = self;
    self.homeNumber.delegate = self;
    
    self.descriptionTextView.text = @"You may write here some notes about the person";
    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    
    [[self.descriptionTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.descriptionTextView layer] setBorderWidth:2.3];
    [[self.descriptionTextView layer] setCornerRadius:15];
    
    self.descriptionTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions and Touch Event

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [mobileNumber resignFirstResponder];
    [homeNumber resignFirstResponder];
    [firstName resignFirstResponder];
    [lastName resignFirstResponder];
    [email resignFirstResponder];
    [descriptionTextView resignFirstResponder];
}

- (IBAction)savePerson:(id)sender
{
    if ([self.firstName.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hey man"
                                                       message:@"I can not save a person without name"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];

    } else {
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    NSString *queryString = [NSString stringWithFormat:@"insert into address (person_name, email, home_num , mobile_num, person_des) values ('%@','%@','%@','%@','%@')",
                             self.firstName.text,self.email.text,self.homeNumber.text,self.mobileNumber.text, self.descriptionTextView.text];
    [SQLiteAccess updateWithSQL:queryString];
    }
}


#pragma mark - Phone Number Field Formatting


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.descriptionTextView.text = @"";
    self.descriptionTextView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.descriptionTextView.text.length == 0){
        self.descriptionTextView.textColor = [UIColor lightGrayColor];
        self.descriptionTextView.text = @"You may write here some notes about the person ";
        [self.descriptionTextView resignFirstResponder];
    }
}

@end
