library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_test_top is
  port(
    CLOCK_50    : in  std_logic;
    KEY         : in  std_logic_vector(3 downto 0);
    SW          : in  std_logic_vector(9 downto 0);

    VGA_R       : out std_logic_vector(7 downto 0);
    VGA_G       : out std_logic_vector(7 downto 0);
    VGA_B       : out std_logic_vector(7 downto 0);
    VGA_HS      : out std_logic;
    VGA_VS      : out std_logic;
    VGA_CLK     : out std_logic;
    VGA_BLANK_N : out std_logic;
    VGA_SYNC_N  : out std_logic
  );
end entity;

architecture rtl of vga_test_top is
  signal rst        : std_logic;
  signal pix_x      : unsigned(9 downto 0);
  signal pix_y      : unsigned(9 downto 0);
  signal video_on   : std_logic;
  signal pixel_tick : std_logic;
  signal text_bus   : std_logic_vector(104 downto 0);
begin
  rst <= not KEY(3);

  U_TIMING: entity work.vga_timing_640x480
    port map(
      clk50      => CLOCK_50,
      rst        => rst,
      pix_x      => pix_x,
      pix_y      => pix_y,
      video_on   => video_on,
      hsync      => VGA_HS,
      vsync      => VGA_VS,
      pixel_tick => pixel_tick
    );

  U_TEST: entity work.text_bus_test
    port map(
      clk      => CLOCK_50,
      rst      => rst,
      key0_n   => KEY(0),
      sw       => SW(4 downto 0),
      text_bus => text_bus
    );

  U_TEXT: entity work.enigma_text_line_bdf
    port map(
      pix_x    => pix_x,
      pix_y    => pix_y,
      video_on => video_on,
      text_bus => text_bus,
      red      => VGA_R,
      green    => VGA_G,
      blue     => VGA_B
    );

  VGA_CLK     <= pixel_tick;
  VGA_BLANK_N <= video_on;
  VGA_SYNC_N  <= '1';
end architecture;