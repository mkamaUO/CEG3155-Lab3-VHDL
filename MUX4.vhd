--------------------------------------------------------------------------------
-- Title         : MUX4
-- Project       : CEG3155 Laboratory 3
-------------------------------------------------------------------------------
-- File          : MUX4.vhd
-- Student        : Moghesh Kamalaraj and Akash Karunaharan
-- Created       : 2025/10/29
-- Last modified : 2025/11/09
-------------------------------------------------------------------------------
-- Description : This file creates a 4x1 multiplexer. The architecture is done 
-- at the RTL abstraction level and the implementation is done in structural VHDL.
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity MUX4 is
    port (
        I3, I2, I1, I0: in std_logic_vector(3 downto 0);
        O: out std_logic_vector(3 downto 0);
        C: in std_logic_vector(1 downto 0)
    );
end;

architecture Structural of MUX4 is

    signal sel: std_logic_vector(3 downto 0); -- Decoder outputs

begin

    -- Decoder logic to determine which input to select
    sel(0) <= not C(1) and not C(0);  -- C = "00"
    sel(1) <= not C(1) and C(0);      -- C = "01"
    sel(2) <= C(1) and not C(0);      -- C = "10"
    sel(3) <= C(1) and C(0);          -- C = "11"
    
    -- MUX output logic for each bit of the output vector
    gen_mux: for i in 0 to 3 generate
        O(i) <= (I0(i) and sel(0)) or 
                 (I1(i) and sel(1)) or 
                 (I2(i) and sel(2)) or 
                 (I3(i) and sel(3));
    end generate;

end Structural;