'''
Copyright (C) 2015 Dato, Inc.
All rights reserved.

This software may be modified and distributed under the terms
of the BSD license. See the LICENSE file for details.
'''

def _encode(obj):
    '''
    Recursively encodes all strings in the objects. Supports the following types:
    anything that evaluates to False, String, 
    '''
    if isinstance(obj, str):
        return obj.encode()
    if isinstance(obj, list):
        return [ _encode(i) for i in obj]
    return obj
