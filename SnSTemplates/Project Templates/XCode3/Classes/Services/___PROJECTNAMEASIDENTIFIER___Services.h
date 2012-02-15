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
#pragma mark ___PROJECTNAMEASIDENTIFIER___Exception

/**
 * An exception which may be thrown by the request call methods.
 */
@interface ___PROJECTNAMEASIDENTIFIER___Exception : NSException
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
#pragma mark ___PROJECTNAMEASIDENTIFIER___Services

@interface ___PROJECTNAMEASIDENTIFIER___Services : NSObject {

}

+ (___PROJECTNAMEASIDENTIFIER___Services *) instance;
- (id) init;

/******************** APNS Services ***************************/
- (void) updateUser:(NSString *)userUDID andToken:(NSString *)apnsToken;

/******************** Services Metier ***************************/

/******************** Services des Dictionnaires de Références ***************************/

@end
