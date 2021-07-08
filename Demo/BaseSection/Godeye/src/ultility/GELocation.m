//
//  GELocation.m
//  AFNetworking
//
//  Created by jerry.jiang on 2018/12/25.
//

#import "GELocation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GELocation () <CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
    CLLocation *_location;
    //是否正在定位中：YES,定位中,NO,未定位
    BOOL _isLocationing;
    
}
@end


@implementation GELocation

+ (void)updateLocation
{
    [[GELocation sharedHandler] updateLocation];
}

+(double)latitude{
    return [GELocation sharedHandler] -> _location.coordinate.latitude;
}

+(double)longitude{
    return [GELocation sharedHandler] -> _location.coordinate.longitude;
}

+(instancetype)sharedHandler{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = self.new;
    });
    return instance;
}

-(id)init{
    self = [super init];
    if (self != nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _isLocationing = NO;
    }
    return self;
}


#pragma mark - public method

- (void)updateLocation
{
    BOOL locationDisable = ![CLLocationManager locationServicesEnabled] ||[CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied;
    
    if (_isLocationing || locationDisable) {
        return;
    }
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1000.0f;
    
    [_locationManager requestWhenInUseAuthorization];
    
    [_locationManager startUpdatingLocation];
    _isLocationing = YES;
}


#pragma mark - cllocation delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (!_isLocationing) {
        return;
    }
    _location = locations[0];
    _isLocationing = NO;
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self updateLocation];
            break;
        default:
            break;
    }
}


@end
