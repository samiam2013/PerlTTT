#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
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
my $board = $json->decode($json_board);

#this line proves that it's getting input
#print Dumper \$board;

sub check_win {
  my @board = @_;
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
      my $first_val = $board[$first];
      my $second_val = $board[$second];
      my $third_val = $board[$third];
      if ($first_val eq $second_val and $first_val eq $third_val){
        if ($first_val eq 'X') {
          return -10;
        } else if ($first_val eq 'O'){
          return 10;
        } else {
          return 0;
        }
      }
    }
  }
}

sub move_left {
  my @board = @_;
  my @possible = (0..8);
  for(@possible){
    if($board->[$_] eq '_'){
      return 1;
    }
  }
  return 0;
}

sub find_best_move {
  my @board = @_;
  my $best_move = -1;
  my @possible = (0..8);
  for(@possible){
    if($board->[$_] eq '_'){
      print $_." -> move open\n";

    }
  }
}
print "I'm running!\n";
print "move_left():".move_left($board);
if (move_left($board)) {
  my $score = check_win($board);
  if ($score == 0){ #no winner yet
    print "no winner yet"
    find_best_move($board);
  } else if ($score == -10){
    print "winner: X";
  }
}
