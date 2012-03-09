/*
 * (C) Copyright 2009-2011 Smart&Soft SAS (http://www.smartnsoft.com/) and contributors.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser General Public License
 * (LGPL) version 3.0 which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/lgpl.html
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * Contributors:
 *     Smart&Soft - initial API and implementation
 */

#import <Foundation/Foundation.h>

#import "SnSAbstractCache.h"

/**
 *	The memory cache holds data up to a certain limit in memory.
 *	That amount is set in the cache silo creation.
 */
@interface SnSMemoryCache : SnSAbstractCache
{
}

- (void)storeObject:(id)iObj forKey:(id)iKey;
- (void)storeString:(NSString*)iStr forKey:(id)iKey;

@end
