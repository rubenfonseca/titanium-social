/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "Com0x82SocialAccountProxy.h"
#import "Com0x82SocialAccountCredentialProxy.h"

#import "TiUtils.h"

@implementation Com0x82SocialAccountProxy {
  ACAccount *account;
  ACAccountType *accountType;
}

- (id)initWithAccount:(ACAccount *)otherAccount
{
  if (self = [super init]) {
    account = otherAccount;
    accountType = [otherAccount accountType];
  }

  return self;
}

- (void)_initWithProperties:(NSDictionary *)properties
{
  [super _initWithProperties:properties];

  NSString *type = [properties valueForKey:@"type"];
  if (!type) {
    [self throwException:@"Account type required" subreason:@"twitter, facebook, sinaweibo" location:CODELOCATION];

    return;
  }

  accountType = [[[ACAccountStore alloc] init] accountTypeWithAccountTypeIdentifier:type];
}

- (ACAccount *)account
{
  if (account == nil) {
    account = [[ACAccount alloc] initWithAccountType:accountType];
  }

  return account;
}

#pragma mark - Properties
- (id)description
{
  return [self account].accountDescription;
}

- (id)identifier
{
  return [self account].identifier;
}

- (id)username
{
  return [self account].username;
}

- (id)credential
{
  Com0x82SocialAccountCredentialProxy *credentials = [[Com0x82SocialAccountCredentialProxy alloc] init];
  credentials.credential = [self account].credential;

  return credentials;
}

- (void)setUsername:(id)arg
{
  [self account].username = [TiUtils stringValue:arg];
}

- (void)setCredential:(id)arg
{
  ENSURE_TYPE(arg, Com0x82SocialAccountCredentialProxy);

  [self account].credential = [(Com0x82SocialAccountCredentialProxy *)arg credential];
}

@end
