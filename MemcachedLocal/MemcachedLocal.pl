# MemcachedLocal
#
# $Id$
#
# This software is provided as-is. You may use it for commercial or 
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2007 Hirotaka Ogawa

package MT::Plugin::MemcachedLocal;
use strict;
use base qw(MT::Plugin);

use MT 4.0;

our $VERSION = '0.01';

my $plugin = __PACKAGE__->new({
    id          => 'memcached_local',
    name        => 'MemcachedLocal',
    description => 'MemcachedLocal caches the MT internal data to the local memory, which allows you to speed up rebuilding templates especially under FastCGI environment.',
    doc_link    => 'http://code.as-is.net/wiki/MemcachedLocal',
    author_name => 'Hirotaka Ogawa',
    author_link => 'http://as-is.net/blog/',
    version     => $VERSION,
});
MT->add_plugin($plugin);

use MT::Memcached;
use MemcachedLocal;
sub init {
    my $cache = MT::Memcached->instance;
    $cache->{memcached} = MemcachedLocal->new()
	unless $cache->{memcached};
}

1;
