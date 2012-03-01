// For iOS
#import <GHUnitIOS/GHUnit.h> 
// For Mac OS X
//#import <GHUnit/GHUnit.h>

#pragma mark - Testing Overriden Classes

@interface TestSnSURLConnection : SnSURLConnection
{}

- (NSInteger)integerParameterFromURL:(NSString*)iAbsoluteURL parameter:(NSString*)iParameter;

@end

@implementation TestSnSURLConnection

- (NSData *)retreiveData
{
	
	NSData* aData = nil;
	
	NSInteger aWaitInMs = [self integerParameterFromURL:[_request.URL absoluteString]  parameter:@"time"];;
	NSInteger aDataLengthInBytes = [self integerParameterFromURL:[_request.URL absoluteString]  parameter:@"length"];;
	
	
	// Fake the call duration
	usleep(aWaitInMs*1000);
	
	// Construct data object
	unsigned char* someBytes = (unsigned char*)malloc(aDataLengthInBytes);
	aData = [NSData dataWithBytes:someBytes length:aDataLengthInBytes];
	free(someBytes);
	
	return aData;
	
	
}

- (NSInteger)integerParameterFromURL:(NSString*)iAbsoluteURL parameter:(NSString*)iParameter
{
	NSInteger aParamValue = 0;
	
	NSError* oError = nil;
	NSRegularExpression *aRegex = nil;
	id aRegexResult = nil;
	NSRange aRange = NSMakeRange(0, 0);
	
	// Retreive Length
	aRegex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@=(\\d+)",iParameter]
													   options:NSRegularExpressionCaseInsensitive
														 error:&oError];
	
	aRegexResult = [aRegex firstMatchInString:iAbsoluteURL options:NSMatchingCompleted range:NSMakeRange(0, [iAbsoluteURL length])];
	
	aRange = [aRegexResult rangeAtIndex:1];
	if (aRange.length > 0)
		aParamValue = [[iAbsoluteURL substringWithRange:aRange] integerValue];
	
	return aParamValue;
	
}

@end


#pragma mark - GHTestCase

@interface TestConnection : GHTestCase 
{
}
	
@end

@implementation TestConnection

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

- (void)testConnection
{
	NSInteger aRequestTime = 50; //in ms
	NSInteger aDataLength=32;
	NSURLRequest* aRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"test.request?time=%d&length=%d", aRequestTime, aDataLength]]
												   cachePolicy:NSURLRequestReloadIgnoringCacheData 
											   timeoutInterval:5.0];
	
	//aURLCache.connectionHandler = self;
	
	NSData* aData = [TestSnSURLConnection retreiveDataForReqest:aRequest];
	
	GHAssertNotNil(aData, @"[TestSnSURLConnection retreiveDataForReqest:aRequest] should not return nil");
	GHAssertTrue([aData length] == aDataLength, @"Data length %d when %d expected", [aData length], aDataLength);
	
	// Release
	[aRequest release];
}

- (void)testConnectionCache
{
	NSInteger aRequestTime = 50; //in ms
	NSInteger aDataLength=32;
	NSURLRequest* aRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"test.request?time=%d&length=%d", aRequestTime, aDataLength]]
												   cachePolicy:NSURLRequestReloadIgnoringCacheData 
											   timeoutInterval:5.0];
	
	//aURLCache.connectionHandler = self;
	
	NSData* aData = [TestSnSURLConnection retreiveDataForReqest:aRequest];
	
	GHAssertNotNil(aData, @"[TestSnSURLConnection retreiveDataForReqest:aRequest] should not return nil");
	GHAssertTrue([aData length] == aDataLength, @"Data length %d when %d expected", [aData length], aDataLength);
	
	// Release
	[aRequest release];
}


@end