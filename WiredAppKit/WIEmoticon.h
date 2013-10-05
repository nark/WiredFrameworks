//
//  WIEmoticon.h
//  WiredFrameworks
//
//  Created by Rafaël Warnault on 30/09/13.
//  Copyright (c) 2013 OPALE. All rights reserved.
//

#import <WiredFoundation/WiredFoundation.h>

@class WIEmoticonPack;


@interface WIEmoticon : WIObject {
    NSString                        *_path;
    NSString                        *_name;
    NSArray                         *_textEquivalents;
    NSImage                         *_image;
    
    WIEmoticonPack                  *_pack;
    NSMutableAttributedString       *_cachedAttributedString;
    BOOL                            _enabled;
}


@property (readwrite, retain)   NSString            *path;
@property (readwrite, retain)   NSString            *name;
@property (readonly)            NSString            *equivalent;
@property (readwrite, retain)   NSArray             *textEquivalents;

@property (readwrite, retain)   WIEmoticonPack      *pack;
@property (readwrite, retain)   NSImage             *image;
@property (readwrite)           BOOL                enabled;


+ (id)emoticonWithPath:(NSString *)path
           equivalents:(NSArray *)textEquivalents
                  name:(NSString *)name
                  pack:(WIEmoticonPack *)pack;

@end
