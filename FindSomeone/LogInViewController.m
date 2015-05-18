//
//  ViewController.m
//  FindSomeone
//
//  Created by tho dang on 2015-05-15.
//  Copyright (c) 2015 ThoDang. All rights reserved.
//

#import "LogInViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "MapViewController.h"

@interface LogInViewController ()<FBSDKLoginButtonDelegate>

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Using prebuiled FB login button
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    loginButton.delegate=self;
    
    [self.view addSubview:loginButton];
    
    
}
// this method get the token from FB
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    //if there is error , the method is done , we still stay at the VC
    if (error)
    {
        return;
    }
    [PFFacebookUtils logInInBackgroundWithAccessToken:result.token
                                                block:^(PFUser *user, NSError *error){
                                                    
                                                    if (!user) {
                                                        NSLog(@"error log in ");
                                                    }else{
                                                        NSLog(@"Yes, you logged in ");
                                                // to fetch the currently logged in person's profile information:
                                                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                                                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                                             if (!error) {
                                                                 NSLog(@"fetched user:%@", result);
                                                                 //Now we have user information from facebook, which data we should save on parse  for our app(post them to Parse)
                                                                 
                                                                 user[@"fullname"] = result[@"name"];
                                                                 [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                                     if (succeeded) {
                                                                         // The object has been saved.
                                                                         NSLog(@"Saved to Parse.");
                                                                     } else {
                                                                         // There was a problem, check error.description
                                                                         NSLog(@"%@", error.description);
                                                                     }
                                                                 }];
                                                                 
                                                             }
                                                         }];
                                                        
                                                      // After log in , now link to the view controller from here
                                                        MapViewController *mapViewController=[[MapViewController alloc]init];
                                                        
                                                        [self presentViewController:mapViewController animated:YES completion:nil];
                                                       // [self performSegueWithIdentifier:@"showMap" sender:self ]
                                                    }
                                                
                                                }
     
     ];


}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    NSLog(@"don't leave my app ");

}

@end
