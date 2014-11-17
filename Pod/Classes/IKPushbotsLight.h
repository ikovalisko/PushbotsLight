//
// Created by Ivan Kovalisko on 11/9/14.
//


#import <Foundation/Foundation.h>

@interface IKPushbotsLight : NSObject

- (instancetype)initWithApplicationID:(NSString *)applicationID;

- (NSURLSessionDataTask *)registerDevice:(NSData *)deviceToken;
- (NSURLSessionDataTask *)recordAnalytics;
- (NSURLSessionDataTask *)setBadgeCount:(NSUInteger)badge;

@end
