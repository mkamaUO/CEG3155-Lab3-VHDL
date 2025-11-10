--------------------------------------------------------------------------------
-- Title         : Counter16
-- Project       : CEG3155 Laboratory 3
-------------------------------------------------------------------------------
-- File          : Counter16.vhd
-- Student       : Moghesh Kamalaraj and Akash Karunaharan
-- Created       : 2025/10/29
-- Last modified : 2025/11/09
-------------------------------------------------------------------------------
-- Description : This file creates a 16-bit counter with load functionality. 
-- The counter decrements its loaded value until it reaches 0, at which point
-- it will output a counter expired value. The architecture is done at the RTL 
-- abstraction level and the implementation is done in structural VHDL.
-------------------------------------------------------------------------------

library ieee;
library altera;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use altera.altera_primitives_components.all;

entity Counter16 is
    port (
        CLK, RESETN: in std_logic; -- Clock and reset signals
        LOAD: in std_logic; -- Load signal to load a new value into the counter, controlled by SetCounter
        INPUT: in std_logic_vector(3 downto 0); -- 4-bit input value from the MUX
        EXPIRE: out std_logic; -- Expire signal indicating when the counter expires
        VALUE: out std_logic_vector(3 downto 0) -- 4-bit output value of the counter
    );
end;

architecture Structural of Counter16 is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    
    signal signalNext: std_logic_vector(3 downto 0); -- internal signal vectors for the next state
    signal signalD, signalQ: std_logic_vector(3 downto 0); -- internal signal vectors for the D Flip-Flops
	 
begin
	 -- Calculates the next state of the counter
    signalNext(3) <= signalQ(3) and (signalQ(2) or signalQ(1) or signalQ(0) or LOAD);
    signalNext(2) <= (signalQ(2) and (signalQ(1) or signalQ(0) or LOAD))
                    or (signalQ(3) and not signalQ(2) and not signalQ(1) and not signalQ(0) and not(LOAD));
    signalNext(1) <= (signalQ(1) and (signalQ(0) or LOAD))
                    or (not signalQ(1) and not signalQ(0) and not(LOAD) and (signalQ(3) or signalQ(2)));
    signalNext(0) <= (signalQ(0) and LOAD)
                    or (not signalQ(0) and not(LOAD) and (signalQ(3) or signalQ(2) or signalQ(1)));
    
	 -- Generates the D input for the D Flip-Flops
	 generateSignalD: for i in 3 downto 0 generate
		signalD(i) <= (signalNext(i) and not(LOAD)) or (INPUT(i) and (LOAD));
	 end generate;
	 
    -- Generate D Flip-Flops for each bit
    generateDFF: for i in 3 downto 0 generate
        dffInst: enARdFF_2
            port map (
                i_resetBar => '1', -- Asynchronous reset is not used so that the counter
											  -- value always starts from MSC instead of 0
                i_d => signalD(i),
                i_enable => '1',
                i_clock => CLK,
                o_q => signalQ(i)
            );
    end generate;
    
	 -- Output the expire signal when all bits of signalQ are 0
    EXPIRE <= not or_reduce(signalQ); 
	 
	 -- Output the current value of the counter
    VALUE <= signalQ;
end;
