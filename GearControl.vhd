LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MY_PACKAGE.ALL;
-- Use "11010" in output to represent a NULL output
ENTITY GearControl IS
	-- char_to_write is given by gear core
	-- display_chars are passed to VGA
	PORT(char_to_write, plugboard_in: IN INTEGER RANGE 0 TO 31;
		  rst, confirm, mode_button, clk:  IN STD_LOGIC;
		  display_chars: OUT STD_LOGIC_VECTOR(104 DOWNTO 0):= (OTHERS => '0');
		  gear_order: OUT gear_indices:= ("00", "01", "10");
		  gear_positions: BUFFER gear_positions:= (OTHERS => "00000");
		  plugboard: OUT logical_gear:= default_plugboard);
END;

ARCHITECTURE arch OF GearControl IS
	TYPE mode_type IS (S_WRITE, S_GEARS, S_PLUGBOARD);
	SIGNAL mode: mode_type:= S_WRITE;
	
	SIGNAL confirm_control: STD_LOGIC_VECTOR(1 DOWNTO 0):= (confirm, '0');
	SIGNAL mode_control: STD_LOGIC_VECTOR(1 DOWNTO 0):= (mode_button, '0');
	
	SIGNAL write_position: INTEGER RANGE 0 TO 20:= 0;
	SIGNAL gear_write_position: INTEGER RANGE 0 TO 2:= 0;
	SIGNAL plugboard_write_position: INTEGER RANGE 0 TO 25:= 0;
	
	SIGNAL display_chars_internal: logical_display_chars:= (OTHERS=>"11010");
BEGIN
	-- Control signals prevent continuos input. Second bit says if button has already been pressed
	confirm_control(0) <= confirm;
	mode_control(0) <= mode_button; 
	PROCESS(clk, rst)
	BEGIN
		-- On reset, set display characters to empty and set write position to zero
		IF rst = '0' THEN
			display_chars_internal <= (OTHERS => "11010");
			write_position <= 0;
			plugboard_write_position <= 0;
			plugboard <= default_plugboard;
			gear_order <= ("00", "01", "10");
			gear_positions <= (OTHERS => "00000");
			mode <= S_WRITE;
		ELSIF RISING_EDGE(clk) THEN
			-- Update mode
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
			-- Update confirm
			IF confirm_control = "00" THEN
				confirm_control(1) <= '1';
			ELSIF confirm_control = "11" THEN
				confirm_control(1) <= '0';
			END IF;
			-- If confirm is low and button press hasn't been registered yet. write character and increment write_position and gear_position
			IF mode = S_WRITE AND confirm_control = "00" THEN
				display_chars_internal(write_position) <= STD_LOGIC_VECTOR(TO_UNSIGNED(char_to_write, 5));
				IF write_position < 20 THEN
					write_position <= write_position + 1;
				ELSE
					write_position <= 0;
					display_chars_internal <= (OTHERS => "11010");
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
							gear_positions(0) <= "00000";
							gear_positions(1) <= "00000";
							gear_positions(2) <= "00000";
						END IF;
					END IF;
				END IF;
			-- Gear Select
			ELSIF mode = S_GEARS AND confirm_control = "00" AND plugboard_in < 4 THEN
				gear_order(gear_write_position) <= STD_LOGIC_VECTOR(TO_UNSIGNED(plugboard_in, 2));
				IF gear_write_position < 2 THEN
					gear_write_position <= gear_write_position + 1;
				ELSE 
					gear_write_position <= 0;
				END IF;
			-- Plugboard Select
			ELSIF mode = S_PLUGBOARD AND confirm_control = "00" AND plugboard_in < 26 THEN
				plugboard(plugboard_write_position) <= STD_LOGIC_VECTOR(TO_UNSIGNED(plugboard_in, 5));
				plugboard((plugboard_write_position+13)MOD 26) <= STD_LOGIC_VECTOR(TO_UNSIGNED((plugboard_write_position+13)MOD 26, 5));
				IF plugboard_write_position < 25 THEN
					plugboard_write_position <= plugboard_write_position + 1;
				ELSE
					 plugboard_write_position <= 0;
				END IF;
			END IF;
		END IF;
	END PROCESS;
	display_chars <= display_chars_internal(0) & display_chars_internal(1) & display_chars_internal(2) &
						  display_chars_internal(3) & display_chars_internal(4) & display_chars_internal(5) &
						  display_chars_internal(6) & display_chars_internal(7) & display_chars_internal(8) &
						  display_chars_internal(9) & display_chars_internal(10) & display_chars_internal(11) &
						  display_chars_internal(12) & display_chars_internal(13) & display_chars_internal(14) &
						  display_chars_internal(15) & display_chars_internal(16) & display_chars_internal(17) &
						  display_chars_internal(18) & display_chars_internal(19) & display_chars_internal(20);
END;
				