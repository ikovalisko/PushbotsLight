//
// Created by Ivan Kovalisko on 11/9/14.
//


#import "IKPushbotsLight.h"

static NSString *const PushBotsBaseURL = @"https://api.pushbots.com";
static NSString *const RegisterDevicePath = @"/deviceToken";
static NSString *const RecordAnalyticsPath = @"/stats";
static NSString *const SetBadgePath = @"/badge";

@interface IKPushbotsLight ()
@property (nonatomic, strong) NSString *applicationID;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *deviceToken;
@end

@implementation IKPushbotsLight

- (instancetype)initWithApplicationID:(NSString *)applicationID
{
    self = [super init];
    if (!self) {
        return nil;
    }

    NSAssert(applicationID, @"Pushbots requires Application ID to make requests. Visit https://pushbots.com");
    _applicationID = applicationID;

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setHTTPAdditionalHeaders:@{@"Accept"           : @"application/json",
                                                     @"Content-Type"     : @"application/json",
                                                     @"X-PUSHBOTS-APPID" : _applicationID}];

    _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    return self;
}

- (NSURLSessionDataTask *)registerDevice:(NSData *)deviceToken
{
    NSAssert(deviceToken, @"Device token is required to register a device on Pushbots");
    NSString *cleanedToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    cleanedToken = [cleanedToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceToken = cleanedToken;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[PushBotsBaseURL stringByAppendingPathComponent:RegisterDevicePath]]];
    request.HTTPMethod = @"PUT";

    NSDictionary *params = @{
            @"token"    : cleanedToken,
            @"platform" : @0
    };
    NSError *jsonError;
    NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0x00 error:&jsonError];
    if (!body) {
        NSLog(@"[%s] Failed to create json from %@. \nError: %@", __PRETTY_FUNCTION__, params, jsonError.localizedDescription);
    }

    request.HTTPBody = body;

    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Failed to register device. Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Registered device on Pushbots.com");
        }
    }];

    [task resume];

    return task;
}

- (NSURLSessionDataTask *)recordAnalytics
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[PushBotsBaseURL stringByAppendingPathComponent:RecordAnalyticsPath]]];
    request.HTTPMethod = @"PUT";

    NSDictionary *params = @{@"platform" : @0};
    NSError *jsonError;
    NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0x00 error:&jsonError];
    if (!body) {
        NSLog(@"[%s] Failed to create json from %@. \nError: %@", __PRETTY_FUNCTION__, params, jsonError.localizedDescription);
    }

    request.HTTPBody = body;

    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Failed to record analytics. Error: %@", error.localizedDescription);
        }
    }];

    [task resume];

    return task;
}

- (NSURLSessionDataTask *)setBadgeCount:(NSUInteger)badge
{
    if (!self.deviceToken) {
        return nil;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[PushBotsBaseURL stringByAppendingPathComponent:SetBadgePath]]];
    request.HTTPMethod = @"PUT";
    
    NSDictionary *params = @{
                             @"platform" : @0,
                             @"setbadgecount" : @(badge),
                             @"token" : self.deviceToken
                             };
    NSError *jsonError;
    NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0x00 error:&jsonError];
    if (!body) {
        NSLog(@"[%s] Failed to create json from %@. \nError: %@", __PRETTY_FUNCTION__, params, jsonError.localizedDescription);
    }
    
    request.HTTPBody = body;
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Failed to set badge to %lu. Error: %@", (unsigned long)badge, error.localizedDescription);
        }
    }];
    
    [task resume];
    
    return task;
}

@end
