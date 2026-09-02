library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_up_counter_8bit is
    port(
        CLK     : in  std_logic;
        RST_N   : in  std_logic;
        I_LOAD  : in  std_logic;
        I_D     : in  unsigned(7 downto 0);
        O_COUNT : out unsigned(7 downto 0)
    );
end sync_up_counter_8bit;


architecture RTL of sync_up_counter_8bit is

    signal s_o_count : unsigned(7 downto 0) := (others => '1');

begin

    process(CLK, RST_N)
    begin
        if (RST_N = '0') then
            s_o_count <= (others => '1');
        elsif rising_edge(CLK) then
            if (I_LOAD = '1') then
                s_o_count <= I_D;
            else
                if (s_o_count = 0) then
                    s_o_count <= (others => '1');
                else
                    s_o_count <= s_o_count - 1;
                end if;
            end if;
        end if;
    end process;

    O_COUNT <= s_o_count;

end RTL;