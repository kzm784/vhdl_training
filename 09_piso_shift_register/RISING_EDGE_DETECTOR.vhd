library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISING_EDGE_DETECTOR is
    port (
        CLK      : in  std_logic;
        RST_N    : in  std_logic;
        I_SIGNAL : in  std_logic;
        O_PULSE  : out std_logic
    );
end entity RISING_EDGE_DETECTOR;

architecture RTL of RISING_EDGE_DETECTOR is

begin

    -- RTL implementation here

end architecture RTL;
