#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use JSON;

#headers end with \n\n
print "Content-type: text/json";
print "\n\n";

#take input or enter debug mode
my $cgi = CGI->new;
my $debug = 0;
my $json_board;
if ($debug == 1){
  $json_board = '["_","X","X","_","O","_","O","_","X"]';
} else {
  $json_board = $cgi->param("POSTDATA");
}
my $json = JSON->new->allow_nonref;
my $input_board = $json->decode($json_board);

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
      my $second_val = $board->[$second];
      my $third_val = $board->[$third];
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
      if ($board->[$_] eq "_"){
        if ($debug == 1){
          print "trying minimax on move".$_."\n";}

        $board->[$_] = "O";
        my $move_val = minimax($board,0,0);
        if ($move_val > $best_val) {
          $best_val = $move_val;
          $best_move = $_;
          if ($debug == 1){
            print "\nnew move_val: ".$move_val."\n";
            print "placement: ".$_."\n";
            print_board($board);
          }
        }
        $board->[$_] = "_";
      }
    }
    return $best_move;
  }
}


sub minimax{
  my $board = shift(@_);
  my $depth = shift(@_);
  my $is_max = shift(@_);

  my $win_score = check_win($board);
  if ($win_score != 0){
    return $win_score;
  }
  if (move_left($board) == 0){
    return 0;
  }

  #logic for recursive scoring
  if ($is_max == 1) { # player O, computer
    my $best_val = -100;
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
    my $best_val = 100;
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

sub print_board {
  my $board = shift(@_);
  print ' '.$board->[0].' | '.$board->[1].' | '.$board->[2]."\n";
  print "---+---+---\n";
  print ' '.$board->[3].' | '.$board->[4].' | '.$board->[5]."\n";
  print "---+---+---\n";
  print ' '.$board->[6].' | '.$board->[7].' | '.$board->[8]."\n";
}

#procedural logic for responding to request
if ($debug == 1){
  print_board($input_board);
}
my $score = check_win($input_board);
my @response = ("unknown",-1);
#               (move type, move space)
if ($score == -10){
  $response[0] = "winner X";
}if ($score == 10){
  $response[0] = "winner O";
} elsif ($score == 0){
  if (move_left($input_board)) {
    my $next_move = find_best_move($input_board);
    $response[0] = "continue";
    $response[1] = $next_move;
    $input_board->[$next_move] = 'O';
    if (check_win($input_board) == 10) {
      $response[0] = "winner O";
    }
  } else {
    $response[0] = "draw";
  }
}
my $response_json = $json->encode(\@response);
print $response_json;
