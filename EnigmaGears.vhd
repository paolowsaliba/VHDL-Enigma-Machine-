-- EnigmaGears VHDL code
-- Inputs, scrambles, and outputs a letter encoded as an integer range 0 to 25
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;
------------------------------------------------------------------------------
ENTITY EnigmaGears IS
	PORT(input: IN CHARACTER RANGE 'A' TO 'Z';
		gear_order: IN gear_indices;
		gear_pos: INOUT gear_positions;
		output: OUT CHARACTER RANGE 'A' TO 'Z');
END;
------------------------------------------------------------------------------
ARCHITECTURE arch OF EnigmaGears IS
	-- Gears are taken from I, II, and III of the Enigma I
	-- Reflector is taken from the UKW of the German Railway (Rocket)
	CONSTANT I: gear:=('E', 'K', 'M', 'F', 'L', 'G', 'D', 'Q', 'V', 'Z', 'N', 
							'T', 'O', 'W', 'Y', 'H', 'X', 'U', 'S', 'P', 'A', 'I', 
							'B', 'R', 'C', 'J');
	CONSTANT II: gear:=('A', 'J', 'D', 'K', 'S', 'I', 'R', 'U', 'X', 'B', 'L', 
							'H', 'W', 'T', 'M', 'C', 'Q', 'G', 'Z', 'N', 'P', 'Y', 
							'F', 'V', 'O', 'E');
	CONSTANT III: gear:=('B', 'D', 'F', 'H', 'J', 'L', 'C', 'P', 'R', 'T', 'X',	
							'V', 'Z', 'N', 'Y', 'E', 'I', 'W', 'G', 'A', 'K', 'M', 
							'U', 'S', 'Q', 'O');
	CONSTANT reflector: gear:=('Q', 'Y', 'H', 'O', 'G', 'N', 'E', 'C', 'V', 'P', 
							'U', 'Z', 'T', 'F', 'D', 'J', 'A', 'X', 'W', 'M', 'K', 
							'I', 'S', 'R', 'B', 'L');
	TYPE gear_array IS ARRAY(0 TO 3) OF gear;
	CONSTANT gears: gear_array:=(I, II, III, reflector);
BEGIN
	PROCESS(input, gear_order)
		VARIABLE tc1, tc2, tc3, tc4, tc5, tc6: CHARACTER RANGE 'A' TO 'Z';
	BEGIN
		tc1 := gears(gear_order(0))(CHARACTER'POS(input));
		tc2 := gears(gear_order(1))(CHARACTER'POS(tc1));
		tc3 := gears(gear_order(2))(CHARACTER'POS(tc2));
		tc4 := gears(3)(CHARACTER'POS(tc3));
		tc5 := indexof(tc4, gears(gear_order(2)));
		tc6 := indexof(tc4, gears(gear_order(1)));
		output <= indexof(tc4, gears(gear_order(0)));
	END PROCESS;
END;