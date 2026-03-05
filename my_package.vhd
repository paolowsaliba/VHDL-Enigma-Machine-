LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE my_package IS
	SUBTYPE character_az IS CHARACTER RANGE 'A' TO 'Z';
	SUBTYPE integer_az IS INTEGER RANGE 0 TO 25;
	TYPE gear IS ARRAY (0 to 25) OF character_az;
	TYPE gear_indices IS ARRAY(0 TO 2) OF INTEGER RANGE 0 TO 2;
	TYPE gear_positions IS ARRAY(0 TO 2) OF integer_az;
	
	FUNCTION indexof (char : character_az; arr : gear; position : integer_az) RETURN character_az;
END;

PACKAGE BODY my_package IS
	FUNCTION indexof (char : character_az; arr : gear; position : integer_az) RETURN character_az IS
		VARIABLE result: character_az := 'A';
	BEGIN
		FOR i IN arr'range LOOP
			IF arr((i+position)mod 26) = char THEN
				result := CHARACTER'VAL(i+65);
				EXIT;
				END IF;
		END LOOP;
		RETURN result;
	END FUNCTION;
end;