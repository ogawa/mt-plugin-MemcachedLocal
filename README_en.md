# MemcachedLocal Plugin

A plugin for speeding up rebuilding templates under FastCGI environment.

MemcachedLocal caches the MT internal data to the local memory, which allows you to speed up rebuilding templates especially under FastCGI environment. Dedicated to MT4.

## Changes

 * 0.01 (2007-10-01 12:20:43 +0900):
   * Initial release.

## Overview

Some MT objects have both of internal data and external meta data.  $entry->comment_count and $entry->ping_count are typical examples of external meta data for MT::Entry object ($entry), which can be obtained not from 'mt_entry' table but from foreign tables such as 'mt_comment', 'mt_trackback', and 'mt_tbping'.  It is natural to access the external meta data takes much longer times than to access the internal data.

To amortize such overhead and to be able to access external data as quickly as possible, MT4 has a ''two-level caching mechanism'' for external meta data of MT objects.

For L1-cache, MT4 associates external meta data with an MT object.  First time you call $entry->comment_count, MT calculates its value by using foreign tables, and stores it as a property of the object.  After that, you can reuse the value without any calcluation.  It's good.  But, L1-cache has the same lifetime of the target object, which could be shorter than the lifetime of the session.  Because, everytime sessions are finished, almost all of MT objects could be destroyed from the local memory, of course with L1-cache.  Therefore, we can't reuse L1-cache across multiple sessions or multiple FastCGI requests.

For L2-cache, on the other hand, MT4 stores external meta data to Memcached.  External meta data are stored persistently in Memcached, so we can reuse them across multiple sessions. Of course, this feature is avaiable only when you employ Memcached, and L2-cache based on Memcached, which is an external process, is much slower than L1-cache stored inside the Perl runtime object.

To resolve such situations, MemcacheLocal plugin enables the L2-caching feature without using Memcached.  Unlike Memcached-based L2-cache, MemcachedLocal stores the external meta data to the local memory and keeps them as long as the application instance lives.  So, typically under the FastCGI environment, the application can reuse the external meta data without accessing foreign tables.

## Installation

To install this plugin, upload or copy 'MemcachedLocal' directory into your Movable Type's plugin directory. After proper installation, you will see a new "MemcachedLocal <version number>" plugin listed on the Main Menu of your Movable Type.

## See Also

## License

This code is released under the Artistic License. The terms of the Artistic License are described at [http://www.perl.com/language/misc/Artistic.html](http://www.perl.com/language/misc/Artistic.html).

## Author & Copyright

Copyright 2007, Hirotaka Ogawa (hirotaka.ogawa at gmail.com)
