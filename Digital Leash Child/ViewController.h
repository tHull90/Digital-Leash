//
//  ViewController.h
//  Digital Leash Child
//
//  Created by Timothy Hull on 8/30/16.
//  Copyright © 2016 Timothy Hull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate, NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *parentNameTextField;
@property (strong, nonatomic) CLLocationManager *locationManager;


-(IBAction)reportLocationButtonTapped:(UIButton *)sender;
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;


@end

