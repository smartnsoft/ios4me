//
//  LnBServices.h
//  LooknBe
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark AutomationException

/**
 * An exception which may be thrown by the request call methods.
 */
@interface AutomationException : NSException
{
  id cause;
}

/**
 * The cause of the exception: may be <code>nil</code>
 */
@property(nonatomic, retain, readonly) id cause;

/**
 * @throws LnBException an exception built from the provided error
 */
+ (void) raise:(NSError *)error;
- (id) initWithError:(NSError *)error;

@end

#pragma mark -
#pragma mark AutomationServices

@interface AutomationServices : NSObject {

}

+ (AutomationServices *) instance;
- (id) init;

/******************** APNS Services ***************************/
- (void) updateUser:(NSString *)userUDID andToken:(NSString *)apnsToken;

/******************** Services Metier ***************************/

/******************** Services des Dictionnaires de Références ***************************/

@end
