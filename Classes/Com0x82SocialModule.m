/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "Com0x82SocialModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "TiApp.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

@implementation Com0x82SocialModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID {
	return @"d355cdec-34bf-4129-b2de-74265fb3e382";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId {
	return @"com.0x82.social";
}

#pragma mark Lifecycle

-(void)startup {
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
	
	NSString *className = @"SLComposeViewController";
	
	if(NSClassFromString(className) == nil) {
		[self throwException:@"The Social module only works on iOS6 or later" subreason:@"You are running an older version of iOS" location:CODELOCATION];
		return;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_canSendMessages) name:ACAccountStoreDidChangeNotification object:nil];
}

-(void)showActivityItems:(id)args {
	dispatch_async(dispatch_get_main_queue(), ^{
		NSDictionary *options; ENSURE_ARG_AT_INDEX(options, args, 0, NSDictionary);
		
		BOOL animated = [TiUtils boolValue:@"animated" properties:options def:YES];
		NSArray *activityItems; ENSURE_ARG_FOR_KEY(activityItems, options, @"activityItems", NSArray);
		NSArray *excludedActivityItems; ENSURE_ARG_OR_NIL_FOR_KEY(excludedActivityItems, options, @"excludedActivityTypes", NSArray);
		
		NSMutableDictionary *rect = [NSMutableDictionary dictionaryWithDictionary:@{ @"x":@(0), @"y":@(0), @"width":@(0), @"height":@(0) }];
		if(options[@"rect"]) {
			rect[@"x"] = @([TiUtils intValue:@"x" properties:options[@"rect"] def:0]);
			rect[@"y"] = @([TiUtils intValue:@"y" properties:options[@"rect"] def:0]);
			rect[@"width"]  = @([TiUtils intValue:@"width" properties:options[@"rect"] def:0]);
			rect[@"height"] = @([TiUtils intValue:@"height" properties:options[@"rect"] def:0]);
		}
		UIPopoverArrowDirection arrowDirection = [TiUtils intValue:@"arrowDirection" properties:options def:UIPopoverArrowDirectionAny];
		
		// Check for errors
		NSMutableArray *items = [NSMutableArray array];
		[activityItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if([obj isKindOfClass:[NSString class]]) {
				NSString * str = (NSString *) obj;
				NSURL *shareURL = [NSURL URLWithString:str];
				if (shareURL != NULL) {
					[items addObject:shareURL];
					NSLog(@"share URL %@", shareURL);
				} else {
					[items addObject:obj];
				}
			} else if([obj isKindOfClass:[TiBlob class]]) {
				[items addObject:((TiBlob *)obj).image];
			} else {
				NSString *format = [NSString stringWithFormat:@"activityItem %@ is not a String nor a TiBlob", [obj class]];
				[self throwException:format subreason:nil location:CODELOCATION];
				*stop = YES;
			}
		}];
		
		NSMutableArray *excluded = [NSMutableArray array];
		if(excludedActivityItems) {
			[excludedActivityItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				if([obj isKindOfClass:[NSString class]])
					[excluded addObject:obj];
				else {
					[self throwException:@"Unknown excluded activity type" subreason:nil location:CODELOCATION];
					*stop = YES;
				}
			}];
		}
		
		UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
		avc.excludedActivityTypes = excluded;
		avc.completionHandler = ^(NSString *activityType, BOOL completed) {
			[self fireEvent:@"activityWindowClosed" withObject:@{
			  @"activityType": activityType ? activityType : [NSNull null],
			 	@"completed": @(completed)
			}];
		};
		
		if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone || !options[@"rect"]) {
      [[TiApp app] showModalController:avc animated:animated];
      [self fireEvent:@"activityWindowOpened" withObject:nil];
		} else {
			UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:avc];
			popover.delegate = self;
			
			int x = [rect[@"x"] intValue];
			int y = [rect[@"y"] intValue];
			int width = [rect[@"width"] intValue];
			int height = [rect[@"height"] intValue];
			
			CGRect rect = CGRectMake(x, y, width, height);
			[popover presentPopoverFromRect:rect inView:[[TiApp app] topMostView] permittedArrowDirections:arrowDirection animated:animated];
		}
		
		[avc autorelease];
	});
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[popoverController release];
}

-(void)_canSendMessages {
	NSDictionary *capabilities = @{
		@"twitter"   : @([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]),
		@"facebook"  : @([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]),
		@"sinaweibo" : @([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
	};
	
	if([self _hasListeners:@"update"]) {
		[self fireEvent:@"update" withObject:@{ @"availability" : capabilities }];
	}
}

#pragma Public APIs

MAKE_SYSTEM_NUMBER(DONE, @(SLComposeViewControllerResultDone));
MAKE_SYSTEM_NUMBER(CANCELLED, @(SLComposeViewControllerResultCancelled));

MAKE_SYSTEM_NUMBER(REQUEST_METHOD_GET, @(SLRequestMethodGET));
MAKE_SYSTEM_NUMBER(REQUEST_METHOD_POST, @(SLRequestMethodPOST));
MAKE_SYSTEM_NUMBER(REQUEST_METHOD_DELETE, @(SLRequestMethodDELETE));

MAKE_SYSTEM_STR(TWITTER, SLServiceTypeTwitter);
MAKE_SYSTEM_STR(FACEBOOK, SLServiceTypeFacebook);
MAKE_SYSTEM_STR(SINAWEIBO, SLServiceTypeSinaWeibo);

MAKE_SYSTEM_STR(ACCOUNT_TWITTER, ACAccountTypeIdentifierTwitter);
MAKE_SYSTEM_STR(ACCOUNT_FACEBOOK, ACAccountTypeIdentifierFacebook);
MAKE_SYSTEM_STR(ACCOUNT_SINAWEIBO, ACAccountTypeIdentifierSinaWeibo);

MAKE_SYSTEM_STR(FACEBOOK_APP_ID, ACFacebookAppIdKey);
MAKE_SYSTEM_STR(FACEBOOK_PERMISSIONS, ACFacebookPermissionsKey);
MAKE_SYSTEM_STR(FACEBOOK_AUDIENCE, ACFacebookAudienceKey);
MAKE_SYSTEM_STR(FACEBOOK_AUDIENCE_EVERYONE, ACFacebookAudienceEveryone);
MAKE_SYSTEM_STR(FACEBOOK_AUDIENCE_FRIENDS, ACFacebookAudienceFriends);
MAKE_SYSTEM_STR(FACEBOOK_AUDIENCE_ONLY_ME, ACFacebookAudienceOnlyMe);

MAKE_SYSTEM_NUMBER(RENEW_RESULT_RENEWED, @(ACAccountCredentialRenewResultRenewed));
MAKE_SYSTEM_NUMBER(RENEW_RESULT_REJECTED, @(ACAccountCredentialRenewResultRejected));
MAKE_SYSTEM_NUMBER(RENEW_RESULT_FAILED, @(ACAccountCredentialRenewResultFailed));

MAKE_SYSTEM_STR(UIActivityTypePostToFacebook, UIActivityTypePostToFacebook);
MAKE_SYSTEM_STR(UIActivityTypePostToTwitter, UIActivityTypePostToTwitter);
MAKE_SYSTEM_STR(UIActivityTypePostToWeibo, UIActivityTypePostToWeibo);
MAKE_SYSTEM_STR(UIActivityTypeMessage, UIActivityTypeMessage);
MAKE_SYSTEM_STR(UIActivityTypeMail, UIActivityTypeMail);
MAKE_SYSTEM_STR(UIActivityTypePrint, UIActivityTypePrint);
MAKE_SYSTEM_STR(UIActivityTypeCopyToPasteboard, UIActivityTypeCopyToPasteboard);
MAKE_SYSTEM_STR(UIActivityTypeAssignToContact, UIActivityTypeAssignToContact);
MAKE_SYSTEM_STR(UIActivityTypeSaveToCameraRoll, UIActivityTypeSaveToCameraRoll);

MAKE_SYSTEM_UINT(UIPopoverArrowDirectionAny, UIPopoverArrowDirectionAny);
MAKE_SYSTEM_UINT(UIPopoverArrowDirectionUp, UIPopoverArrowDirectionUp);
MAKE_SYSTEM_UINT(UIPopoverArrowDirectionDown, UIPopoverArrowDirectionDown);
MAKE_SYSTEM_UINT(UIPopoverArrowDirectionLeft, UIPopoverArrowDirectionLeft);
MAKE_SYSTEM_UINT(UIPopoverArrowDirectionRight, UIPopoverArrowDirectionRight);

@end
