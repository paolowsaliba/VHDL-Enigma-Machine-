library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_timing_640x480 is
	port(
	clk50 : in std_logic;
	rst : in std_logic;
	pix_x : out unsigned(9 downto 0);
	pix_x : out unsigned(9 downto 0);
	video_on : out std_logic;
	hsync : out std_logic;
	vsync : out std_logic;
	pixel_tick : out std_logic
 );
 end entity;
 
 architecture rtl of vga_timing_640x480 is
	constant H_VISIBLE : integer := 640;
	constant H_FRONT : integer := 16;
	constant H_SYNC : integer := 96;
	constant H_BACK : integer := 48;
	constant H_TOTAL : integer := H_VISIBLE + H_FRONT + H_SYNC + H_BACK; -- 800
	
	constant V_VISIBLE : integer := 480;
	constant V_FRONT : integer := 10;
	constant V_SYNC : integer := 2;
	constant V_BACK : integer := 33;
	constant V_TOTAL : integer := V_VISIBLE + V_FRONT + V_SYNC + V_BACK; -- 525
	
	signal tick25 : std_logic := '0';
	signal h_cnt : unsigned(9 downto 0) := (others => '0');
	signal v_cnt : unsigned(9 downto 0) := (others => '0');
	begin
		process (clk50)
				begin
		if rising_edge(clk50) then
			if rst = '1' then 
			tick25 <= '0';
			else 
			tick25 <= not tick25;
		end if;
		end if;
	end process;