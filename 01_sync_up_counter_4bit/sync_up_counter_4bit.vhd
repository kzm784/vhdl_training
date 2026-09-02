library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_up_counter_4bit is
    port(
        CLK   : in  std_logic;
        RST_N : in  std_logic;
        I_EN    : in  std_logic;
        O_COUNT : out unsigned(3 downto 0)
    );
end sync_up_counter_4bit;


architecture RTL of sync_up_counter_4bit is

    signal s_o_count : unsigned(3 downto 0) := (others => '0');

begin

    process(CLK, RST_N)
    begin
        if (RST_N = '0') then
            s_o_count <= (others => '0');
        elsif rising_edge(CLK) then
            if (I_EN = '1') then
                s_o_count <= s_o_count + 1;
            end if;
        end if;
    end process;

    O_COUNT <= s_o_count;

end RTL;