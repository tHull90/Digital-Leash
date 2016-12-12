//
//  ViewController.m
//  Digital Leash Child
//
//  Created by Timothy Hull on 8/30/16.
//  Copyright © 2016 Timothy Hull. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocation *location;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
    self.usernameTextField.delegate = self;
    self.parentNameTextField.delegate = self;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //Latitude
    int degrees = newLocation.coordinate.latitude;
    double decimal = fabs(newLocation.coordinate.latitude - degrees);
    int minutes = decimal * 60;
    double seconds = decimal * 3600 - minutes * 60;
    NSString *lat = [NSString stringWithFormat:@"%d° %d' %1.4f\"", degrees, minutes, seconds];
    NSLog(@"Current Latitude: %@", lat);

    
    //Longitude
    degrees = newLocation.coordinate.longitude;
    self.location = newLocation;
    decimal = fabs(newLocation.coordinate.longitude - degrees);
    minutes = decimal * 60;
    seconds = decimal * 3600 - minutes * 60;
    NSString *longt = [NSString stringWithFormat:@"%d° %d' %1.4f\"", degrees, minutes, seconds];
    NSLog(@"Current Longitude: %@", longt);

    
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"*dLatitude : %@", latitude);
    NSLog(@"*dLongitude : %@",longitude);
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}




-(CLLocationCoordinate2D) getLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}



-(void)patchRequest {
    NSString *urlString = [NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", self.usernameTextField.text];
    NSURL *patchURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *patchRequest = [NSMutableURLRequest requestWithURL:patchURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    NSDictionary *childDict = @{ @"current_latitude":[NSNumber numberWithDouble:self.location.coordinate.latitude],
                                 @"current_longitude":[NSNumber numberWithDouble:self.location.coordinate.longitude] };
    
    NSError *error;
    NSData *childJSON = [NSJSONSerialization dataWithJSONObject:childDict
                                                        options:0
                                                          error:&error];
    
    [patchRequest setHTTPMethod:@"PATCH"];
    [patchRequest setHTTPBody:childJSON];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:patchRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *convert = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions
                                                                error:&error];
        NSLog(@"%@", convert);
        
        if (error) {
            UIAlertController *internetAlert=   [UIAlertController
                                                 alertControllerWithTitle:@"Error"
                                                 message:error.localizedDescription
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                       }];
            
            [internetAlert addAction:okAction];
            [self presentViewController:internetAlert animated:YES completion:nil];

            
        }
        else {
            
            
            NSDictionary *convertToDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:kNilOptions
                                                                                  error:&error];
            
            
            NSLog(@"%@", convertToDictionary);
        }

    }];
    
    [dataTask resume];
    
}


-(IBAction)reportLocationButtonTapped:(UIButton *)sender {
    [self patchRequest];
    
    
}



@end
