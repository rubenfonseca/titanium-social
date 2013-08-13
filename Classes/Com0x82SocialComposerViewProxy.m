/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "Com0x82SocialComposerViewProxy.h"

#import "TiApp.h"

@implementation Com0x82SocialComposerViewProxy {
	SLComposeViewController *composeViewController;
}

-(SLComposeViewController *)composeViewController {
	if(!composeViewController) {
		NSString *type = [self valueForUndefinedKey:@"type"];
		
		if(!type) {
			[self throwException:@"You must specifiy a type of social network" subreason:@"twitter, facebook, sinaweibo" location:CODELOCATION];
		}
		
		composeViewController = [[SLComposeViewController composeViewControllerForServiceType:type] retain];
		composeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
			if([self _hasListeners:@"complete"]) {
				[self fireEvent:@"complete" withObject:@{ @"result" : @(result) }];
			}
			
			[composeViewController dismissViewControllerAnimated:YES completion:nil];
		};
	}
	
	return composeViewController;
}

-(void)dealloc {
	RELEASE_TO_NIL(composeViewController);
	[super dealloc];
}

-(id)isServiceAvailable:(id)args {
	NSString *type; ENSURE_ARG_AT_INDEX(type, args, 0, NSString);
	
	return @([SLComposeViewController isAvailableForServiceType:type]);
}

-(id)setInitialText:(id)text {
	__block BOOL ret;
	
	TiThreadPerformOnMainThread(^{
		ret = [[self composeViewController] setInitialText:text];
	}, YES);
	
	return @(ret);
}

-(id)addImage:(id)args {
	TiBlob *blob; ENSURE_ARG_AT_INDEX(blob, args, 0, TiBlob);
	UIImage *image = [blob image];
	
	__block BOOL ret;
	TiThreadPerformOnMainThread(^{
		ret = [[self composeViewController] addImage:image];
	}, YES);
	
	return @(ret);
}

-(id)removeAllImages:(id)args {
	__block BOOL ret;
	TiThreadPerformOnMainThread(^{
		ret = [[self composeViewController] removeAllImages];
	}, YES);
	
	return @(ret);
}

-(id)addURL:(id)args {
	NSString *urlString = [TiUtils stringValue:[args objectAtIndex:0]];
	
	__block BOOL ret;
	TiThreadPerformOnMainThread(^{
		ret = [[self composeViewController] addURL:[NSURL URLWithString:urlString]];
	}, YES);
	
	return @(ret);
}

-(id)removeAllURLs:(id)args {
	__block BOOL ret;
	TiThreadPerformOnMainThread(^{
		ret = [[self composeViewController] removeAllURLs];
	}, YES);
	
	return @(ret);
}

-(void)open:(id)args {
	ENSURE_UI_THREAD_0_ARGS
	
	UIViewController *controller = [[[TiApp app] controller] focusedViewController];
	[controller presentViewController:[self composeViewController] animated:YES completion:nil];
	
//	[[TiApp app] showModalController:[self composeViewController] animated:YES];
}

@end
