/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "Com0x82SocialComposerViewProxy.h"

#import "TiApp.h"

@implementation Com0x82SocialComposerViewProxy

- (SLComposeViewController *)composeViewController
{
  if (!composeViewController) {
    NSString *type = [self valueForUndefinedKey:@"type"];
    __weak __typeof__(self) weakSelf = self;

    if (!type) {
      [self throwException:@"You must specifiy a type of social network" subreason:@"Twitter, Facebook or Weibo" location:CODELOCATION];
    }

    composeViewController = [SLComposeViewController composeViewControllerForServiceType:type];
    composeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
      __typeof__(self) strongSelf = weakSelf;

      if ([strongSelf _hasListeners:@"complete"]) {
        [strongSelf fireEvent:@"complete" withObject:@{ @"result" : @(result) }];
      }

      [[TiApp app] hideModalController:composeViewController animated:YES];
    };
  }

  return composeViewController;
}

- (id)isServiceAvailable:(id)args
{
  NSString *type = nil;
  ENSURE_ARG_AT_INDEX(type, args, 0, NSString);

  return @([SLComposeViewController isAvailableForServiceType:type]);
}

- (id)setInitialText:(id)text
{
  __block BOOL ret;

  TiThreadPerformOnMainThread(^{
    ret = [[self composeViewController] setInitialText:text];
  },
      YES);

  return @(ret);
}

- (id)addImage:(id)args
{
  TiBlob *blob = nil;
  ENSURE_ARG_AT_INDEX(blob, args, 0, TiBlob);

  UIImage *image = [blob image];

  __block BOOL ret;
  TiThreadPerformOnMainThread(^{
    ret = [[self composeViewController] addImage:image];
  },
      YES);

  return @(ret);
}

- (id)removeAllImages:(id)args
{
  __block BOOL ret;
  TiThreadPerformOnMainThread(^{
    ret = [[self composeViewController] removeAllImages];
  },
      YES);

  return @(ret);
}

- (id)addURL:(id)args
{
  NSString *urlString = [TiUtils stringValue:[args objectAtIndex:0]];

  __block BOOL ret;
  TiThreadPerformOnMainThread(^{
    ret = [[self composeViewController] addURL:[NSURL URLWithString:urlString]];
  },
      YES);

  return @(ret);
}

- (id)removeAllURLs:(id)args
{
  __block BOOL ret;
  TiThreadPerformOnMainThread(^{
    ret = [[self composeViewController] removeAllURLs];
  },
      YES);

  return @(ret);
}

- (void)open:(id)args
{
  ENSURE_UI_THREAD(open, args);
  [[TiApp app] showModalController:[self composeViewController] animated:YES];
}

@end
