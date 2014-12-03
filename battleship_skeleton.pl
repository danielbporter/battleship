usemodule(library(lists), [member, union, nth0, nth1, last, reverse, same_length, permutation]).

% Suppress compiler warnings for singleton variables.
:- style_check(-singleton).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Entry Point Predicates   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initial configuration entry point into player specific code
% initial_configuration(player_dp, InitalConfiguration) :-
%     initial_configuration_dp(InitialConfiguration).

% next moves entry point into player specific code
% next_moves(player_dp, InitialConfiguration, OwnHistory, OpponentHistory,
%         OwnBoard, OpponentBoard, NextMoves) :-
%     next_moves_dp(InitialConfiguration, OwnHistory, OpponentHistory,
%     OwnBoard, OpponentBoard, NextMoves).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Game Code         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Utility Predicates     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Game Engine Code      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%INCREMENT
increment(1, 2).
increment(2, 3).
increment(3, 4).
increment(4, 5).
increment(5, 6).
increment(6, 7).
increment(7, 8).
increment(8, 9).
increment(9, 10).

increment(a, b).
increment(b, c).
increment(c, d).
increment(d, e).
increment(e, f).
increment(f, g).
increment(g, h).
increment(h, i).
increment(i, j).

%LESS_THAN_OR_EQUAL
less_than_or_equal(V1, V1) :- !.
less_than_or_equal(V1, V2) :- increment(V1, V2), !.
less_than_or_equal(V1, V2) :- increment(V1, V), less_than_or_equal(V, V2), !.

%TRANSLATE_ROW_LETTER_TO_NUMBER
%?- translate_row_letter_to_number(a, N).
%N = 1.
translate_row_letter_to_number(a, 1) :- !.
translate_row_letter_to_number(b, 2) :- !.
translate_row_letter_to_number(c, 3) :- !.
translate_row_letter_to_number(d, 4) :- !.
translate_row_letter_to_number(e, 5) :- !.
translate_row_letter_to_number(f, 6) :- !.
translate_row_letter_to_number(g, 7) :- !.
translate_row_letter_to_number(h, 8) :- !.
translate_row_letter_to_number(i, 9) :- !.
translate_row_letter_to_number(j, 10) :- !.

%TRANSLATE_ROW_NUMBER_TO_LETTER
%?- translate_row_number_to_letter(7, L).
%L = g.
translate_row_number_to_letter(NUMBER, LETTER) :- translate_row_letter_to_number(LETTER, NUMBER).

%POSITIONS_COVERED
%?- positions_covered(position(a, 2), position(e, 2), L).
%L = [position(a, 2), position(b, 2), position(c, 2), position(d, 2), position(e, 2)] ;
%false.
positions_covered(position(R, C), position(R, C), [position(R, C)]) :- !.
positions_covered(position(R1, CS), position(R1, CE), [position(R1, CS) | Rest]) :- less_than_or_equal(CS, CE), increment(CS, C), positions_covered(position(R1, C), position(R1, CE), Rest).
positions_covered(position(R1, CE), position(R1, CS), [position(R1, CS) | Rest]) :- less_than_or_equal(CS, CE), increment(CS, C), positions_covered(position(R1, CE), position(R1, C), Rest).
positions_covered(position(RS, C1), position(RE, C1), [position(RS, C1) | Rest]) :- less_than_or_equal(RS, RE), increment(RS, R), positions_covered(position(R, C1), position(RE, C1), Rest).
positions_covered(position(RE, C1), position(RS, C1), [position(RS, C1) | Rest]) :- less_than_or_equal(RS, RE), increment(RS, R), positions_covered(position(RE, C1), position(R, C1), Rest).

%?- positions_covered([[position(a, 1), position(a, 5)], [position(a,1), position(d,1)]], U).
%U = [position(a, 2), position(a, 3), position(a, 4), position(a, 5), position(a, 1), position(b, 1), %position(c, 1), position(d, 1)] ;
%false.
positions_covered([], []) :- !.
positions_covered([[position(R1, C1), position(R2, C2)] | Rest], DistinctPositionsCovered) :- positions_covered(Rest, DistinctPositionsCovered_Rest), positions_covered(position(R1, C1), position(R2, C2), Covered_Head), union(Covered_Head, DistinctPositionsCovered_Rest, DistinctPositionsCovered).

%VALID_SHIP_PLACEMENT
%?- valid_ship_placement(destroyer(position(d, 1), position(d, 2))).
%true.
%
%?- valid_ship_placement(carrier(position(c, 4), position(c, 8))).
%true.
%
%?- valid_ship_placement(cruiser(position(c, 1), position(c, 3))).
%true.
%
%?- valid_ship_placement(submarine(position(e, 1), position(e, 3))).
%true.
%
%?- valid_ship_placement(battleship(position(b, 1), position(b, 4))).
%true.
valid_ship_placement(carrier(position(RS, CS), position(RE, CE))) :- positions_covered(position(RS, CS), position(RE, CE), PositionsCovered), length(PositionsCovered, 5), !.
valid_ship_placement(battleship(position(RS, CS), position(RE, CE))) :- positions_covered(position(RS, CS), position(RE, CE), PositionsCovered), length(PositionsCovered, 4), !.
valid_ship_placement(cruiser(position(RS, CS), position(RE, CE))) :- positions_covered(position(RS, CS), position(RE, CE), PositionsCovered), length(PositionsCovered, 3), !.
valid_ship_placement(submarine(position(RS, CS), position(RE, CE))) :- positions_covered(position(RS, CS), position(RE, CE), PositionsCovered), length(PositionsCovered, 3), !.
valid_ship_placement(destroyer(position(RS, CS), position(RE, CE))) :- positions_covered(position(RS, CS), position(RE, CE), PositionsCovered), length(PositionsCovered, 2), !.

%NON_OVERLAPPING_PLACEMENTS
%?- non_overlapping_placements([[position(d, 1), position(d, 10)], [position(c, 1), position(c, 3)], %[position(c, 4), position(c, 8)], [position(e, 1), position(e, 3)], [position(b, 1), position(b, %4)]]).
%true.
%
%?- non_overlapping_placements([[position(d, 1), position(d, 10)], [position(d, 7), position(d, %10)]]).
%false.
non_overlapping_placements([]).
non_overlapping_placements([[position(RS, CS), position(RE, CE)] | Rest]) :- non_overlapping_placements(Rest), positions_covered([[position(RS, CS), position(RE, CE)]], PositionsCovered_S), positions_covered(Rest, PositionsCovered_Rest), positions_covered([[position(RS, CS), position(RE, CE)] | Rest], PositionsCovered_All), length(PositionsCovered_S, Length_S), length(PositionsCovered_Rest, Length_Rest), length(PositionsCovered_All, Length_All), Length_All is (Length_S + Length_Rest), !.

%LEGAL_PLACEMENT
%legal_placement([destroyer(position(d, 1), position(d, 2)), cruiser(position(c, 1), position(c, 3)), %carrier(position(c, 4), position(c, 8)), submarine(position(e, 1), position(e, 3)), %battleship(position(b, 1), position(b, 4))]).                                    
%true ;
%false.
%
%legal_placement([destroyer(position(d, 1), position(d, 10)), cruiser(position(c, 1), position(c, 3)), %carrier(position(c, 4), position(c, 8)), submarine(position(e, 1), position(e, 3)), %battleship(position(b, 1), position(b, 4))]).
%false.
legal_placement(ShipPlacements) :- permutation(ShipPlacements, [carrier(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)), battleship(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)), cruiser(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)), submarine(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)), destroyer(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer))]), valid_ship_placement(carrier(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier))), valid_ship_placement(battleship(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship))), valid_ship_placement(cruiser(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser))), valid_ship_placement(submarine(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine))), valid_ship_placement(destroyer(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer))), non_overlapping_placements([[position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)], [position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)], [position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)], [position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)], [position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer)]]), !.

%INITIAL_BOARD
initial_board([R, R, R, R, R, R, R, R, R, R]) :- R = [unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown].

%BOARD_GET_VALUE
%?- initial_board(IB), board_get_value(IB, a, 3, Value).                                                         
%IB = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, %unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, %unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, %unknown, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], %[…|…]|…],
%Value = unknown.
board_get_value(Board, RowLetter, ColumnNumber, Value) :- translate_row_letter_to_number(RowLetter, RowNumber), nth1(RowNumber, Board, Row), nth1(ColumnNumber, Row, Value).

%REMOVE_LAST_ROW
%?- initial_board(IB), remove_last_row(IB, NewBoard), length(NewBoard, L).                       
%IB = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, %unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, %unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, %unknown, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], %[…|…]|…],
%NewBoard = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], %[unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, %unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown|...], [unknown, %unknown, unknown, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], %[unknown|...], [...|...]],
%L = 9.
remove_last_row(PartialBoard, PartialBoard_LastRowRemoved) :- reverse(PartialBoard, [PartialBoardReversed_Head | PartialBoardReversed_Tail]), reverse(PartialBoardReversed_Tail, PartialBoard_LastRowRemoved).

%SET_VALUE
%?- set_value([1,2,3,4,5,6,7], 5, e, NewRow).
%NewRow = [1, 2, 3, 4, e, 6, 7].
set_value(Row, 0, Value, Row) :- !.
set_value([Row_Head | Row_Tail], 1, Value, [Value | Row_Tail]) :- !.
set_value([Row_Head | Row_Tail], ColumnNumber, Value, [Row_Head | NewRow_Tail]) :- NewColumnNumber is (ColumnNumber - 1), set_value(Row_Tail, NewColumnNumber, Value, NewRow_Tail).

initial_board_for_testing([[a1, a2, a3, a4, a5, a6, a7, a8, a9, a10], [b1, b2, b3, b4, b5, b6, b7, b8, b9, b10], [c1, c2, c3, c4, c5, c6, c7, c8, c9, c10], [d1, d2, d3, d4, d5, d6, d7, d8, d9, d10], [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10], [f1, f2, f3, f4, f5, f6, f7, f8, f9, f10], [g1, g2, g3, g4, g5, g6, g7, g8, g9, g10], [h1, h2, h3, h4, h5, h6, h7, h8, h9, h10], [i1, i2, i3, i4, i5, i6, i7, i8, i9, i10], [j1, j2, j3, j4, j5, j6, j7, j8, j9, j10]]).

%BOARD_SET_VALUE
board_set_value(PartialBoard, RowLetter, ColumnNumber, NewValue, PartialBoard) :- translate_row_letter_to_number(RowLetter, RowNumber), length(PartialBoard, PartialBoardLength), RowNumber > PartialBoardLength, !.

board_set_value(PartialBoard, RowLetter, ColumnNumber, NewValue, NewPartialBoard) :- translate_row_letter_to_number(RowLetter, RowNumber), length(PartialBoard, PartialBoardLength), RowNumber is PartialBoardLength, last(PartialBoard, PartialBoard_LastRow), last(NewPartialBoard, NewPartialBoard_LastRow), set_value(PartialBoard_LastRow, ColumnNumber, NewValue, NewPartialBoard_LastRow), remove_last_row(PartialBoard, PartialBoard_LastRowDeleted), remove_last_row(NewPartialBoard, NewPartialBoard_LastRowDeleted), board_set_value(PartialBoard_LastRowDeleted, RowLetter, ColumnNumber, NewValue, NewPartialBoard_LastRowDeleted), !.

board_set_value(PartialBoard, RowLetter, ColumnNumber, NewValue, NewPartialBoard) :- translate_row_letter_to_number(RowLetter, RowNumber), length(PartialBoard, PartialBoardLength), RowNumber < PartialBoardLength, last(PartialBoard, PartialBoard_LastRow), last(NewPartialBoard, PartialBoard_LastRow), remove_last_row(PartialBoard, PartialBoard_LastRowDeleted), remove_last_row(NewPartialBoard, NewPartialBoard_LastRowDeleted), board_set_value(PartialBoard_LastRowDeleted, RowLetter, ColumnNumber, NewValue, NewPartialBoard_LastRowDeleted), !.

%ALL_SHIPS
all_ships([carrier, battleship, cruiser, submarine, destroyer]).

%SHIPS_SUNK
%ships_sunk([turn(position(e, 4), hit, battleship), turn(position(d, 8), miss, none), %turn(position(f, 5), hit, none), turn(position(a, 1), hit, carrier)], SS).
%SS = [battleship, carrier].
ships_sunk([], []).
ships_sunk([turn(position(R, C), HIT_OR_MISS, Ship) | Rest], [Ship | SS_Rest]) :- all_ships(AllShips), member(Ship, AllShips), ships_sunk(Rest, SS_Rest), !.
ships_sunk([turn(position(R, C), HIT_OR_MISS, none) | Rest], SS_Rest) :- ships_sunk(Rest, SS_Rest), !.

%NAIVE_PLAYER 1
initial_configuration_naive_player([carrier(position(a, 1), position(a, 5)), battleship(position(b, 1), position(b, 4)), cruiser(position(c, 1), position(c, 3)), submarine(position(d, 1), position(d, 3)), destroyer(position(e, 1), position(e, 2))]).

initial_configuration(naive_player, InitialConfiguration) :- initial_configuration_naive_player(InitialConfiguration).

increment_position_naive(position(R, C), position(R, C2)) :- C < 10, C2 is C + 1.
increment_position_naive(position(R, 10), position(R2, 1)) :- increment(R, R2).

%Should “move the clock back” on ship information and turn histories, but naive player
%is ignoring this information anyway
next_moves_naive_player(MyInitialShipPlacement, [], OpponentTurnHistory_ReverseChron, MyShipRegionInformation, OpponentShipRegionInformation, [position(a,1)]).

next_moves_naive_player(MyInitialShipPlacement, [MyLastTurn | MyPreviousTurns], [OpponentLastTurn | OpponentPreviousTurns], MyShipRegionInformation, OpponentShipRegionInformation, [position(R, C)]) :- next_moves_naive_player(MyInitialShipPlacement, MyPreviousTurns, OpponentPreviousTurns, MyShipRegionInformation, OpponentShipRegionInformation, [position(RP, CP)]), increment_position_naive(position(RP, CP), position(R,C)).

next_moves(naive_player, MyInitialShipPlacement, MyTurnHistory, OpponentTurnHistory, MyShipRegionInformation, OpponentShipRegionInformation, [position(R,C)]) :- next_moves_naive_player(MyInitialShipPlacement, MyTurnHistory, OpponentTurnHistory, MyShipRegionInformation, OpponentShipRegionInformation, [position(R,C)]).

%NAIVE_PLAYER 2
initial_configuration_naive_player2([carrier(position(j, 6), position(j, 10)), battleship(position(i, 7), position(i, 10)), cruiser(position(h, 8), position(h, 10)), submarine(position(g, 8), position(g, 10)), destroyer(position(f, 9), position(f, 10))]).

initial_configuration(naive_player2, InitialConfiguration) :- initial_configuration_naive_player2(InitialConfiguration).

next_moves_naive_player2(MyInitialShipPlacement, MyTurnHistory, OpponentTurnHistory, MyShipRegionInformation, OpponentShipRegionInformation, NextMoves) :-next_moves_naive_player(MyInitialShipPlacement, MyTurnHistory, OpponentTurnHistory, MyShipRegionInformation, OpponentShipRegionInformation, NextMoves).

next_moves(naive_player2, MyInitialShipPlacement, MyTurnHistory, OpponentTurnHistory, MyShipRegionInformation, OpponentShipRegionInformation, [position(R,C)]) :- next_moves_naive_player2(MyInitialShipPlacement, MyTurnHistory, OpponentTurnHistory, MyShipRegionInformation, OpponentShipRegionInformation, [position(R,C)]).

%legal_placement([destroyer(position(d, 1), position(d, 2)), cruiser(position(c, 1), position(c, 3)), %carrier(position(c, 4), position(c, 8)), submarine(position(e, 1), position(e, 3)), %battleship(position(b, 1), position(b, 4))]).

%PLAYER's TURN
%?- player1s_turn([turn(position(e, 4), miss, none)], []).
%false.
%
%?- player2s_turn([turn(position(e, 4), miss, none)], []).
%true.
%
%?- player1s_turn([turn(position(e, 4), miss, none)], [turn(position(c, 10), miss, none)]).
%true.
%
%?- player2s_turn([turn(position(e, 4), miss, none)], [turn(position(c, 10), miss, none)]).
%false.
player1s_turn(Player1_TurnHistory, Player2_TurnHistory) :- same_length(Player1_TurnHistory, Player2_TurnHistory).

player2s_turn(Player1_TurnHistory, Player2_TurnHistory) :- not(same_length(Player1_TurnHistory, Player2_TurnHistory)).

%WINNING_HISTORY
%?- winning_history([turn(position(e, 4), hit, battleship), turn(position(d, 8), miss, none), turn(position(f, 5), hit, none), turn(position(a, 1), hit, carrier)]).
%false.
%
%?- winning_history([turn(position(e, 4), hit, battleship), turn(position(d, 8), miss, none), turn(position(f, 5), hit, none), turn(position(a, 1), hit, carrier), turn(position(f, 8), hit, submarine), turn(position(i, 2), hit, destroyer), turn(position(j, 4), hit, cruiser)]).
%true.
winning_history(TurnHistory) :- ships_sunk(TurnHistory, ShipsSunk), all_ships(AllShips), permutation(ShipsSunk, AllShips), !.

%MOVE_PRESENT_IN_HISTORY
%move_present_in_history(position(f, 5), [turn(position(e, 4), hit, battleship), turn(position(d, 8), miss, none), turn(position(f, 5), hit, none), turn(position(a, 1), hit, carrier), turn(position(f, 8), hit, submarine), turn(position(i, 2), hit, destroyer), turn(position(j, 4), hit, cruiser)]).
%true.
%
%move_present_in_history(position(e, 8), [turn(position(e, 4), hit, battleship), turn(position(d, 8), miss, none), turn(position(f, 5), hit, none), turn(position(a, 1), hit, carrier), turn(position(f, 8), hit, submarine), turn(position(i, 2), hit, destroyer), turn(position(j, 4), hit, cruiser)]).
%false.
move_present_in_history(position(R,C), [turn(position(R,C), HIT_OR_MISS, SHIP_SUNK) | Rest]) :- !.
move_present_in_history(position(R,C), [turn(position(R2,C2), HIT_OR_MISS, SHIP_SUNK) | Rest]) :- move_present_in_history(position(R,C), Rest).

%HIT_OR_MISS
%?- initial_configuration_naive_player(InitialConfiguration), hit_or_miss(position(a, 1), InitialConfiguration, HIT_OR_MISS).
%InitialConfiguration = [carrier(position(a, 1), position(a, 5)), battleship(position(b, 1), position(b, 4)), cruiser(position(c, 1), position(c, 3)), submarine(position(d, 1), position(d, 3)), destroyer(position(e, 1), position(e, 2))],
%HIT_OR_MISS = hit.
%
%?- initial_configuration_naive_player(InitialConfiguration), hit_or_miss(position(a, 2), InitialConfiguration, HIT_OR_MISS).
%InitialConfiguration = [carrier(position(a, 1), position(a, 5)), battleship(position(b, 1), position(b, 4)), cruiser(position(c, 1), position(c, 3)), submarine(position(d, 1), position(d, 3)), destroyer(position(e, 1), position(e, 2))],
%HIT_OR_MISS = hit.
%
%?- initial_configuration_naive_player(InitialConfiguration), hit_or_miss(position(a, 6), InitialConfiguration, HIT_OR_MISS).
%InitialConfiguration = [carrier(position(a, 1), position(a, 5)), battleship(position(b, 1), position(b, 4)), cruiser(position(c, 1), position(c, 3)), submarine(position(d, 1), position(d, 3)), destroyer(position(e, 1), position(e, 2))],
%HIT_OR_MISS = miss.
%
%?- initial_configuration_naive_player(InitialConfiguration), hit_or_miss(position(j, 10), InitialConfiguration, HIT_OR_MISS).
%InitialConfiguration = [carrier(position(a, 1), position(a, 5)), battleship(position(b, 1), position(b, 4)), cruiser(position(c, 1), position(c, 3)), submarine(position(d, 1), position(d, 3)), destroyer(position(e, 1), position(e, 2))],
%HIT_OR_MISS = miss.
hit_or_miss(position(R, C), InitialShipConfiguration, hit) :- permutation(InitialShipConfiguration, [carrier(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)), battleship(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)), cruiser(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)), submarine(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)), destroyer(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer))]), positions_covered([[position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)], [position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)], [position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)], [position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)], [position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer)]], AllPositionsCovered), member(position(R, C), AllPositionsCovered), !.

hit_or_miss(position(R, C), InitialShipConfiguration, miss) :- permutation(InitialShipConfiguration, [carrier(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)), battleship(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)), cruiser(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)), submarine(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)), destroyer(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer))]), positions_covered([[position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)], [position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)], [position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)], [position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)], [position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer)]], AllPositionsCovered), not(member(position(R, C), AllPositionsCovered)), !.

%UNHIT SHIP POSITIONS
%initial_board(InitialBoard), board_set_value(InitialBoard, g, 4, hit, NewBoard), unhit_ship_positions([position(f, 4), position(g, 4), position(h, 4)], NewBoard, UnhitPositions).
%InitialBoard = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], [...|...]|...],
%NewBoard = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], [...|...]|...],
%UnhitPositions = [position(f, 4), position(h, 4)].
%
%initial_board(InitialBoard), board_set_value(InitialBoard, g, 4, hit, NewBoard1), board_set_value(NewBoard1, h, 4, hit, NewBoard2), unhit_ship_positions([position(f, 4), position(g, 4), position(h, 4)], NewBoard2, UnhitPositions).
%InitialBoard = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], [...|...]|...],
%NewBoard1 = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], [...|...]|...],
%NewBoard2 = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], [...|...]|...],
%UnhitPositions = [position(f, 4)].
%No positions covered ([]), nothing that is unhit ([]):
unhit_ship_positions([], ShipRegionInfoBoard, []) :- !.

%If position(R, C) corresponds to a ShipRegionInfoBoard unknown location then position(R, C) is an unhit ship position:
unhit_ship_positions([position(R, C) | OtherPositionsCoveredByShip], ShipRegionInfoBoard, [position(R, C) | OtherUnhitShipPositions]) :- board_get_value(ShipRegionInfoBoard, R, C, unknown), unhit_ship_positions(OtherPositionsCoveredByShip, ShipRegionInfoBoard, OtherUnhitShipPositions), !.

%If position(R, C) corresponds to a known outcome:
unhit_ship_positions([position(R, C) | OtherPositionsCoveredByShip], ShipRegionInfoBoard, OtherUnhitShipPositions) :- board_get_value(ShipRegionInfoBoard, R, C, hit), unhit_ship_positions(OtherPositionsCoveredByShip, ShipRegionInfoBoard, OtherUnhitShipPositions), !.

test_turn_history([turn(position(d, 2), hit, none), turn(position(d, 1), hit, none), turn(position(d, 4), miss, none), turn(position(e, 3), miss, none), turn(position(e, 2), hit, destroyer), turn(position(e, 1), hit, none)]).

test_board(TestBoard) :- initial_board(InitialBoard), board_set_value(InitialBoard, e, 1, hit, NewBoard1), board_set_value(NewBoard1, e, 2, hit, NewBoard2), board_set_value(NewBoard2, e, 3, miss, NewBoard3), board_set_value(NewBoard3, d, 1, hit, NewBoard4), board_set_value(NewBoard4, d, 2, hit, NewBoard5), board_set_value(NewBoard5, d, 4, miss, TestBoard).

%UPDATE
%initial_configuration_naive_player(TestInitialConfiguration), %test_turn_history(TestTurnHistory), test_board(TestShipRegionInfoBoard), update(position(d, 5), TestInitialConfiguration, TestTurnHistory, TestShipRegionInfoBoard, %TestTurnHistory_Updated, TestShipRegionInfoBoard_Updated).
%TestInitialConfiguration = [carrier(position(a, 1), position(a, 5)), battleship(position(b, 1), position(b, 4)), cruiser(position(c, 1), position(c, 3)), submarine(position(d, 1), position(d, 3)), destroyer(position(e, 1), position(e, 2))],
%TestTurnHistory = [turn(position(d, 2), hit, none), turn(position(d, 1), hit, none), turn(position(d, 4), miss, none), turn(position(e, 3), miss, none), turn(position(e, 2), hit, destroyer), turn(position(e, 1), hit, none)],
%TestShipRegionInfoBoard = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown|...], [hit, hit, unknown, miss, unknown|...], [hit, hit, miss, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], [...|...]|...],
%TestTurnHistory_Updated = [turn(position(d, 5), miss, none), turn(position(d, 2), hit, none), turn(position(d, 1), hit, none), turn(position(d, 4), miss, none), turn(position(e, 3), miss, none), turn(position(e, 2), hit, destroyer), turn(position(e, 1), hit, none)],
%TestShipRegionInfoBoard_Updated = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown|...], [hit, hit, unknown, miss, miss|...], [hit, hit, miss, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], [...|...]|...].

%initial_configuration_naive_player(TestInitialConfiguration), test_turn_history(TestTurnHistory), test_board(TestShipRegionInfoBoard), update(position(d, 3), TestInitialConfiguration, TestTurnHistory, TestShipRegionInfoBoard, TestTurnHistory_Updated, TestShipRegionInfoBoard_Updated).
%TestInitialConfiguration = [carrier(position(a, 1), position(a, 5)), battleship(position(b, 1), position(b, 4)), cruiser(position(c, 1), position(c, 3)), submarine(position(d, 1), position(d, 3)), destroyer(position(e, 1), position(e, 2))],
%TestTurnHistory = [turn(position(d, 2), hit, none), turn(position(d, 1), hit, none), turn(position(d, 4), miss, none), turn(position(e, 3), miss, none), turn(position(e, 2), hit, destroyer), turn(position(e, 1), hit, none)],
%TestShipRegionInfoBoard = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown|...], [hit, hit, unknown, miss, unknown|...], [hit, hit, miss, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], [...|...]|...],
%TestTurnHistory_Updated = [turn(position(d, 3), hit, submarine), turn(position(d, 2), hit, none), turn(position(d, 1), hit, none), turn(position(d, 4), miss, none), turn(position(e, 3), miss, none), turn(position(e, 2), hit, destroyer), turn(position(e, 1), hit, none)],
%TestShipRegionInfoBoard_Updated = [[unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown, unknown|...], [unknown, unknown, unknown, unknown, unknown, unknown|...], [hit, hit, hit, miss, unknown|...], [hit, hit, miss, unknown|...], [unknown, unknown, unknown|...], [unknown, unknown|...], [unknown|...], [...|...]|...] ;

%position(R, C) results in a miss.
update(position(R, C), OpponentInitialShipConfiguration, TurnHistory, ShipRegionInfoBoard, [turn(position(R, C), miss, none) | TurnHistory], ShipRegionInfoBoard_Updated) :- hit_or_miss(position(R, C), OpponentInitialShipConfiguration, miss), board_set_value(ShipRegionInfoBoard, R, C, miss, ShipRegionInfoBoard_Updated), !.

%position(R, C) results in a hit and sinking of the carrier ship:
update(position(R, C), OpponentInitialShipConfiguration, TurnHistory, ShipRegionInfoBoard, [turn(position(R, C), hit, carrier) | TurnHistory], ShipRegionInfoBoard_Updated) :- hit_or_miss(position(R, C), OpponentInitialShipConfiguration, hit), permutation(OpponentInitialShipConfiguration, [carrier(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)), battleship(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)), cruiser(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)), submarine(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)), destroyer(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer))]), positions_covered(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier), CarrierPositions),
unhit_ship_positions(CarrierPositions, ShipRegionInfoBoard, [position(R, C)]),
board_set_value(ShipRegionInfoBoard, R, C, hit, ShipRegionInfoBoard_Updated), !.

%position(R, C) results in a hit and sinking of the battleship ship:
update(position(R, C), OpponentInitialShipConfiguration, TurnHistory, ShipRegionInfoBoard, [turn(position(R, C), hit, battleship) | TurnHistory], ShipRegionInfoBoard_Updated) :- hit_or_miss(position(R, C), OpponentInitialShipConfiguration, hit), permutation(OpponentInitialShipConfiguration, [carrier(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)), battleship(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)), cruiser(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)), submarine(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)), destroyer(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer))]), positions_covered(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship), BattleshipPositions),
unhit_ship_positions(BattleshipPositions, ShipRegionInfoBoard, [position(R, C)]),
board_set_value(ShipRegionInfoBoard, R, C, hit, ShipRegionInfoBoard_Updated), !.

%position(R, C) results in a hit and sinking of the cruiser ship:
update(position(R, C), OpponentInitialShipConfiguration, TurnHistory, ShipRegionInfoBoard, [turn(position(R, C), hit, cruiser) | TurnHistory], ShipRegionInfoBoard_Updated) :- hit_or_miss(position(R, C), OpponentInitialShipConfiguration, hit), permutation(OpponentInitialShipConfiguration, [carrier(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)), battleship(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)), cruiser(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)), submarine(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)), destroyer(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer))]), positions_covered(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser), CruiserPositions),
unhit_ship_positions(CruiserPositions, ShipRegionInfoBoard, [position(R, C)]),
board_set_value(ShipRegionInfoBoard, R, C, hit, ShipRegionInfoBoard_Updated), !.

%position(R, C) results in a hit and sinking of the submarine ship:
update(position(R, C), OpponentInitialShipConfiguration, TurnHistory, ShipRegionInfoBoard, [turn(position(R, C), hit, submarine) | TurnHistory], ShipRegionInfoBoard_Updated) :- hit_or_miss(position(R, C), OpponentInitialShipConfiguration, hit), permutation(OpponentInitialShipConfiguration, [carrier(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)), battleship(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)), cruiser(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)), submarine(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)), destroyer(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer))]), positions_covered(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine), SubmarinePositions), unhit_ship_positions(SubmarinePositions, ShipRegionInfoBoard, [position(R, C)]), board_set_value(ShipRegionInfoBoard, R, C, hit, ShipRegionInfoBoard_Updated), !.

%position(R, C) results in a hit and sinking of the destroyer ship:
update(position(R, C), OpponentInitialShipConfiguration, TurnHistory, ShipRegionInfoBoard, [turn(position(R, C), hit, destroyer) | TurnHistory], ShipRegionInfoBoard_Updated) :- hit_or_miss(position(R, C), OpponentInitialShipConfiguration, hit), permutation(OpponentInitialShipConfiguration, [carrier(position(RS_Carrier, CS_Carrier), position(RE_Carrier, CE_Carrier)), battleship(position(RS_Battleship, CS_Battleship), position(RE_Battleship, CE_Battleship)), cruiser(position(RS_Cruiser, CS_Cruiser), position(RE_Cruiser, CE_Cruiser)), submarine(position(RS_Submarine, CS_Submarine), position(RE_Submarine, CE_Submarine)), destroyer(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer))]), positions_covered(position(RS_Destroyer, CS_Destroyer), position(RE_Destroyer, CE_Destroyer), DestroyerPositions),
unhit_ship_positions(DestroyerPositions, ShipRegionInfoBoard, [position(R, C)]),
board_set_value(ShipRegionInfoBoard, R, C, hit, ShipRegionInfoBoard_Updated), !.

%position(R, C) results in a hit, but not a sinking.
update(position(R, C), OpponentInitialShipConfiguration, TurnHistory, ShipRegionInfoBoard, [turn(position(R, C), hit, none) | TurnHistory], ShipRegionInfoBoard_Updated) :- hit_or_miss(position(R, C), OpponentInitialShipConfiguration, hit), board_set_value(ShipRegionInfoBoard, R, C, hit, ShipRegionInfoBoard_Updated), !.

%PLAY_GAME
%Player1 Wins: Sunk all ships
play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves, Player2_NextMoves, Player1) :- winning_history(Player1_TurnHistory), print('Player1 Wins! Sunk All Ships\n'), !.

%Player2 Wins: Sunk all ships
play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves, Player2_NextMoves, Player2) :- winning_history(Player2_TurnHistory), print('Player2 Wins! Sunk All Ships\n'), !.

%Player2 Wins: Player1 tries to make the same move twice:
play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves, Player2_NextMoves, Player2) :- player1s_turn(Player1_TurnHistory, Player2_TurnHistory), next_moves(Player1, Player1_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, [Player1_NextMove | Player1_FutureMoves]),
move_present_in_history(Player1_NextMove, Player1_TurnHistory), print('Player2 Wins! Player1 made the same move twice!\n'), !.

%Player1 Wins: Player2 tries to make the same move twice:
play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves, Player2_NextMoves, Player1) :- player2s_turn(Player1_TurnHistory, Player2_TurnHistory), next_moves(Player2, Player1_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, [Player2_NextMove | Player2_FutureMoves]),
move_present_in_history(Player2_NextMove, Player2_TurnHistory), print('Player1 Wins! Player2 made the same move twice!\n'), !.

%It's Player1's turn, but there are no Player1 moves left to process. Call Player1 to get the next list of moves and continue playing:
play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, [], Player2_NextMoves, WinningPlayer) :- player1s_turn(Player1_TurnHistory, Player2_TurnHistory), next_moves(Player1, Player1_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves), play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves, Player2_NextMoves, WinningPlayer), !.

%It's Player2's turn, but there are no Player2 moves left to process. Call Player2 to get the next list of moves and continue playing:
play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves, [], WinningPlayer) :- player2s_turn(Player1_TurnHistory, Player2_TurnHistory), next_moves(Player2, Player2_InitialConfiguration, Player2_TurnHistory, Player1_TurnHistory, Player2_ShipRegionInfoBoard, Player1_ShipRegionInfoBoard, Player2_NextMoves), play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves, Player2_NextMoves, WinningPlayer), !.

%It's Player1's turn and there is at least one Player1 move left to process. "Play the move," update the appropriate board and turn history, continue game:
play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, [Player1_NextMove | Player1_FutureMoves], Player2_NextMoves, WinningPlayer) :- player1s_turn(Player1_TurnHistory, Player2_TurnHistory),  
update(Player1_NextMove, Player2_InitialConfiguration, Player1_TurnHistory, Player2_ShipRegionInfoBoard, [Player1_LatestTurn | Player1_TurnHistory], Player2_ShipRegionInfoBoard_Updated), play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, [Player1_LatestTurn | Player1_TurnHistory], Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard_Updated, Player1_FutureMoves, Player2_NextMoves, WinningPlayer), print('Player1 Turn = '), print(Player1_LatestTurn), print('\n'), !.

%It's Player2's turn and there is at least one Player2 move left to process. "Play the move," update the appropriate board and turn history, continue game:
play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves, [Player2_NextMove | Player2_FutureMoves], WinningPlayer) :- player2s_turn(Player1_TurnHistory, Player2_TurnHistory),  
update(Player2_NextMove, Player1_InitialConfiguration, Player2_TurnHistory, Player1_ShipRegionInfoBoard, [Player2_LatestTurn | Player2_TurnHistory], Player1_ShipRegionInfoBoard_Updated),
play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, [Player2_LatestTurn | Player2_TurnHistory], Player1_ShipRegionInfoBoard_Updated, Player2_ShipRegionInfoBoard, Player1_NextMoves, Player2_FutureMoves, WinningPlayer), print('Player2 Turn = '), print(Player2_LatestTurn), print('\n'), !.

%GO
go(Player1, Player2) :- initial_configuration(Player1, Player1_InitialConfiguration), initial_configuration(Player2, Player2_InitialConfiguration), Player1_TurnHistory = [], Player2_TurnHistory = [], Player1_NextMoves = [], Player2_NextMoves = [], initial_board(Player1_ShipRegionInfoBoard), initial_board(Player2_ShipRegionInfoBoard), print('End game:\n'), play_game(Player1, Player2, Player1_InitialConfiguration, Player2_InitialConfiguration, Player1_TurnHistory, Player2_TurnHistory, Player1_ShipRegionInfoBoard, Player2_ShipRegionInfoBoard, Player1_NextMoves, Player2_NextMoves, WinningPlayer), print('Start game:\n'), !.

%?- go(naive_player, naive_player2).