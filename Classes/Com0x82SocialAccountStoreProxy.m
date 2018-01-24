/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "Com0x82SocialAccountStoreProxy.h"
#import "Com0x82SocialAccountProxy.h"

#import "TiUtils.h"

@implementation Com0x82SocialAccountStoreProxy {
  ACAccountStore *accountStore;
  ACAccountType *accountType;
  NSDictionary *accountOptions;

  KrollCallback *saveSuccessCallback;
  KrollCallback *saveFailureCallback;

  KrollCallback *permissionGrantedCallback;
  KrollCallback *permissionDeniedCallback;

  KrollCallback *removeSuccessCallback;
  KrollCallback *removeFailureCallback;

  KrollCallback *renewSuccessCallback;
  KrollCallback *renewFailureCallback;
}

- (void)_initWithProperties:(NSDictionary *)properties
{
  accountStore = [[ACAccountStore alloc] init];

  NSString *type = [properties valueForKey:@"type"];
  if (!type) {
    [self throwException:@"You must specifiy a type of social network" subreason:@"twitter, facebook, sinaweibo" location:CODELOCATION];

    return;
  }

  accountType = [accountStore accountTypeWithAccountTypeIdentifier:type];

  accountOptions = [properties valueForKey:@"options"];
}

- (void)grantPermission:(id)array
{
  NSDictionary *args = [array objectAtIndex:0];

  permissionGrantedCallback = [args objectForKey:@"granted"];
  permissionDeniedCallback = [args objectForKey:@"denied"];

  [accountStore requestAccessToAccountsWithType:accountType
                                        options:accountOptions
                                     completion:^(BOOL granted, NSError *error) {
                                       if (granted) {
                                         if (permissionGrantedCallback)
                                           [self _fireEventToListener:@"granted" withObject:nil listener:permissionGrantedCallback thisObject:nil];
                                       } else {
                                         if (permissionDeniedCallback) {
                                           NSMutableDictionary *event = [NSMutableDictionary dictionary];
                                           if (error)
                                             event[@"error"] = [error localizedDescription];

                                           [self _fireEventToListener:@"denied" withObject:event listener:permissionDeniedCallback thisObject:nil];
                                         }
                                       }

                                       permissionGrantedCallback = nil;
                                       permissionDeniedCallback = nil;
                                     }];
}

- (id)accounts:(id)args
{
  NSArray *accounts = [accountStore accountsWithAccountType:accountType];

  NSMutableArray *retArray = [NSMutableArray array];
  for (ACAccount *account in accounts) {
    Com0x82SocialAccountProxy *accountProxy = [[Com0x82SocialAccountProxy alloc] initWithAccount:account];
    [retArray addObject:accountProxy];
  }

  return retArray;
}

- (id)accountWithIdentifier:(id)arg
{
  NSString *identifier = [TiUtils stringValue:[arg objectAtIndex:0]];

  ACAccount *account = [accountStore accountWithIdentifier:identifier];
  if (account) {
    return [[Com0x82SocialAccountProxy alloc] initWithAccount:account];
  } else {
    return nil;
  }
}

- (void)saveAccount:(id)args
{
  Com0x82SocialAccountProxy *accountProxy = nil;
  ENSURE_ARG_AT_INDEX(accountProxy, args, 0, Com0x82SocialAccountProxy);

  NSDictionary *dict = [args objectAtIndex:1];
  saveSuccessCallback = [dict valueForKey:@"success"];
  saveFailureCallback = [dict valueForKey:@"failure"];

  [accountStore saveAccount:accountProxy.account
      withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
          [self _fireEventToListener:@"success" withObject:nil listener:saveSuccessCallback thisObject:nil];
        } else {
          NSDictionary *event = @{ @"error" : [error localizedDescription] };

          [self _fireEventToListener:@"failure" withObject:event listener:saveFailureCallback thisObject:nil];
        }

        saveSuccessCallback = nil;
        saveFailureCallback = nil;
      }];
}

- (id)removeAccount:(id)args
{
  Com0x82SocialAccountProxy *account = nil;
  ENSURE_ARG_AT_INDEX(account, args, 0, Com0x82SocialAccountProxy);

  NSDictionary *options = nil;
  ENSURE_ARG_AT_INDEX(options, args, 1, NSDictionary);

  removeSuccessCallback = [options valueForKey:@"success"];
  removeFailureCallback = [options valueForKey:@"failure"];

  [accountStore removeAccount:account.account
        withCompletionHandler:^(BOOL success, NSError *error) {
          if (success) {
            [self _fireEventToListener:@"success" withObject:nil listener:removeSuccessCallback thisObject:nil];
          } else {
            NSDictionary *event = @{ @"error" : [error localizedDescription] };

            [self _fireEventToListener:@"failure" withObject:event listener:removeFailureCallback thisObject:nil];
          }

          removeSuccessCallback = nil;
          removeFailureCallback = nil;
        }];
}

- (void)renewCredentialsForAccount:(id)args
{
  Com0x82SocialAccountProxy *account = nil;
  ENSURE_ARG_AT_INDEX(account, args, 0, Com0x82SocialAccountProxy);

  NSDictionary *options = nil;

  ENSURE_ARG_AT_INDEX(options, args, 1, NSDictionary);
  renewSuccessCallback = [options valueForKey:@"success"];
  renewFailureCallback = [options valueForKey:@"failure"];

  [accountStore renewCredentialsForAccount:account.account
                                completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                                  if (error) {
                                    [self _fireEventToListener:@"failure" withObject:@{ @"error" : [error localizedDescription] } listener:renewFailureCallback thisObject:nil];
                                  } else {
                                    [self _fireEventToListener:@"success" withObject:@{ @"result" : @(renewResult) } listener:renewSuccessCallback thisObject:nil];
                                  }

                                  renewSuccessCallback = nil;
                                  renewFailureCallback = nil;
                                }];
}

@end
