use strict;
use warnings;
#use diagnostics;
use Data::Dumper qw(Dumper);

my @input_board = (' ',' ',' ',' ',' ',' ',' ',' ',' ');

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
        if ($first_val eq ' ') {
          return 0;
        } else {
          return $player;
        }
      }
    }
  }
}

print check_win(@input_board)." wins! \n";
