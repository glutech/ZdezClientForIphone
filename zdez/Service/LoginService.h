//
//  LoginService.h
//  zdez
//
//  Created by glu on 13-11-6.
//  Copyright (c) 2013年 Boke Technology co., ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginService : NSObject

-(int)login:(NSString*)username secondParameter:(NSString*)password;

- (BOOL)isLogined;

@end
