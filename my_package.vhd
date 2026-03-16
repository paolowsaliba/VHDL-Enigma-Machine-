LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE my_package IS
	SUBTYPE CharIndex IS INTEGER RANGE 0 TO 31;
	SUBTYPE PositionIndex IS INTEGER RANGE 0 TO 31;
	TYPE PositionArray IS ARRAY(0 TO 2) OF PositionIndex;
	SUBTYPE LogicLetter IS STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	TYPE gear_indices IS ARRAY(0 TO 2) OF STD_LOGIC_VECTOR(1 DOWNTO 0);
	TYPE gear_positions IS ARRAY(0 TO 2) OF UNSIGNED(4 DOWNTO 0);
	TYPE IntGearIndices IS ARRAY(0 TO 2) OF INTEGER RANGE 0 TO 3;
	
	TYPE logical_gear IS ARRAY(0 TO 25) OF STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	TYPE logical_display_chars IS ARRAY (0 TO 20) OF STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	SUBTYPE character_az IS CHARACTER RANGE 'A' TO 'Z';
	SUBTYPE integer_az IS INTEGER RANGE 0 TO 3;
	TYPE gear IS ARRAY (0 to 25) OF character_az;
	TYPE GearArray IS ARRAY(0 TO 3) OF gear;
	
	TYPE string_az IS ARRAY (0 TO 20) OF character_az;
	TYPE az_disp_logic_arr IS ARRAY (0 TO 20) OF CHARACTER RANGE 'A' TO '[';
	
	CONSTANT default_plugboard: logical_gear:= ("00000", "00001", "00010", "00011", "00100", "00101",
															  "00110", "00111", "01000", "01001", "01010", "01011",
															  "01100", "01101", "01110", "01111", "10000", "10001", 
															  "10010", "10011", "10100", "10101", "10110", "10111",
															  "11000", "11001");
	CONSTANT NUM_ROTORS: NATURAL:= 3;
	
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
							
	CONSTANT gears: GearArray:=(I, II, III, reflector);
	
	
	FUNCTION indexof (char : character_az; arr : gear; position : PositionIndex) RETURN character_az;
	FUNCTION forward_through_rotors (char : LogicLetter; gear_order : IntGearIndices; positions : PositionArray) RETURN character_az;
	FUNCTION pass_through_reflector (char : character_az; arr : gear) RETURN character_az;
	FUNCTION reverse_through_rotors (char : character_az; gear_order : IntGearIndices; positions : PositionArray) RETURN LogicLetter;
	FUNCTION pass_through_plugboard (char : LogicLetter; arr : logical_gear) RETURN LogicLetter;
END;

PACKAGE BODY my_package IS
	FUNCTION indexof (char : character_az; arr : gear; position : PositionIndex) RETURN character_az IS
		VARIABLE result: character_az := 'A';
		VARIABLE shifted_idx: INTEGER RANGE 0 TO 25 := 0;
	BEGIN
		FOR char_idx IN arr'range LOOP
			shifted_idx := (char_idx+position)MOD 26;
			IF char = arr(shifted_idx) THEN
				result := CHARACTER'VAL(shifted_idx-position+65);
				EXIT;
			END IF;
		END LOOP;
		RETURN result;
	END FUNCTION;
	
	FUNCTION forward_through_rotors (char : LogicLetter; gear_order : IntGearIndices; positions : PositionArray) RETURN character_az IS
		VARIABLE current: character_az := 'A';
		VARIABLE shifted_idx: INTEGER RANGE 0 TO 25 := 0;
	BEGIN
		current := CHARACTER'VAL(TO_INTEGER(UNSIGNED(char)) + CHARACTER'POS('A'));
		FOR rotor_idx IN 0 TO NUM_ROTORS-1 LOOP
			shifted_idx := (CHARACTER'POS(current)-65+positions(rotor_idx))MOD 26;
			current := gears(gear_order(rotor_idx))(shifted_idx);
		END LOOP;
		RETURN current;
	END FUNCTION;
	
	FUNCTION pass_through_reflector (char : character_az; arr : gear) RETURN character_az IS
	BEGIN
		RETURN arr(CHARACTER'POS(char)-65);
	END FUNCTION;
	
	FUNCTION reverse_through_rotors (char : character_az; gear_order : IntGearIndices; positions : PositionArray) RETURN LogicLetter IS
		VARIABLE current: character_az := 'A';
		VARIABLE shifted_idx: INTEGER RANGE 0 TO 25 := 0;
	BEGIN
		current := char;
		FOR rotor_idx IN NUM_ROTORS-1 DOWNTO 0 LOOP
			current := indexof(current, gears(gear_order(rotor_idx)), positions(rotor_idx));
		END LOOP;
		RETURN STD_LOGIC_VECTOR(TO_UNSIGNED(CHARACTER'POS(current)-65, 5));
	END FUNCTION;
	
	FUNCTION pass_through_plugboard (char : LogicLetter; arr : logical_gear) RETURN LogicLetter IS
	BEGIN
		RETURN arr(TO_INTEGER(UNSIGNED(char)));
	END FUNCTION;
END;