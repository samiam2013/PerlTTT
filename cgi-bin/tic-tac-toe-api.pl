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
  return 0
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

sub find_best_move {
  my $board = shift(@_);
  if ($board->[4] eq "_"){
    return 4;
  } else {
    my $best_val = -20;
    my $best_move = -1;
    for (0..8) {
      #print "checking move ".$_."\n";
      if ($board->[$_] eq "_"){
        #print "trying minimax on move\n";

        $board->[$_] = "X";
        my $move_val = minimax($board,0,0);
        $board->[$_] = "_";
        if ($move_val > $best_val) {
          $best_val = $move_val;
          $best_move = $_;
        }

      }
    }
    print "best move: ".$best_move."\n";
    return $best_move;
  }
}


sub minimax{
  my $board = shift(@_);
  my $depth = shift(@_);
  my $is_max = shift(@_);
  #print "depth: ".$depth."\n";
  #print "is_max: ".$is_max."\n";
  my $win_score = check_win($board);
  if ($win_score != 0){
    #print "winner caught!\n";
    return $win_score;
  }
  if (move_left($board) == 0){
    #print "draw caught!\n";
    return 0;
  }

  #logic for recursive scoring
  if ($is_max == 1) { # player O, computer
    my $best_val = -20;
    my $max_val;
    for (0..8){
      if ($board->[$_] eq "_"){
        $board->[$_] = "O";
        $max_val = minimax($board,$depth+1,0);
        if ($max_val > $best_val){
          $best_val = $max_val;
        }
        $board->[$_] = "_";
      }
    }
    return $best_val;
  } else { #minimizer, player x
    my $best_val = 20;
    my $min_val;
    for (0..8){
      if ($board->[$_] eq "_"){
        $board->[$_] = "O";
        my $min_val = minimax($board,$depth+1,1);
        if ($min_val < $best_val){
          $best_val = $min_val;
        }
        $board->[$_] = "_";
      }
    }
    return $best_val;
  }


}


#print "move_left():".move_left($input_board)."\n";
my $score = check_win($input_board);
my @response = ("unknown",-1);
#               (move type, move space)
if ($score == -10){ #no winner yet
  #print "winner: X";
  $response[0] = "winner X";
} elsif ($score == 0){
  if (move_left($input_board)) {
    # find next move
    print "computing next move! ......\n";
    my $next_move = find_best_move($input_board);
    $response[0] = "continue";
    $response[1] = $next_move;
  } else {
    #print "draw"
    $response[0] = "draw";
  }
}
#print Dumper \@response;
my $response_json = $json->encode(\@response);
print $response_json;
