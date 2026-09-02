library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SHIFT_REGISTER_8BIT is
    port (
        CLK           : in  std_logic;
        RST_N         : in  std_logic;
        I_SHIFT_LEFT  : in  std_logic;
        I_SHIFT_RIGHT : in  std_logic;
        I_LOAD        : in  std_logic;
        I_D           : in  std_logic_vector(7 downto 0);
        O_Q           : out std_logic_vector(7 downto 0)
    );
end entity SHIFT_REGISTER_8BIT;

architecture RTL of SHIFT_REGISTER_8BIT is
    
    signal s_o_q : std_logic_vector(7 downto 0) := (others => '0');

begin

    process(CLK, RST_N)
    begin
        if (RST_N = '0') then
            s_o_q <= (others => '0');
        elsif rising_edge(CLK) then
            if (I_LOAD = '1') then
                s_o_q <= I_D;
            else
                if(I_SHIFT_LEFT = '1' and I_SHIFT_RIGHT = '0') then
                    s_o_q <= s_o_q(6 downto 0) & '0';
                elsif (I_SHIFT_LEFT = '0' and I_SHIFT_RIGHT = '1') then
                    s_o_q <= '0' & s_o_q(7 downto 1);
                end if;
            end if;
        end if;
    end process;

    O_Q <= s_o_q;

end architecture RTL;
