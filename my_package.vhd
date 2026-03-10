LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE my_package IS
	SUBTYPE CharIndex IS INTEGER RANGE 0 TO 31;
	SUBTYPE PositionIndex IS INTEGER RANGE 0 TO 31;
	
	TYPE gear_indices IS ARRAY(0 TO 2) OF STD_LOGIC_VECTOR(1 DOWNTO 0);
	TYPE gear_positions IS ARRAY(0 TO 2) OF UNSIGNED(4 DOWNTO 0);
	
	TYPE logical_display_chars IS ARRAY (0 TO 20) OF STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	SUBTYPE character_az IS CHARACTER RANGE 'A' TO 'Z';
	SUBTYPE integer_az IS INTEGER RANGE 0 TO 3;
	TYPE gear IS ARRAY (0 to 25) OF character_az;
	
	TYPE string_az IS ARRAY (0 TO 20) OF character_az;
	TYPE az_disp_logic_arr IS ARRAY (0 TO 20) OF CHARACTER RANGE 'A' TO '[';

	FUNCTION indexof (char : character_az; arr : gear; position : PositionIndex) RETURN character_az;
END;

PACKAGE BODY my_package IS
	FUNCTION indexof (char : character_az; arr : gear; position : PositionIndex) RETURN character_az IS
		VARIABLE result: character_az := 'A';
	BEGIN
		FOR i IN arr'range LOOP
			IF arr((i+position)mod 26) = char THEN
				result := CHARACTER'VAL(i+position+65);
				EXIT;
				END IF;
		END LOOP;
		RETURN result;
	END FUNCTION;
END;