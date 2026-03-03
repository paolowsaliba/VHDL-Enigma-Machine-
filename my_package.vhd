LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE my_package IS
	SUBTYPE character_az IS CHARACTER RANGE 'A' TO 'Z';
	TYPE gear IS ARRAY (CHARACTER'POS('A') TO CHARACTER'POS('Z')) OF CHARACTER RANGE 'A' TO 'Z';
	TYPE gear_indices IS ARRAY(0 TO 2) OF INTEGER RANGE 0 TO 2;
	TYPE gear_positions IS ARRAY(0 TO 2) OF INTEGER RANGE 0 TO 25;
	
	FUNCTION indexof (char : character_az; arr : gear) RETURN character_az;
END;

PACKAGE BODY my_package IS
	FUNCTION indexof (char : character_az; arr : gear) RETURN character_az IS
		VARIABLE result: character_az := 'A';
	BEGIN
		FOR i IN arr'range LOOP
			IF arr(i) = char THEN
				result := CHARACTER'VAL(i);
				EXIT;
				END IF;
		END LOOP;
		RETURN result;
	END FUNCTION;
end;