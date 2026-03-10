LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;
-- Use '[' in output to represent a NULL output
ENTITY GearControl IS
	PORT(char_to_write: IN INTEGER RANGE 0 TO 31;
		  rst, confirm, mode_button, clk:  IN STD_LOGIC;
		  display_chars: OUT logical_display_chars:= (OTHERS => "11010");
		  gear_order: BUFFER gear_indices:= ("00", "01", "10");
		  gear_positions: BUFFER gear_positions:= (OTHERS => "00000"));
END;

ARCHITECTURE arch OF GearControl IS
	TYPE mode_type IS (S_WRITE, S_GEARS, S_PLUGBOARD);
	SIGNAL mode: mode_type:= S_WRITE;
	SIGNAL confirm_control: STD_LOGIC_VECTOR(1 DOWNTO 0):= (confirm, '0');
	SIGNAL mode_control: STD_LOGIC_VECTOR(1 DOWNTO 0):= (mode_button, '0');
	SIGNAL write_position: INTEGER RANGE 0 TO 20:= 0;
BEGIN
	mode_control(0) <= mode_button; 
	PROCESS(clk, rst)
	BEGIN
		IF rst = '1' THEN
			display_chars <= (OTHERS => "11010");
			write_position <= 0;
		END IF;
		IF RISING_EDGE(clk) THEN
			IF mode_control = "00" THEN
				mode_control(1) <= '1';
				CASE mode IS
					WHEN S_WRITE =>
						mode <= S_GEARS;
					WHEN S_GEARS =>
						mode <= S_PLUGBOARD;
					WHEN OTHERS =>
						mode <= S_WRITE;
				END CASE;
			ELSIF mode_control = "11" THEN
				mode_control(1) <= '0';
			END IF;
			
			IF mode = S_WRITE THEN
				display_chars(write_position) <= STD_LOGIC_VECTOR(TO_UNSIGNED(char_to_write, 5));
				IF write_position < 20 THEN
					write_position <= write_position + 1;
				ELSE
					write_position <= 0;
					display_chars <= (OTHERS => "11010");
				END IF;
				IF gear_positions(0) < "11001" THEN
					gear_positions(0) <= gear_positions(0) + 1;
				ELSE
					gear_positions(0) <= "00000";
					IF gear_positions(1) < "11001" THEN
						gear_positions(1) <= gear_positions(1) + 1;
					ELSE
						gear_positions(1) <= "00000";
						IF gear_positions(2) < "11001" THEN
							gear_positions(2) <= gear_positions(2) + 1;
						ELSE
							gear_positions(2) <= "00000";
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END;
				