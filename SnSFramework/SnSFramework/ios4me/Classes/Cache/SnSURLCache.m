/* 
 * Copyright (C) 2009 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 *
 * This library is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 */

//
//  SnSURLCache.m
//  SnSFramework
//
//  Created by Édouard Mercier on 10/9/2009.
//

#import "SnSURLCache.h"

#import "SnSConstants.h"
#import "SnSLog.h"
#import "SnSDelegate.h"
#import "UIDevice+DeviceConnectivity.h"

#pragma mark -
#pragma mark SnSURLCacheData

NSString * const TYPE_MIME_OCTET_STREAM = @"application/octet-stream";
NSString * const TYPE_MIME_JSON = @"application/json";
NSString * const TYPE_MIME_IMAGE = @"image";

// TODO: NEED CRITICAL Rewrite / Refacto.

@interface SnSURLCacheData(Private)

- (id) initWith:(NSData *)theData andObject:(id)theObject;

@end

@implementation SnSURLCacheData

@synthesize data;
@synthesize object;

+ (id) cacheDataWith:(NSData *)theData andObject:(id)theObject
{
    return [[[SnSURLCacheData alloc] initWith:theData andObject:theObject] autorelease];
}

- (id) initWith:(NSData *)theData andObject:(id)theObject
{
    if ((self = [super init]))
    {
        self.data = theData;
        self.object = theObject;
    }
    
    return self;
}

- (void) dealloc
{
	[data release], data = nil;
	[object release], object = nil;
    
	[super dealloc];
}

@end

#pragma mark -
#pragma mark SnSDownloadOperation

@interface SnSDownloadOperation : NSOperation
{
  @private
    NSString *_url;
    NSTimeInterval _timeoutInterval;
    id _delegate;
    SEL _selector;
    id _object;
}

- (id) initWith:(NSString *)url timeoutInterval:(NSTimeInterval)timeoutInterval andDelegate:(SnSDelegateWithObject *)delegate;
- (id) initWith:(NSString *)url timeoutInterval:(NSTimeInterval)timeoutInterval andDelegate:(id)delegate andSelector:(SEL)selector andObject:(id)object;

@end

@implementation SnSDownloadOperation

- (id) initWith:(NSString *)url timeoutInterval:(NSTimeInterval)timeoutInterval andDelegate:(SnSDelegateWithObject *)delegate
{
    return [self initWith:url timeoutInterval:timeoutInterval andDelegate:delegate.delegate andSelector:delegate.selector andObject:delegate.object];
}

- (id) initWith:(NSString *)url timeoutInterval:(NSTimeInterval)timeoutInterval andDelegate:(id)delegate andSelector:(SEL)selector andObject:(id)object
{
    if ((self = [super init]))
    {
        _selector = selector;
        _timeoutInterval = timeoutInterval;
        
        _url = [url retain];
        _object = [object retain];
        _delegate = [delegate retain];
    }
    
    return self;
}

- (void) dealloc
{
	[_delegate release];
    [_url release];
    [_object release];
    
	[super dealloc];
}

- (void) main
{
    SnSLogD(@"Getting remotely the data corresponding to the URL '%@'", _url);
    //TODO: do not necessarily use the default cache
    NSData * data = [[SnSURLCache instance] getFromCache:_url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_timeoutInterval];
    SnSURLCacheData * urlCacheData = [[SnSURLCacheData alloc] initWith:data andObject:_object];
    [_delegate performSelector:_selector withObject:urlCacheData];
}

@end

#pragma mark -
#pragma mark SnSURLCacheException

@implementation SnSURLCacheException

@synthesize cause = _cause;

+ (void) raise:(NSError *)error
{
    @throw [[SnSURLCacheException alloc] initWithError:error];
}

- (id) initWithError:(NSError *)error
{
    if ((self = [super initWithName:[error domain] reason:[[error userInfo] objectForKey:@"NSLocalizedDescription"]
                           userInfo:[error userInfo]]))
        _cause = [error retain];
    return self;
}

- (void)dealloc
{
    SnSReleaseAndNil(_cause);
    [super dealloc];
}

@end

#pragma mark -
#pragma mark SnSURLCache

@interface SnSURLCache(Private)

- (NSString *) computeCacheFilePath:(NSString *)url andFileName:(NSString *)fileName;
- (NSString *) computeURLMatch:(NSURLRequest *)urlRequest;
- (void) getURLMatchFor:(NSURLRequest *)urlRequest result:(NSString **)result;
- (void) getLocalURIMatchFor:(NSString *)url andFileName:(NSString *)fileName result:(NSString **)result;

+ (BOOL) isBinaryData:(NSString *)typeMIME;

@end

@implementation SnSURLCache

@synthesize cacheDirectoryPath;
@synthesize indexFilePath;
@synthesize cache;
@synthesize urlRequestMatcher;
@synthesize localUriMatcher;

@synthesize timeToLiveSeconds;
@synthesize diskPersistent;

SnSURLCache ** urlCacheInstances = nil;

+ (void) setInstances:(NSUInteger)count andMemoryCapacities:(NSUInteger [])memoryCapacities 
    andDiskCapacities:(NSUInteger [])diskCapacities andDiskPaths:(NSString * [])diskPaths 
      andTimeValidity:(NSTimeInterval)timeToLive andPersistence:(BOOL)diskPersistence
{
    SnSLogD(@"Initializing %i cache(s)", count);
    urlCacheInstances =  malloc(count * sizeof(SnSURLCache *));
    for (int index = 0; index < count; index++)
    {
        urlCacheInstances[index] = [[SnSURLCache alloc] initWithMemoryCapacity:memoryCapacities[index] diskCapacity:diskCapacities[index] diskPath:diskPaths[index] 
                                                               andTimeValidity:timeToLive andPersistence:diskPersistence];
    }
}

+ (SnSURLCache *) instance
{
    @synchronized (self)
    {
        if (urlCacheInstances == nil)
        {
            NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString * filePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], @"cache"];
            NSString * diskPaths [] = { filePath };
            NSUInteger memoryCapacities [] = { 512 * 1024 };
            NSUInteger diskCapacities [] = { 10 * 1024 * 1024 };
            BOOL persistence = YES;
            NSTimeInterval timeToLive = 15*60;// 15 minutes
            [SnSURLCache setInstances:1 andMemoryCapacities:memoryCapacities 
                    andDiskCapacities:diskCapacities andDiskPaths:diskPaths 
                      andTimeValidity:timeToLive andPersistence:persistence];
        }
    }
    [NSURLCache setSharedURLCache:[SnSURLCache instance:0]];
    return [SnSURLCache instance:0];
}

+ (SnSURLCache *) instance:(NSUInteger)index
{
    return urlCacheInstances[index];
}

- (NSData *) getFromCache:(NSURLRequest *)urlRequest
{
    // There is a warning because of the macro expansion: the url variable is only used inside the macro!
    SnSLogD(@"Analyzing whether the data is in cache regarding the URL '%@'", [[urlRequest URL] absoluteString]);
    NSURLCache * urlCache = [NSURLCache sharedURLCache];
    NSCachedURLResponse * cachedUrlResponse =  [urlCache cachedResponseForRequest:urlRequest];
    NSData * data = nil;
    @try
    {
        if (cachedUrlResponse == nil)
        {
            SnSLogD(@"The data is not in local cache regarding the URL '%@'", urlRequest);
            NSError * error = nil;
            //data = [NSData dataWithContentsOfURL:theUrl options:NSUncachedRead error:&error];
            NSHTTPURLResponse * urlResponse = nil;
            data = [[NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error] retain];
            if (error != nil)
            {
                SnSLogD(@"Error while retrieving the data regarding the URL '%@'", urlRequest);
                [data release];
                [SnSURLCacheException raise:error];
            }
            else if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]] && [urlResponse statusCode] != 200)
            {
                SnSLogD(@"Received a response from server with status code %i corresponding to the URL '%@'", [urlResponse statusCode], urlRequest);
//                [data release];
                __unused NSString *errorName = (data == nil ? @"Bad response from server" : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
				SnSLogE(@"%@ - Status Code %i", errorName, [urlResponse statusCode]);
//                @throw [[SnSURLCacheException alloc] initWithName:errorName
//														   reason:[NSString stringWithFormat:@"Status code: %i", [urlResponse statusCode]]
//														 userInfo:nil];
            }
            else if (data == nil)
            {
                SnSLogD(@"There are no data regarding the URL '%@'", urlRequest);
            }
            else
            {
                //NSURLResponse * urlResponse = [[NSURLResponse alloc] initWithURL:theUrl MIMEType:nil expectedContentLength:[data length] textEncodingName:nil];
                cachedUrlResponse = [[NSCachedURLResponse alloc] initWithResponse:urlResponse data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
                [urlCache storeCachedResponse:cachedUrlResponse forRequest:urlRequest];
                // We do not release the non-cached response, because the cached one will release it
            }
        }
        else
        {
            SnSLogD(@"The data is in local cache regarding the URL '%@'", urlRequest);
            // We duplicate the data, in order to make sure that there will be no memory corruption
            data = [[NSData alloc] initWithData:[cachedUrlResponse data]];
        }
    }
    @finally
    {
        // We do not release the URL, because it is released by the NSURLRequest!
        // And we do not release the URL request, because it seems to be released by the cached URL response!
        //[cachedUrlResponse release];
    }
    return data;  
}

+ (BOOL) isBinaryData:(NSString *)typeMIME
{
    if ([typeMIME isEqualToString:TYPE_MIME_OCTET_STREAM] || [typeMIME hasPrefix:TYPE_MIME_IMAGE]) 
    {
        return YES;
    }
    
    return NO;
}

- (NSData *) getFromCache:(NSString *)url cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    if (url == nil)
    {
        SnSLogW(@"Asking the cache for a null URL");
        return nil;
    }
    NSURL * theUrl = [NSURL URLWithString:url];
    NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:theUrl cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    NSData * data;
    @try
    {
        data = [self getFromCache:urlRequest];
    }
    @finally
    {
        [urlRequest release];
    }
    return data;
}

- (NSData *) getFromCache:(NSString *)url timeoutInterval:(NSTimeInterval)timeoutInterval andDelegate:(SnSDelegateWithObject *)delegate
{
    NSData * data = nil;
    // We first attempt to load the data from the local cache
    @try
    {
        data = [self getFromCache:url cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:timeoutInterval];
    }
    @catch (NSException * exception)
    {
        // The data does not seem to be availale in the cache
        if ([exception class] != [NSURLErrorDomain class])
        {
            SnSLogEW(exception, @"An unexpected exception occurred while attemping to retrieve the data from the cache with the URL '%@'", url);
        }
    }
    
    // And then remotely
    //if (data == nil)
    {
        static NSOperationQueue * queue;
        if (queue == nil)
        {
            queue = [[NSOperationQueue alloc] init];
        }
        SnSLogD(@"Reloading the data corresponding to the URL '%@'", url);
        SnSDownloadOperation * downloadOperation = [[SnSDownloadOperation alloc] initWith:url timeoutInterval:timeoutInterval andDelegate:delegate];
        [queue addOperation:downloadOperation];
        [downloadOperation release];
    }
    return data;  
}

- (NSData *) getFromCache:(NSString *)url timeoutInterval:(NSTimeInterval)timeoutInterval andDelegate:(id)delegate andSelector:(SEL)selector andObject:(id)object
{
    NSData * data = nil;
    // We first attempt to load the data from the local cache
    @try
    {
        data = [self getFromCache:url cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:timeoutInterval];
    }
    @catch (NSException * exception)
    {
        // The data does not seem to be availale in the cache
        if ([exception class] != [NSURLErrorDomain class])
        {
            SnSLogEW(exception, @"An unexpected exception occurred while attemping to retrieve the data from the cache with the URL '%@'", url);
        }
    }
    
    // And then remotely
    //if (data == nil)
    {
        static NSOperationQueue * queue;
        if (queue == nil)
        {
            queue = [[NSOperationQueue alloc] init];
        }
        SnSLogD(@"Reloading the data corresponding to the URL '%@'", url);
        SnSDownloadOperation * downloadOperation = [[SnSDownloadOperation alloc] initWith:url timeoutInterval:timeoutInterval andDelegate:delegate andSelector:selector andObject:object];
        [queue addOperation:downloadOperation];
        [downloadOperation release];
    }
    return data;
}

- (id) initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path  
              andTimeValidity:(NSTimeInterval)timeToLive andPersistence:(BOOL)onDisk
{
    SnSLogD(@"Initializing the cache with a persistence set at '%@'", path);
    if ((self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]))
    {
        cacheDirectoryPath = [path retain];
    
        NSFileManager * fileManager = [NSFileManager defaultManager];
        BOOL isDirectory;
        if ([fileManager fileExistsAtPath:self.cacheDirectoryPath isDirectory:&isDirectory] == NO || isDirectory == FALSE)
        {
            //[fileManager createDirectoryAtPath:self.cacheDirectoryPath attributes:nil];
            NSError * error;
            [fileManager createDirectoryAtPath:self.cacheDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
    
        indexFilePath = [[NSString pathWithComponents:[NSArray arrayWithObjects:self.cacheDirectoryPath,
                                                       [NSString stringWithFormat:@"SnsURLCache_%@.plist", @"1.0"], nil]] retain];
        SnSLogD(@"Storing the cache files under the directory '%@', and the index file at '%@'", self.cacheDirectoryPath, self.indexFilePath);
        cache = [[NSMutableDictionary dictionaryWithContentsOfFile:self.indexFilePath] retain];
        if (self.cache == nil)
        {
            SnSLogD(@"The cache is empty: creating a new one");
            cache = [[NSMutableDictionary dictionary] retain];
        }
    
        // We set a default URL request catcher
        [self setURLRequestMatcher:[[SnSDelegate alloc] initWith:self andSelector:@selector(getURLMatchFor:result:)]];
    
        // set time data to be alive
        timeToLiveSeconds = timeToLive;
    
        diskPersistent = onDisk;
    }

	return self;
}

- (id) initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path
{
    return [self initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path
                        andTimeValidity:24*60*60 andPersistence:YES];
}

- (void) dealloc
{
    SnSLogD(@"Deallocating the cache");
	[cache release], cache = nil;
	[indexFilePath release], indexFilePath = nil;
	[cacheDirectoryPath release], cacheDirectoryPath = nil;
    [urlRequestMatcher release], urlRequestMatcher = nil;
    
	[super dealloc];
}

- (BOOL) dataIsAvailable:(NSDictionary *) cacheInfo withoutNetwork:(BOOL)network withCachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
    // Dans le cas de données binaire on a un cache infini
    NSDate * timestamp = [NSDate dateWithTimeIntervalSince1970:[((NSNumber *)[cacheInfo valueForKey:@"timestamp"]) doubleValue]];
    NSDate * now = [NSDate date];
    if (cachePolicy != NSURLRequestReloadIgnoringCacheData)
    {
        if (self.timeToLiveSeconds == 0)
        {
            SnSLogD(@"dataIsAvailable : durée de validité infinie");
            return YES;
        }
        else if ([SnSURLCache isBinaryData:[cacheInfo valueForKey:@"type"]]) 
        {
            SnSLogD(@"dataIsAvailable : donnée binaire");
            return YES;
        }
        else if ([now timeIntervalSinceDate:timestamp] < self.timeToLiveSeconds && self.timeToLiveSeconds > 0)
        {
            SnSLogD(@"dataIsAvailable : durée de validité encore bonne");
            return YES;
        }
        else if (network && [UIDevice networkConnected] == NO) 
        {
            SnSLogD(@"dataIsAvailable : network validité");
            // the data is available until network is available to maximise the access of the data
            return YES;
        }
    }
    else
    {
        if (network && [UIDevice networkConnected] == NO) 
        {
            SnSLogD(@"dataIsAvailable : network validité");
            // the data is available until network is available to maximise the access of the data
            return YES;
        }
    }
    
    
    return NO; 
    
}

- (NSCachedURLResponse *) cachedResponseForRequest:(NSURLRequest *)urlRequest
{
    NSCachedURLResponse * cachedUrlResponse = nil;
    // The object may be in memory cache
    /*NSCachedURLResponse * cachedUrlResponse = [super cachedResponseForRequest:urlRequest];
     if (cachedUrlResponse != nil)
     {
     return cachedUrlResponse;
     }*/
    NSString * url = [[urlRequest URL] absoluteString];
	@synchronized (self)
    {
		if ([url hasPrefix:@"http://www.google.com/glm/mmap"]) 
        {
            return cachedUrlResponse;
        }
        
        NSDictionary * cacheInfo = [self.cache objectForKey:[self computeURLMatch:urlRequest]];
		if (cacheInfo != nil)
        {
			// Check the validity of content
            SnSLogI(@"cacheInfo = %@ ", [cacheInfo description]);
            SnSLogI(@"[cacheInfo valueForKey:@\"timestamp\"] = %@ ", [[cacheInfo valueForKey:@"timestamp"] description]);
            SnSLogI(@"timestamp = %@ ", [NSDate dateWithTimeIntervalSince1970:[((NSNumber *)[cacheInfo valueForKey:@"timestamp"]) doubleValue]]);
            SnSLogI(@"now = %@ ", [NSDate date]);
            SnSLogI(@"type = %@ ", [[cacheInfo valueForKey:@"type"] description]);
            
            if ([self dataIsAvailable:cacheInfo withoutNetwork:YES withCachePolicy:[urlRequest cachePolicy]]) 
            {
                SnSLogI(@"Reusing the cache corresponding to the URL '%@'", [[urlRequest URL] absoluteString]);
                NSURLResponse * urlResponse = [[NSURLResponse alloc] initWithURL:[urlRequest URL] MIMEType:[cacheInfo valueForKey:@"type"] expectedContentLength:((NSInteger) [cacheInfo valueForKey:@"length"]) textEncodingName:((NSString *) [cacheInfo valueForKey:@"encoding"])];
                NSString * fileName = [cacheInfo valueForKey:@"name"];
                NSString * filePath = [self computeCacheFilePath:[[urlRequest URL] absoluteString] andFileName:fileName];
                NSData * data = [[NSData alloc] initWithContentsOfFile:filePath];
                cachedUrlResponse = [[[NSCachedURLResponse alloc] initWithResponse:urlResponse data:data] autorelease];
                [data release];
                [urlResponse release];
                return cachedUrlResponse;
            }
            else 
            {
                SnSLogI(@"NOT Reusing the cache corresponding to the URL '%@'", [[urlRequest URL] absoluteString]);
                // Data is not valid and remove it
                [cache removeObjectForKey:[self computeURLMatch:urlRequest]];
                return cachedUrlResponse;
            }
            
        }
    }
    SnSLogD(@"There is no cache related to the URL '%@'", [[urlRequest URL] absoluteString]);
    return cachedUrlResponse;
}

- (void) storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)urlRequest
{
    // We test the original URL request caching policy
    /*NSURLRequestCachePolicy cachePolicy = [urlRequest cachePolicy];
     if (cachePolicy == NSURLRequestUseProtocolCachePolicy || cachePolicy == NSURLRequestReloadIgnoringLocalCacheData || cachePolicy == NSURLRequestReloadIgnoringLocalAndRemoteCacheData || cachePolicy == NSURLRequestReloadIgnoringCacheData)
     {
     return;
     }*/
    
    NSURLResponse * response = [cachedResponse response];
    __unused NSString *url = [[response URL] absoluteString];
    if (cachedResponse.storagePolicy != NSURLCacheStorageAllowed)// || [urlRequest cachePolicy] != NSURLRequestReturnCacheDataElseLoad)
    {
        SnSLogD(@"Letting the parent cache storing the data related to the URL '%@'", url);
        [super storeCachedResponse:cachedResponse forRequest:urlRequest];
        return;
    }
    
    @synchronized (self)
    {
        //SnSLogD(@"Number of objects in the cache: %i", [self.cache count]);
        // Check that the URL is not already in cache
        NSString * fileName = nil;
        //NSMutableDictionary * cacheInfo = [self.cache objectForKey:url];
        NSString * cachedUri = [self computeURLMatch:urlRequest];
        NSDictionary * cacheInfo = [self.cache objectForKey:cachedUri];
        const BOOL alreadyInCache = (cacheInfo != nil);
        if (cacheInfo == nil)
        {
            // We generate a unique file name ...
            CFUUIDRef uuid = CFUUIDCreate(NULL);
            CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
            fileName =  [NSString stringWithFormat:@"%@", uuidString];
            CFRelease(uuidString);
            CFRelease(uuid);
            SnSLogD(@"Creating a new cache file '%@'", fileName);
        }
        else
        {
            fileName = [cacheInfo valueForKey:@"name"];
            SnSLogD(@"Reusing the already cached file '%@'", fileName);
        }
        
        @try
        {
            NSString * filePath = [self computeCacheFilePath:[[urlRequest URL] absoluteString] andFileName:fileName];
            SnSLogD(@"Storing the response corresponding to the URL '%@' to the file '%@'", url, filePath);
            
            // ... we save the data ...
            if ([cachedResponse.data writeToFile:filePath atomically:YES] == NO)
            {
                SnSLogE(@"Could not store the response corresponding to the URL '%@' to the file with name '%@'", url, fileName);
                // In that case, we do not save the entry
                return;
            }
            
            if (alreadyInCache == NO)
            {
                // ... we create the dictionary ...
                cacheInfo = [[NSMutableDictionary alloc] init];
                [cacheInfo setValue:fileName forKey:@"name"];     
                [self.cache setObject:cacheInfo forKey:cachedUri];
            }
            // ... we update the dictionary, because the cached data may have changed
            [cacheInfo setValue:[NSNumber numberWithLongLong:[response expectedContentLength]] forKey:@"length"];
            SnSLogI(@"storeCachedResponse: type MIME = '%@'", [response MIMEType]);
            [cacheInfo setValue:[response MIMEType] forKey:@"type"];
            [cacheInfo setValue:[response textEncodingName] forKey:@"encoding"];
            [cacheInfo setValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
            // ... eventually, we save the index file
            //SnSLogD(@"Saving the cache index file");
            if ([self.cache writeToFile:self.indexFilePath atomically:YES] == NO)
            {
                SnSLogE(@"Could not save the cache index file '%@'", self.indexFilePath);
            }
        }
        @finally
        {
            [super storeCachedResponse:cachedResponse forRequest:urlRequest];
        }
    }
}

- (NSURL *) getCachedURL:(NSString *)url
{
    NSDictionary * cacheInfo = [self.cache objectForKey:[self computeURLMatch:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]]];
    if (cacheInfo != nil)
    {
        NSString * fileName = [cacheInfo valueForKey:@"name"];
        NSString * filePath = [self computeCacheFilePath:url andFileName:fileName];
        return [NSURL fileURLWithPath:filePath];
    }
    return nil;
}

- (void) setURLRequestMatcher:(SnSDelegate *)delegate
{
    urlRequestMatcher = [delegate retain];
}

- (NSString *) computeURLMatch:(NSURLRequest *)urlRequest
{
    NSString * result;
    
    if (self.urlRequestMatcher.delegate == self)
    {   // The default URL request matcher is used: for optimization, we call it directly
        [self getURLMatchFor:urlRequest result:&result];
    }
    else
    {   // We increase the URL request matcher delegate, because the "perform" will release it
        [self.urlRequestMatcher perform:urlRequest andObject:(id)&result];
    }
    
    return result;
}

- (void) getURLMatchFor:(NSURLRequest *)urlRequest result:(NSString **)result
{
    *result = [[urlRequest URL] absoluteString];
}

- (void) setLocalURIMatcher:(SnSDelegate *)delegate
{
    localUriMatcher = [delegate retain];
}

- (NSString *) computeCacheFilePath:(NSString *)url andFileName:(NSString *)fileName
{
    NSString * result;
    if (self.localUriMatcher == nil || self.localUriMatcher.delegate == self)
    {
        // The default local URI matcher is used: for optimization, we call it directly
        [self getLocalURIMatchFor:url andFileName:fileName result:&result];
        return result;
    }
    // We increase the local URI matcher delegate, because the "perform" will release it
    [self.localUriMatcher perform:url andObject:(id)fileName andObject:(id)&result];
    
    // We now append the file directory path
    return [NSString pathWithComponents:[NSArray arrayWithObjects:self.cacheDirectoryPath, result, nil]];
}

- (void) getLocalURIMatchFor:(NSString *)url andFileName:(NSString *)fileName result:(NSString **)result
{
    *result = [NSString pathWithComponents:[NSArray arrayWithObjects:self.cacheDirectoryPath, fileName, nil]];
}

- (void) empty
{
    SnSLogI(@"Emptying the cache");
    @synchronized (self)
    {
        // We erase the cache files
        for (NSString * key in [self.cache keyEnumerator])
        {
            NSDictionary * cacheInfo = [self.cache objectForKey:key];
            NSString * filePath = [self computeCacheFilePath:[cacheInfo objectForKey:@""] andFileName:[cacheInfo objectForKey:@"name"]];
            NSError * error;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        }
        [self.cache removeAllObjects];
        if ([self.cache writeToFile:self.indexFilePath atomically:YES] == NO)
        {
            SnSLogE(@"Could not save the cache index file '%@'", self.indexFilePath);
        }    
    }
}

@end
