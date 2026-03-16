-- EnigmaGears VHDL code
-- Inputs, scrambles, and outputs a letter encoded as an integer range 0 to 25
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;
------------------------------------------------------------------------------
ENTITY EnigmaGears IS
	PORT(input: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		gear_order: IN gear_indices;
		gear_pos: IN gear_positions;
		plugboard: IN logical_gear:= default_plugboard;
		output: OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
		SIGNAL splugboard_input: LogicLetter;
		SIGNAL safter_rotors: character_az;
		SIGNAL safter_reflector: character_az;
		SIGNAL safter_core: LogicLetter;
		SIGNAL first_reverse: character_az;
		SIGNAL sec_reverse: character_az;
		SIGNAL th_reverse: character_az;
END;
------------------------------------------------------------------------------
ARCHITECTURE arch OF EnigmaGears IS
	-- Gears are taken from I, II, and III of the Enigma I
	-- Reflector is taken from the UKW of the German Railway (Rocket)
BEGIN
	PROCESS(input, gear_order, gear_pos, plugboard)
		VARIABLE order_internal: IntGearIndices;
		VARIABLE position_internal: PositionArray;
		VARIABLE plugboard_input: LogicLetter;
		VARIABLE after_rotors: character_az;
		VARIABLE after_reflector: character_az;
		VARIABLE after_core: LogicLetter;
		
		VARIABLE f_rev, s_rev, t_rev : character_az;
	BEGIN
		order_internal := (TO_INTEGER(UNSIGNED(gear_order(0))), TO_INTEGER(UNSIGNED(gear_order(1))), TO_INTEGER(UNSIGNED(gear_order(2))));
		position_internal := (TO_INTEGER(gear_pos(0)), TO_INTEGER(gear_pos(1)), TO_INTEGER(gear_pos(2)));
		plugboard_input := pass_through_plugboard(input, plugboard);
		after_rotors := forward_through_rotors(plugboard_input, order_internal, position_internal);
		after_reflector := pass_through_reflector(after_rotors, gears(3));
		after_core := reverse_through_rotors(after_reflector, order_internal, position_internal);
		output <= pass_through_plugboard(after_core, plugboard);
		
		splugboard_input <= plugboard_input;
		safter_rotors <= after_rotors;
		safter_reflector <= after_reflector;
		safter_core <= after_core;
		first_reverse <= indexof(after_reflector, gears(2), position_internal(2));
		f_rev := indexof(after_reflector, gears(2), position_internal(2));
		sec_reverse <= indexof(f_rev, gears(1), position_internal(1));
		s_rev := indexof(f_rev, gears(1), position_internal(1));
		th_reverse <= indexof(s_rev, gears(0), position_internal(0));
		t_rev := indexof(s_rev, gears(0), position_internal(0));
	END PROCESS;
END;