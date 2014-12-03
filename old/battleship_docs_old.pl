% Daniel Porter
% Battleship AI

% Battleship is a turn based seek and destroy style game, typically played
% on a square grid. This game uses a 10x10 board with rows a-j and columns
% 1-10. Position a,1 is the top left hand corner of the board. The game
% begins by each player placing 5 ships on the board in horizontal and
% vertical positions. Ships may not be diagonally oriented or overlapping,
% but they can be touching. The players take turns firing at a single
% position on the opponent's board until one player has lost all their ships,
% therefore losing the game. Forfeiting turns or firing on the same position
% twice is not allowed.



% Data Types
% The data types used in this program are Ships, Moves, Board, Move, and
% Position. The implementation of the data types may differ but unless
% explictly stated they should all behave the same way.

% Ships: The positions of each of the players ships on the board. Ships is a 
%        list containing one of each type of ship. The types of ships and their
%        lengths are: Aircraft Carrier (5), Battleship (4),  Submarine (3),
%        Cruiser(3), and Destroyer (2). A ship is represented in Prolog as:
%        aircraft_carrier(position(a,1), position(a,5)).

% Moves: A list of all moves made and their resulting reverse chronological
%        order. A turn is represented as turn(position(R,C)) and its result
%        can either be hit or miss. An example Moves list could look like:
%        [turn(position(a,1),miss, turn(position(f,4),hit].
%        Note: A turn is a member of the Moves list, and a Move is a position
%        to fire upon.

% Board: A series of lists representing the entire board state. The game
%        has ten rows [a,b..j] and ten columns [1,2..10]. A position on
%        the board can either be a hit, a miss, or an unknown, which is a
%        spot that has not yet been fired upon. An example 3x3 board could
%        look like:
%        board([unknown,hit,miss],[miss,unknown,miss],[miss,hit,unknown]),
%        which would represent (X is hit, O is miss, top left is (a,1):
%        [ ][X][O]
%        [O][ ][O]
%        [O][X][ ]

% Move: A move is a position to be fired upon. An example move would look like:
%       move(position(R,C)).

% Position: A position represents any valid space on the board. A position
%           has a row and a column. An example position could be:
%           position(b,3).

% Global Labels
% Some labels do not require an initial suffix, as they are used through the entire
% system. Use of labels without an initial suffix must follow the listed rules.
% The global labels and their associated rules are:
%     position(row, column)                   (row,column) must be on the board
%     turn(position)                          
%     hit                                     there is a ship on this position
%     miss                                    there is no ship on this position
%     unknown                                 this position has not been fired on
%     next_move(position)                     cannot have fired on position before
%     initial_configuration(Ships)            
%     own_history(Moves)                      
%     opponent_history(Moves)                 
%     own_board(Board)                        
%     opponent_board(Board)                   
%     aircraft_carrier                        the aircraft carrier has been sunk
%     battleship                              the battleship has been sunk
%     submarine                               the battleship has been sunk
%     cruiser                                 the cruiser has been sunk
%     destroyer                               the destroyer has been sunk
%     aircraft_carrier(position, position)    positions must span 5 units
%     battleship(position, position)          positions must span 4 units
%     submarine(position, position)           positions must span 3 units
%     cruiser(position, position)             positions must span 3 units
%     destroyer(position, position)           positions must span 2 units


% Predicates which interface with the game engine use a lower-case suffix;
% private predicates use an upper-case suffix (public: _dp, private: _DP).
% All private predicates use a (number,number) coordinate system, while public
% predicates use the (letter,number) coordinate system of the game engine.
% Global labels also use the (letter,number) coordinate system.

% initial_configuration(Ships).
% Establishes an initial board configuration.
% Ships is [aircraft_carrier(position_dp(a,1),position_dp(a,5)), ...]
% The order of the ships is... ????
initial_configuration_dp(Ships).

% next_move_dp(initial_configuration_dp(Ships),
%              own_history(Moves),
%              opponent_history(Moves),
%              own_board(Board),
%              opponent_board(Board),
%              next_move(Move)).
% Decides the next move based on the given game state.
%     Ships: the configuration of the players ships on the board. ex: see above documentation

% aircraft_carrier(position(r1,c1),position(r2,c2)).
% The aircraft carrier is the largest ship in the fleet at 5 units long.
aircraft_carrier_dp(position_dp(R1,C1), position_dp(R1,C2)).
aircraft_carrier_dp(position_dp(R1,C1), position_dp(R2,C1)).
aircraft_carrier_DP(position_DP(R1,C1), position_DP(R1,C2)).
aircraft_carrier_DP(position_DP(R1,C1), position_DP(R2,C1)).

% battleship(position(R1,C1),position(R2,C2)).

% position(row, column).
% Position is a valid board coordinate.
% position_dp uses the game engine's (letter,number) coordinate system and
% position_DP uses the private (number,number) coordinate system.
position_dp(row,column) :- valid_row_dp(row), valid_column_dp(column).
position_DP(row,column) :- valid_row_DP(row), valid_column_DP(column).

% length(Position1,Position2,Length).
% Finds the length between two positions.
length_DP(position_DP(R,C1), position_DP(R,C2),L) :- Cd is C1 - C2, L is abs(Cd).
length_DP(position_DP(R1,C), position_DP(R2,C),L) :- Rd is R1 - R2, L is abs(Rd).

% legal_placement(Ships).
% Determines if the ships is the Ships list are all legally placed. Each
% ship must be at a valid position, no two ships may overlap, and there must
% be exactly one of each type of ship.
% Order TBD.
legal_placement_dp(Ships).

% letter_number_translation_DP(letter,number).
% Translates a letter based row value to a number based row value.
% a=1, b=2, c-3, ... j=10.
letter_number_translation_DP(a, 1).
letter_number_translation_DP(b, 2).
letter_number_translation_DP(c, 3).
letter_number_translation_DP(d, 4).
letter_number_translation_DP(e, 5).
letter_number_translation_DP(f, 6).
letter_number_translation_DP(g, 7).
letter_number_translation_DP(h, 8).
letter_number_translation_DP(i, 9).
letter_number_translation_DP(j, 10).

% valid_coordinate_value().
% Checks if it is a valid coordinate value, i.e. is on the board.
% valid_row_dp(row) :- member(row, [a,b,c,d,e,f,g,h,i,j]).
valid_row_DP(row) :- member(row, [1,2,3,4,5,6,7,8,9,10]).
% valid_column_dp(column) :- member(column, [1,2,3,4,5,6,7,8,9,10]).
valid_column_DP(column) :- valid_column_dp(column).
