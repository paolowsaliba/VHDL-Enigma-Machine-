library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.font_ax_pkg.all;

entity enigma_text_line_bdf is
  port(
    pix_x    : in  unsigned(9 downto 0);
    pix_y    : in  unsigned(9 downto 0);
    video_on : in  std_logic;
    text_bus : in  std_logic_vector(104 downto 0);
    red      : out std_logic_vector(7 downto 0);
    green    : out std_logic_vector(7 downto 0);
    blue     : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of enigma_text_line_bdf is
  constant START_X : integer := 80;
  constant START_Y : integer := 40;
  constant CHAR_W  : integer := 8;
  constant CHAR_H  : integer := 8;
  constant NUM_CH  : integer := 21;
begin
  process(pix_x, pix_y, video_on, text_bus)
    variable px, py      : integer;
    variable char_index  : integer;
    variable font_col    : integer;
    variable font_row    : integer;
    variable glyph_index : integer;
    variable row_bits    : std_logic_vector(7 downto 0);
    variable pixel_on    : std_logic;
    variable char_code   : unsigned(4 downto 0);
    variable lo_bit      : integer;
  begin
    red   <= (others => '1');
    green <= (others => '1');
    blue  <= (others => '1');

    if video_on = '0' then
      red   <= (others => '0');
      green <= (others => '0');
      blue  <= (others => '0');
    else
      px := to_integer(pix_x);
      py := to_integer(pix_y);
      pixel_on := '0';

      if (px >= START_X) and (px < START_X + NUM_CH*CHAR_W) and
         (py >= START_Y) and (py < START_Y + CHAR_H) then

        char_index := (px - START_X) / CHAR_W;
        font_col   := (px - START_X) mod CHAR_W;
        font_row   := (py - START_Y) mod CHAR_H;

        lo_bit := char_index * 5;
        char_code := unsigned(text_bus(lo_bit + 4 downto lo_bit));

        glyph_index := font_index_from_code(char_code);
        row_bits := FONT_AZ(glyph_index)(font_row);

        if row_bits(7 - font_col) = '1' then
          pixel_on := '1';
        end if;
      end if;

      if pixel_on = '1' then
        red   <= (others => '0');
        green <= (others => '0');
        blue  <= (others => '0');
      end if;
    end if;
  end process;
end architecture;