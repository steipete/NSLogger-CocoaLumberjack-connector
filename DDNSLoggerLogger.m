//
//  DDNSLoggerLogger.m
//  Created by Peter Steinberger on 26.10.10.
//

#import "DDNSLoggerLogger.h"

// NSLogger is needed: http://github.com/fpillet/NSLogger
#import "LoggerClient.h"

@implementation DDNSLoggerLogger

static DDNSLoggerLogger *sharedInstance = nil;

// The logger instance we use
static Logger *_DDNSLogger_logger = nil;

+ (DDNSLoggerLogger *)sharedInstance
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });

	return sharedInstance;
}

- (id)init
{
	if (sharedInstance != nil)
	{
		return nil;
	}

	if ((self = [super init]))
	{
    // create and remember the logger instance
    _DDNSLogger_logger = LoggerInit();

    // configure the logger
    LoggerSetOptions(_DDNSLogger_logger, kLoggerOption_BufferLogsUntilConnection | kLoggerOption_BrowseBonjour | kLoggerOption_BrowseOnlyLocalDomain );
    LoggerStart(_DDNSLogger_logger);
	}
	return self;
}

- (void)setupWithBonjourServiceName:(NSString *)serviceName
{
    LoggerSetupBonjour(_DDNSLogger_logger, NULL, (__bridge CFStringRef)serviceName);
}

- (void)logMessage:(DDLogMessage *)logMessage
{
	NSString *logMsg = logMessage->logMsg;

	if (formatter)
	{
        // formatting is supported but not encouraged!
		logMsg = [formatter formatLogMessage:logMessage];
    }

	if (logMsg)
	{
    int nsloggerLogLevel;
		switch (logMessage->logFlag)
		{
      // NSLogger log levels start a 0, the bigger the number,
      // the more specific / detailed the trace is meant to be
			case LOG_FLAG_ERROR : nsloggerLogLevel = 0; break;
			case LOG_FLAG_WARN  : nsloggerLogLevel = 1; break;
			case LOG_FLAG_INFO  : nsloggerLogLevel = 2; break;
			default : nsloggerLogLevel = 3; break;
		}

	LogMessageF(logMessage->file, logMessage->lineNumber, logMessage->function, [logMessage fileName], 
                                nsloggerLogLevel, @"%@", logMsg);
    }
}

- (NSString *)loggerName
{
	return @"cocoa.lumberjack.NSLogger";
}

@end
