library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DEBOUNCE_SWITCH is
    port (
        CLK         : in  std_logic;
        RST_N       : in  std_logic;
        I_SW        : in  std_logic;
        O_DEBOUNCED : out std_logic
    );
end entity DEBOUNCE_SWITCH;

architecture RTL of DEBOUNCE_SWITCH is
    signal s_sw_buf : std_logic_vector(3 downto 0) := (others => '0');
    signal s_o_debounced : std_logic := '0';
begin

    process(CLK, RST_N)
    begin
        if (RST_N = '0') then
            s_sw_buf <= (others => '0');
            s_o_debounced <= '0';
        elsif rising_edge(CLK) then
            s_sw_buf <= s_sw_buf(2 downto 0) & I_SW;
            
            if (s_sw_buf = "1111") then
                s_o_debounced <= '1';
            elsif (s_sw_buf = "0000") then
                s_o_debounced <= '0';
            end if;
        end if;
    end process;

    O_DEBOUNCED <= s_o_debounced;        

end architecture RTL;
