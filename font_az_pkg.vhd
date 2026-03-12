library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package font_ax_pkg is
  subtype glyph_row_t is std_logic_vector(7 downto 0);
  type glyph_t is array (0 to 7) of glyph_row_t;
  type font_t is array (0 to 26) of glyph_t;

  constant FONT_AZ : font_t;

  function font_index_from_code(code : unsigned(4 downto 0)) return integer;
end package;

package body font_ax_pkg is
  constant FONT_AZ : font_t := (
    -- A
    (x"18", x"24", x"42", x"7E", x"42", x"42", x"42", x"00"),
    -- B
    (x"7C", x"42", x"42", x"7C", x"42", x"42", x"7C", x"00"),
    -- C
    (x"3C", x"42", x"40", x"40", x"40", x"42", x"3C", x"00"),
    -- D
    (x"78", x"44", x"42", x"42", x"42", x"44", x"78", x"00"),
    -- E
    (x"7E", x"40", x"40", x"7C", x"40", x"40", x"7E", x"00"),
    -- F
    (x"7E", x"40", x"40", x"7C", x"40", x"40", x"40", x"00"),
    -- G
    (x"3C", x"42", x"40", x"4E", x"42", x"42", x"3C", x"00"),
    -- H
    (x"42", x"42", x"42", x"7E", x"42", x"42", x"42", x"00"),
    -- I
    (x"3E", x"08", x"08", x"08", x"08", x"08", x"3E", x"00"),
    -- J
    (x"1E", x"04", x"04", x"04", x"04", x"44", x"38", x"00"),
    -- K
    (x"42", x"44", x"48", x"70", x"48", x"44", x"42", x"00"),
    -- L
    (x"40", x"40", x"40", x"40", x"40", x"40", x"7E", x"00"),
    -- M
    (x"42", x"66", x"5A", x"5A", x"42", x"42", x"42", x"00"),
    -- N
    (x"42", x"62", x"52", x"4A", x"46", x"42", x"42", x"00"),
    -- O
    (x"3C", x"42", x"42", x"42", x"42", x"42", x"3C", x"00"),
    -- P
    (x"7C", x"42", x"42", x"7C", x"40", x"40", x"40", x"00"),
    -- Q
    (x"3C", x"42", x"42", x"42", x"4A", x"44", x"3A", x"00"),
    -- R
    (x"7C", x"42", x"42", x"7C", x"48", x"44", x"42", x"00"),
    -- S
    (x"3C", x"42", x"40", x"3C", x"02", x"42", x"3C", x"00"),
    -- T
    (x"7E", x"18", x"18", x"18", x"18", x"18", x"18", x"00"),
    -- U
    (x"42", x"42", x"42", x"42", x"42", x"42", x"3C", x"00"),
    -- V
    (x"42", x"42", x"42", x"42", x"42", x"24", x"18", x"00"),
    -- W
    (x"42", x"42", x"42", x"5A", x"5A", x"66", x"42", x"00"),
    -- X
    (x"42", x"24", x"18", x"18", x"18", x"24", x"42", x"00"),
    -- Y
    (x"42", x"24", x"18", x"18", x"18", x"18", x"18", x"00"),
    -- Z
    (x"7E", x"04", x"08", x"10", x"20", x"40", x"7E", x"00"),
    -- blank
    (x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00")
  );

  function font_index_from_code(code : unsigned(4 downto 0)) return integer is
    variable val : integer;
  begin
    val := to_integer(code);
    if val <= 25 then
      return val;
    else
      return 26;
    end if;
  end function;
end package body;