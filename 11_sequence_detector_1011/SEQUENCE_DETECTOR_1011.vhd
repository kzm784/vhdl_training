library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SEQUENCE_DETECTOR_1011 is
    port (
        CLK      : in  std_logic;
        RST_N    : in  std_logic;
        I_ENABLE : in  std_logic;
        I_DATA   : in  std_logic;
        O_DETECT : out std_logic
    );
end entity SEQUENCE_DETECTOR_1011;

architecture RTL of SEQUENCE_DETECTOR_1011 is
    type t_state is (
        ST_IDLE,
        ST_1,
        ST_10,
        ST_101,
        ST_DETECT
    );

    signal s_current_state : t_state := ST_IDLE;
    signal s_next_state    : t_state := ST_IDLE;

    signal s_o_detect      : std_logic := '0';

begin

    process(CLK, RST_N) begin
        if (RST_N = '0') then
            s_current_state <= ST_IDLE;
        elsif rising_edge(CLK) then
            s_current_state <= s_next_state;
        end if;
    end process;


    process(s_current_state, I_ENABLE, I_DATA) begin
        s_next_state <= s_current_state;
        
        if (I_ENABLE = '1') then
            case s_current_state is
                when ST_IDLE =>
                    if (I_DATA = '1') then
                        s_next_state <= ST_1;
                    end if;

                when ST_1 =>
                    if (I_DATA = '1') then
                        s_next_state <= ST_1;
                    else
                        s_next_state <= ST_10;
                    end if;
                    
                when ST_10 =>
                    if (I_DATA = '1') then
                        s_next_state <= ST_101;
                    else
                        s_next_state <= ST_IDLE;
                    end if;

                when ST_101 =>
                    if (I_DATA = '1') then
                        s_next_state <= ST_DETECT;
                    else
                        s_next_state <= ST_10;
                    end if;

                when ST_DETECT =>
                    if (I_DATA = '1') then
                        s_next_state <= ST_1;
                    else
                        s_next_state <= ST_10;
                    end if;
            end case;
        else
            if (s_current_state = ST_DETECT) then
                s_next_state <= ST_1;
            else
                s_next_state <= s_current_state;
            end if;
        end if;
    end process;


    process(s_current_state) begin
        s_o_detect <= '0';

        if (s_current_state = ST_DETECT) then
            s_o_detect <= '1';
        else
            s_o_detect <= '0';
        end if;
    end process;

    O_DETECT <= s_o_detect;

end architecture RTL;
