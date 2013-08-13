/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "Com0x82SocialAccountCredentialProxy.h"

#import "TiUtils.h"

@implementation Com0x82SocialAccountCredentialProxy
@synthesize credential = _credential;

-(void)dealloc {
	RELEASE_TO_NIL(_credential);
	[super dealloc];
}

-(ACAccountCredential *)credential {
	if(_credential == nil) {
		if([self valueForUndefinedKey:@"oauth_token"]) {
			NSString *token  = [TiUtils stringValue:[self valueForUndefinedKey:@"oauth_token"]];
			NSString *secret = [TiUtils stringValue:[self valueForUndefinedKey:@"token_secret"]];
			
			_credential = [[ACAccountCredential alloc] initWithOAuthToken:token tokenSecret:secret];
		} else if([self valueForUndefinedKey:@"oauth2_token"]) {
			NSString *token   = [TiUtils stringValue:[self valueForUndefinedKey:@"oauth2_token"]];
			NSString *refresh = [TiUtils stringValue:[self valueForUndefinedKey:@"refresh_token"]];
			NSDate *expires_at = (NSDate *)[self valueForUndefinedKey:@"expiricy_date"];
			
			_credential = [[ACAccountCredential alloc] initWithOAuth2Token:token refreshToken:refresh expiryDate:expires_at];
		}
	}
	
	return _credential;
}

-(id)oauthToken {
	return [self credential].oauthToken;
}

-(id)oauthRefreshToken {
	return [[self credential] oauthRefreshToken];
}

-(id)expiryDate {
	return [[self credential] expiryDate];
}

@end
