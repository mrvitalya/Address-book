//
//  AddressViewController.m
//  Address book
//
//  Created by Sveta on 31.08.13.
//  Copyright (c) 2013 Sveta. All rights reserved.
//

#import "PersonsViewController.h"

@interface PersonsViewController ()

@end

@implementation PersonsViewController

@synthesize detailViewController = _detailViewController;
@synthesize persons;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Введите пароль"
                                                            message:nil delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"ОК", nil];
    
    passwordAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [passwordAlert show];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (NSArray*)persons {
    return [SQLiteAccess selectManyRowsWithSQL:@"select * from address"];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText isEqual: @"12345"] ) {
        return YES;
    }
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    // Configure the cell...
    NSDictionary *person = [self.persons objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [person objectForKey:@"person_name"];

    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {


            NSDictionary *person = [self.persons objectAtIndex:indexPath.row];
            NSString *personID = [person objectForKey:@"id"];
            NSString *queryString = [NSString stringWithFormat:@"delete from address where id = '%@'",personID];
            [SQLiteAccess deleteWithSQL:queryString];
        
        
            NSString *words = [person objectForKey:@"person_name"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You deleted the"
                                                       message:words
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
            [alert show];
        
            [self.tableView reloadData];
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetal"]) {
        PersonDetailViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.detailItem = [self.persons objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
    }
}


@end
