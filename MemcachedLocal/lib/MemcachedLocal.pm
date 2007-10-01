# $Id$

package MemcachedLocal;
use strict;

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub get {
    my $this = shift;
    $this->{$_[0]};
}

sub set {
    my $this = shift;
    $this->{$_[0]} = $_[1];
}

sub add {
    my $this = shift;
    $this->{$_[0]} = $_[1]
	unless defined $this->{$_[0]};
}

sub incr {
    my $this = shift;
    if (defined $this->{$_[0]}) {
	my $delta = defined $_[1] ? $_[1] : 1;
	$this->{$_[0]} += $delta;
    }
}

sub decr {
    my $this = shift;
    if (defined $this->{$_[0]}) {
	my $delta = defined $_[1] ? $_[1] : 1;
	$this->{$_[0]} -= $delta;
    }
}

sub delete {
    my $this = shift;
    delete $this->{$_[0]};
}

1;
