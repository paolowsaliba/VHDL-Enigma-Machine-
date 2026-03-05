-- EnigmaGears VHDL code
-- Inputs, scrambles, and outputs a letter encoded as an integer range 0 to 25
------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;
------------------------------------------------------------------------------
ENTITY EnigmaGears IS
	PORT(input: IN character_az;
		gear_order: IN gear_indices;
		gear_pos: IN gear_positions;
		output: OUT character_az);
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
	output <= 
		indexof(
		indexof(
		indexof(
		gears(3)((CHARACTER'POS(gears(gear_order(2))
		((CHARACTER'POS(gears(gear_order(1))
		((CHARACTER'POS(gears(gear_order(0))
		((CHARACTER'POS(input)-65+gear_pos(0))mod 26))-65+gear_pos(1))mod 26))-65+gear_pos(2))mod 26))-65+gear_pos(0))mod 26)
		, gears(gear_order(2)), gear_pos(2))
		, gears(gear_order(1)), gear_pos(1))
		, gears(gear_order(0)), gear_pos(0));
END;