% Daniel Porter
% COSC 3325 - Artificial Intelligence
% Battleship AI

% initial_configuration_dp("Porter", [
%               battleship(position(R1, C1), position(R2, C2)),
%               carrier(position(R1, C1), position(R2, C2)),
%               cruiser(position(R1, C1), position(R2, C2)),
%               destroyer(position(R1, C1), position(R2, C2)),
%               submarine(position(R1, C1), position(R2, C2)).

% next_moves_dp(initial_configuration(Ships),
%               own_history([turn(position(R,C), miss, none) | OwnHistory]),
%               opponent_history([turn(position(R,C), hit, carrier) |
%                                 OpponentHistory]),
%               own_board([unknown, miss, hit, ...], [unknown, ..], ...),
%               opponent_board(OpponentBoard),
%               next_moves([position(R,C)])).


% ENTRY POINT
% The engine will run using whatever is on the right side of these predicates.
initial_configuration(player_dp, InitalConfiguration) :- initial_configuration_dp(InitialConfiguration).

next_moves(player_dp, InitialConfiguration, OwnHistory, OpponentHistory, OwnBoard, OpponentBoard, NextMoves) :-
    next_moves_naive_dp(InitialConfiguration, OwnHistory, OpponentHistory, OwnBoard, OpponentBoard, NextMoves).








next_moves_dp(
              initial_configuration(
              battleship(position(R1, C1), position(R2, C2)),
              carrier(position(R1, C1), position(R2, C2)),
              cruiser(position(R1, C1), position(R2, C2)),
              destroyer(position(R1, C1), position(R2, C2)),
              submarine(position(R1, C1), position(R2, C2)).),
              
              own_history([LastMove | OwnHistory]),
              opponent_history(OpponentHistory),
              own_board(OwnBoard),
              opponent_board(OpponentBoard),
              next_moves([position(NextR, NextC)])) :-
    
    next_moves_DP(initial_configuration(Ships),
                  own_history([LastMove | OwnHistory]),
                  opponent_history(OpponentHistory),
                  own_board(OwnBoard),
                  opponent_board(OpponentBoard),
                  next_moves([position(NextR, NextC)])).

next_moves_DP(initial_configuration(Ships),
              own_history([LastMove | OwnHistory]),
              opponent_history(OpponentHistory),
              own_board(OwnBoard),
              opponent_board([A1, A2, A3, A4, A5, A6, A7, A8, A9, A10],
                             [B1, B2, B3, B4, B5, B6, B7, B8, B9, B10],
                             [C1, C2, C3, C4, C5, C6, C7, C8, C9, C10],
                             [D1, D2, D3, D4, D5, D6, D7, D8, D9, D10],
                             [E1, E2, E3, E4, E5, E6, E7, E8, E9, E10], 
                             [F1, F2, F3, F4, F5, F6, F7, F8, F9, F10],
                             [G1, G2, G3, G4, G5, G6, G7, G8, G9, G10],
                             [H1, H2, H3, H4, H5, H6, H7, H8, H9, H10],
                             [I1, I2, I3, I4, I5, I6, I7, I8, I9, I10],
                             [J1, J2, J3, J4, J5, J6, J7, J8, J9, J10]),
              next_moves([position(NextR, NextC)])).








% next_moves for a basic naive player
next_moves_naive_dp(initial_configuration(Ships),
                    own_history([position(LastR, LastC) | OwnHistory]),
                    opponent_history(OpponentHistory),
                    own_board(OwnBoard),
                    opponent_board(OpponentBoard),
                    next_moves([position(Rmove, Cmove)])) :-
    next_sequential_position_dp(position(LastR, LastC),
                                position(NextR, NextC)).

% If first position is the last board position, wrap around to the first.
next_sequential_position_DP(position(10, 10), position(1, 1)).
% If column is 10 and row is not 10, increment the row.
next_sequential_position_DP(position(R1, 10), position(R2, 1)) :- R2 is R1+1.
% Do I need to prevent backtracking from (10, 10) -> (1, 1)?
%   R1 < 10.
next_sequential_position_DP(position(R1, C1), position(R2, C2)) :- 
    R2 is R1+1, C2 is C1+1.
%   R1 < 10, C1 < 10, R2 is R1+1, C2 is C1+1.