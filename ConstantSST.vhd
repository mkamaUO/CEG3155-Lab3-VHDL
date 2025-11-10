--------------------------------------------------------------------------------
-- Title         : ConstantSST
-- Project       : CEG3155 Laboratory 3
-------------------------------------------------------------------------------
-- File          : ConstantSST.vhd
-- Student       : Moghesh Kamalaraj and Akash Karunaharan
-- Created       : 2025/10/29
-- Last modified : 2025/11/09
-------------------------------------------------------------------------------
-- Description : This file is used to store the defined SST value, 3 in this case.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ConstantSST is
    port (
        SST: out std_logic_vector(3 downto 0)
    );
end;

architecture Structural of ConstantSST is
begin
    SST <= "0011";
end;
