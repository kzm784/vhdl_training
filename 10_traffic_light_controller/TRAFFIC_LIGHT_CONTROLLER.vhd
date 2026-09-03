library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRAFFIC_LIGHT_CONTROLLER is
    port (
        CLK       : in  std_logic;
        RST_N     : in  std_logic;
        I_ENABLE  : in  std_logic;
        O_RED     : out std_logic;
        O_YELLOW  : out std_logic;
        O_GREEN   : out std_logic
    );
end entity TRAFFIC_LIGHT_CONTROLLER;

architecture RTL of TRAFFIC_LIGHT_CONTROLLER is
    type t_state is (
        ST_RED,
        ST_YELLOW,
        ST_GREEN
    );

    signal s_current_state : t_state := ST_RED;
    signal s_next_state    : t_state := ST_RED;

    signal s_o_red    : std_logic := '0';
    signal s_o_yellow : std_logic := '0';
    signal s_o_green  : std_logic := '0';
begin

    -- 状態レジスタ（フリップフロップ回路）
    process(CLK, RST_N) begin
        if (RST_N = '0') then
            s_current_state <= ST_GREEN;
        elsif rising_edge(CLK) then
            s_current_state <= s_next_state;
        end if;
    end process;


    -- 次状態論理（組み合わせ回路）
    process(s_current_state, I_ENABLE) begin
        s_next_state <= s_current_state;

        case s_current_state is
            when ST_RED =>
                if (I_ENABLE = '1') then
                    s_next_state <= ST_GREEN;
                end if;
            
            when ST_YELLOW =>
                if (I_ENABLE = '1') then
                    s_next_state <= ST_RED;
                end if;
            
            when ST_GREEN => 
                if (I_ENABLE = '1') then
                    s_next_state <= ST_YELLOW;
                end if;
            
            when others =>
                s_next_state <= ST_RED;
        end case;
    end process;


    -- 出力論理
    process(s_current_state) begin
        s_o_red    <= '0';
        s_o_yellow <= '0';
        s_o_green  <= '0';

        case s_current_state is
            when ST_RED    => s_o_red    <= '1';
            when ST_YELLOW => s_o_yellow <= '1';
            when ST_GREEN  => s_o_green  <= '1';
            when others    => s_o_red    <= '1'; 
                              s_o_yellow <= '0'; 
                              s_o_green  <= '0';
        end case;
    end process;

    O_RED     <= s_o_red;
    O_YELLOW  <= s_o_yellow;
    O_GREEN   <= s_o_green;

end architecture RTL;
