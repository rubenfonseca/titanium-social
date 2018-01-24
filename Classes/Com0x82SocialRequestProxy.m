/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2012 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "Com0x82SocialRequestProxy.h"
#import "Com0x82SocialAccountProxy.h"

#import "TiUtils.h"

#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation Com0x82SocialRequestProxy {
  SLRequest *_request;
}

- (SLRequest *)request
{
  if (_request == nil) {
    NSString *urlString = [TiUtils stringValue:[self valueForUndefinedKey:@"url"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *params = [self valueForUndefinedKey:@"params"];

    SLRequestMethod requestMethod = [TiUtils intValue:[self valueForUndefinedKey:@"method"]];
    NSString *serviceType = [TiUtils stringValue:[self valueForUndefinedKey:@"type"]];

    _request = [SLRequest requestForServiceType:serviceType requestMethod:requestMethod URL:url parameters:params];

    if ([self valueForUndefinedKey:@"account"]) {
      Com0x82SocialAccountProxy *account = (Com0x82SocialAccountProxy *)[self valueForUndefinedKey:@"account"];
      [_request setAccount:account.account];
    }
  }

  return _request;
}

- (void)addMultiPartData:(id)value
{
  ENSURE_DICT([value objectAtIndex:0]);
  NSDictionary *args = [value objectAtIndex:0];

  NSData *data = [(TiBlob *)[args objectForKey:@"data"] data];

  NSString *fileName;
  if ([args objectForKey:@"filename"]) {
    fileName = [TiUtils stringValue:@"filename" properties:args];
  } else {
    fileName = [[(TiBlob *)[args objectForKey:@"data"] nativePath] lastPathComponent];
  }

  NSString *string = [TiUtils stringValue:@"name" properties:args];
  NSString *type = [TiUtils stringValue:@"type" properties:args def:[(TiBlob *)[args objectForKey:@"data"] mimeType]];

  [[self request] addMultipartData:data withName:string type:type filename:fileName];
}

- (void)perform:(id)arg
{
  [self rememberSelf];

  [[self request] performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    // Parse the responseData, which we asked to be in JSON format for this request, into an NSDictionary using NSJSONSerialization.
    NSError *jsonParsingError = nil;
    NSDictionary *output = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonParsingError];
    if (!output) {
      output = @{};

      if (jsonParsingError)
        NSLog(@"JSON Error: %@", [jsonParsingError localizedDescription]);
    }

    NSString *rawOutput = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

    if ([urlResponse statusCode] == 200) {
      NSDictionary *success_args = @{ @"status" : @([urlResponse statusCode]),
        @"data" : output,
        @"raw" : rawOutput };
      [self fireEvent:@"success" withObject:success_args];
    } else {
      NSMutableDictionary *failure_args = [NSMutableDictionary dictionary];

      [failure_args setValue:rawOutput forKey:@"data"];
      [failure_args setValue:NUMINT([urlResponse statusCode]) forKey:@"status"];
      if (error) {
        [failure_args setValue:[error localizedDescription] forKey:@"error"];
      }

      [self fireEvent:@"failure" withObject:failure_args];
    }

    [self forgetSelf];
  }];
}

@end
