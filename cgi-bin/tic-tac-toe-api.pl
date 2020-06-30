#!/usr/bin/perl
use strict;
use warnings;
#use diagnostics;
use Data::Dumper qw(Dumper);

use CGI;
use JSON;

#headers end with \n\n
print "Content-type: text/json";
print "\n\n";

my $cgi = CGI->new;
my $json_board = $cgi->param("POSTDATA");
#print "request: $json_board";

#my @input_board =
#  ('_','_','_','_','_','_','_','_','_');

my $json = JSON->new->allow_nonref;
my $input_board = $json->decode($json_board);

#this line proves that it's getting input
#print Dumper \$board;

sub check_win {
  my $board = shift(@_);
  my @win_states = (
    [0,1,2],
    [0,3,6],
    [2,5,8],
    [6,7,8],
    [0,4,8],
    [2,4,6],
    [1,4,7],
    [3,4,5]);
  foreach ('X','O') {
    my $player = $_;
    foreach (@win_states){
      my $first = $_->[0];
      my $second = $_->[1];
      my $third = $_->[2];
      my $first_val = $board->[$first];
      #print "first_val: ".$first_val."\n";
      my $second_val = $board->[$second];
      #print "second_val: ".$second_val."\n";
      my $third_val = $board->[$third];
      #print "third_val: ".$third_val."\n";
      if ($first_val eq $second_val and $first_val eq $third_val){
        if ($first_val eq 'X') {
          return -10;
        } elsif ($first_val eq 'O'){
          return 10;
        }
      }
    }
  }
}

sub move_left {
  my $board = shift(@_);
  my @possible = (0..8);
  for(@possible){
    if($board->[$_] eq '_'){
      return 1;
    }
  }
  return 0;
}

#print "move_left():".move_left($input_board)."\n";
my $score = check_win($input_board);
if ($score == -10){ #no winner yet
  #print "winner: X";
  # send game over signal?
} elsif ($score == 10){
  #print "winner: O";
  # send game over signal?
} elsif ($score == 0){
  #print "no winner yet";
  if (move_left($input_board)) {
    # find next move
    print "computing next move! ......\n";
  } else {
    #print "draw"
    # send game over signal?
  }
}
