//
//  DDNSLoggerLogger.h
//  Created by Peter Steinberger on 26.10.10.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface DDNSLoggerLogger : DDAbstractLogger <DDLogger>

@property (nonatomic, readonly) BOOL running;

+ (DDNSLoggerLogger *)sharedInstance;

/// should setup before `- (void)start`
- (void)setupWithBonjourServiceName:(NSString *)serviceName;

- (void)start;
- (void)stop;

@end
