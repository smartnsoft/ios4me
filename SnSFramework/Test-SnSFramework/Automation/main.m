/* 
 * Copyright (C) 2009-2010 Smart&Soft.
 * All rights reserved.
 *
 * The code hereby is the full property of Smart&Soft, SIREN 517 961 744.
 * http://www.smartnsoft.com - contact@smartnsoft.com
 * 
 * You are not allowed to use the source code or the resulting binary code, nor to modify the source code, without prior permission of the owner.
 */

//
//  main.m
//  Automation
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//  Created by ApplicationAuthor on ApplicationCreationDate.
//

#import <UIKit/UIKit.h>

void onSignal(int signal, siginfo_t * info, void * context);
void onUncaughtExceptionHandler(NSException * exception);

void onSignal(int signal, siginfo_t * info, void * context)
{
  SnSLogE(@"Received the signal %i!", signal);
}

void onUncaughtExceptionHandler(NSException * exception)
{
  SnSLogEE(exception, @"Received an uncaugth exception!");
}

int main(int argc, char * argv[])
{
  // This is taken from http://www.restoroot.com/Blog/2008/10/18/crash-reporter-for-iphone-applications/
  
  // We intercept all uncaugth exceptions
  NSSetUncaughtExceptionHandler(&onUncaughtExceptionHandler);
  
  // We intercept some of the signals
  struct sigaction signalAction;
  signalAction.sa_sigaction = onSignal;
  signalAction.sa_flags = SA_SIGINFO;
  sigemptyset(&signalAction.sa_mask);
  sigaction(SIGSEGV, &signalAction, nil);
  sigaction(SIGBUS, &signalAction, nil);
  
  // Caution, an auto-release pool is used in the main thread: see http://www.cocoadev.com/index.pl?DebuggingAutorelease
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  // We initialize the application with the customized delegate, but no main .xib defined
  int retVal = UIApplicationMain(argc, argv, nil, @"AutomationAppDelegate");
  [pool release];
  return retVal;
}
