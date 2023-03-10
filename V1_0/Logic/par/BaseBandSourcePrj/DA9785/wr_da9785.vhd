library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;

entity wr_da9785 is
	port(
			clk		           			: in std_logic; 
			wren		           			: in std_logic;   
			da_reset	           			: out std_logic;    
			da_sdio,da_sclk,da_le		: out std_logic  	
		
		);
	end wr_da9785;

architecture Behavioral of wr_da9785 is
	signal cnt 								:std_logic_vector(15 downto 0):=x"0000" ;	
	signal sdio0,sclk0,sdo0				:std_logic:='0' ;
	signal csb0								:std_logic:='1' ;
	signal da_data							:std_logic_vector(31 downto 0):=x"046FAB13";--x"046FAB1F";--x"046FD3EB";--x"046fb35f";--da_clk==80m,(1280m,2*8)
	signal da_data1						:std_logic_vector(39 downto 0):=x"0a23D70A3D";--x"0a25555555";--x"0a03333333";--da_clk==80m,(640m,00m)
	signal da_data2						:std_logic_vector(23 downto 0):=x"0131C0";
begin  	
	da_sdio<=sdio0;
	da_sclk<=sclk0;
	da_le<=csb0;
	process	
	begin  				
   	wait until clk'event and clk='1';
			if wren='1' then
				cnt<=x"0004";
				da_data<=x"046FAB13";--x"046FAB1F";--x"046FD3EB";--x"046fb35f";
				da_data1<=x"0a23D70A3D";--x"0a25555555";--x"0a03333333";
				da_data2<=x"0131C0";
				
			end if;
			if cnt>=x"0000" and cnt<x"0008" then
				cnt<=cnt+'1';
				da_reset<='0';
			elsif cnt>=x"0008" and cnt<x"0088" then
				cnt<=cnt+'1';
				da_reset<='1';
			elsif cnt>=x"0088" and cnt<x"0100" then
				cnt<=cnt+'1';
				da_reset<='0';
			elsif cnt>=x"0100" and cnt<x"8000" then
				cnt<=cnt+'1';
			end if;
			case cnt is 
				when x"0108" =>	csb0<='1';
				when x"0110" =>	csb0<='0';
				
				when x"0118" =>	sdio0<=da_data(31);--'0';--7
										sclk0<='0';
				when x"0120" =>	sclk0<='1';
				when x"0128" =>	sdio0<=da_data(30);--'0';--6
										sclk0<='0';
				when x"0130" =>	sclk0<='1';
				when x"0138" =>	sdio0<=da_data(29);--'0';--5
										sclk0<='0';
				when x"0140" =>	sclk0<='1';
				when x"0148" =>	sdio0<=da_data(28);--'0';--4
										sclk0<='0';
				when x"0150" =>	sclk0<='1';
				when x"0158" =>	sdio0<=da_data(27);--'1';--3
										sclk0<='0';
				when x"0160" =>	sclk0<='1';
				when x"0168" =>	sdio0<=da_data(26);--'0';--2
										sclk0<='0';
				when x"0170" =>	sclk0<='1';
				when x"0178" =>	sdio0<=da_data(25);--'1';--1
										sclk0<='0';
				when x"0180" =>	sclk0<='1';
				when x"0188" =>	sdio0<=da_data(24);--'0';--0
										sclk0<='0';
				when x"0190" =>	sclk0<='1';
				
				when x"0198" =>	sdio0<=da_data(23);
										sclk0<='0';
				when x"01a0" =>	sclk0<='1';
				when x"01a8" =>	sdio0<=da_data(22);
										sclk0<='0';
				when x"01b0" =>	sclk0<='1';
				when x"01b8" =>	sdio0<=da_data(21);
										sclk0<='0';
				when x"01c0" =>	sclk0<='1';
				when x"01c8" =>	sdio0<=da_data(20);
										sclk0<='0';
				when x"01d0" =>	sclk0<='1';
				when x"01d8" =>	sdio0<=da_data(19);
										sclk0<='0';
				when x"01e0" =>	sclk0<='1';
				when x"01e8" =>	sdio0<=da_data(18);
										sclk0<='0';
				when x"01f0" =>	sclk0<='1';
				when x"01f8" =>	sdio0<=da_data(17);
										sclk0<='0';
				when x"0200" =>	sclk0<='1';
				when x"0208" =>	sdio0<=da_data(16);
										sclk0<='0';
				when x"0210" =>	sclk0<='1';
				when x"0218" =>	sdio0<=da_data(15);
										sclk0<='0';
				when x"0220" =>	sclk0<='1';
				when x"0228" =>	sdio0<=da_data(14);
										sclk0<='0';
				when x"0230" =>	sclk0<='1';
				when x"0238" =>	sdio0<=da_data(13);
										sclk0<='0';
				when x"0240" =>	sclk0<='1';
				when x"0248" =>	sdio0<=da_data(12);
										sclk0<='0';
				when x"0250" =>	sclk0<='1';
				when x"0258" =>	sdio0<=da_data(11);
										sclk0<='0';
				when x"0260" =>	sclk0<='1';
				when x"0268" =>	sdio0<=da_data(10);
										sclk0<='0';
				when x"0270" =>	sclk0<='1';
				when x"0278" =>	sdio0<=da_data(9);
										sclk0<='0';
				when x"0280" =>	sclk0<='1';
				when x"0288" =>	sdio0<=da_data(8);
										sclk0<='0';
				when x"0290" =>	sclk0<='1';
				when x"0298" =>	sdio0<=da_data(7);
										sclk0<='0';
				when x"02a0" =>	sclk0<='1';
				when x"02a8" =>	sdio0<=da_data(6);
										sclk0<='0';
				when x"02b0" =>	sclk0<='1';
				when x"02b8" =>	sdio0<=da_data(5);
										sclk0<='0';
				when x"02c0" =>	sclk0<='1';
				when x"02c8" =>	sdio0<=da_data(4);
										sclk0<='0';
				when x"02d0" =>	sclk0<='1';
				when x"02d8" =>	sdio0<=da_data(3);
										sclk0<='0';
				when x"02e0" =>	sclk0<='1';
				when x"02e8" =>	sdio0<=da_data(2);
										sclk0<='0';
				when x"02f0" =>	sclk0<='1';
				when x"02f8" =>	sdio0<=da_data(1);
										sclk0<='0';
				when x"0300" =>	sclk0<='1';
				when x"0308" =>	sdio0<=da_data(0);
										sclk0<='0';
				when x"0310" =>	sclk0<='1';
									
				when x"0318" =>	sclk0<='0';
				when x"0320" =>	csb0<='1';	
				
-----------------------------------------------------------------				
				
				when x"1008" =>	csb0<='1';
				when x"1010" =>	csb0<='0';
				
				when x"1018" =>	sdio0<=da_data1(39);--'0';--7
										sclk0<='0';
				when x"1020" =>	sclk0<='1';
				when x"1028" =>	sdio0<=da_data1(38);--'0';--6
										sclk0<='0';
				when x"1030" =>	sclk0<='1';
				when x"1038" =>	sdio0<=da_data1(37);--'0';--5
										sclk0<='0';
				when x"1040" =>	sclk0<='1';
				when x"1048" =>	sdio0<=da_data1(36);--'0';--4
										sclk0<='0';
				when x"1050" =>	sclk0<='1';
				when x"1058" =>	sdio0<=da_data1(35);--'1';--3
										sclk0<='0';
				when x"1060" =>	sclk0<='1';
				when x"1068" =>	sdio0<=da_data1(34);--'0';--2
										sclk0<='0';
				when x"1070" =>	sclk0<='1';
				when x"1078" =>	sdio0<=da_data1(33);--'1';--1
										sclk0<='0';
				when x"1080" =>	sclk0<='1';
				when x"1088" =>	sdio0<=da_data1(32);--'0';--0
										sclk0<='0';
				when x"1090" =>	sclk0<='1';				
				when x"1098" =>	sdio0<=da_data1(31);
										sclk0<='0';
				when x"10a0" =>	sclk0<='1';
				when x"10a8" =>	sdio0<=da_data1(30);
										sclk0<='0';
				when x"10b0" =>	sclk0<='1';
				when x"10b8" =>	sdio0<=da_data1(29);
										sclk0<='0';
				when x"10c0" =>	sclk0<='1';
				when x"10c8" =>	sdio0<=da_data1(28);
										sclk0<='0';
				when x"10d0" =>	sclk0<='1';
				when x"10d8" =>	sdio0<=da_data1(27);
										sclk0<='0';
				when x"10e0" =>	sclk0<='1';
				when x"10e8" =>	sdio0<=da_data1(26);
										sclk0<='0';
				when x"10f0" =>	sclk0<='1';
				when x"10f8" =>	sdio0<=da_data1(25);
										sclk0<='0';
				when x"1100" =>	sclk0<='1';
				when x"1108" =>	sdio0<=da_data1(24);
										sclk0<='0';
				when x"1110" =>	sclk0<='1';
				when x"1118" =>	sdio0<=da_data1(23);
										sclk0<='0';
				when x"1120" =>	sclk0<='1';
				when x"1128" =>	sdio0<=da_data1(22);
										sclk0<='0';
				when x"1130" =>	sclk0<='1';
				when x"1138" =>	sdio0<=da_data1(21);
										sclk0<='0';
				when x"1140" =>	sclk0<='1';
				when x"1148" =>	sdio0<=da_data1(20);
										sclk0<='0';
				when x"1150" =>	sclk0<='1';
				when x"1158" =>	sdio0<=da_data1(19);
										sclk0<='0';
				when x"1160" =>	sclk0<='1';
				when x"1168" =>	sdio0<=da_data1(18);
										sclk0<='0';
				when x"1170" =>	sclk0<='1';
				when x"1178" =>	sdio0<=da_data1(17);
										sclk0<='0';
				when x"1180" =>	sclk0<='1';
				when x"1188" =>	sdio0<=da_data1(16);
										sclk0<='0';
				when x"1190" =>	sclk0<='1';
				when x"1198" =>	sdio0<=da_data1(15);
										sclk0<='0';
				when x"11a0" =>	sclk0<='1';
				when x"11a8" =>	sdio0<=da_data1(14);
										sclk0<='0';
				when x"11b0" =>	sclk0<='1';
				when x"11b8" =>	sdio0<=da_data1(13);
										sclk0<='0';
				when x"11c0" =>	sclk0<='1';
				when x"11c8" =>	sdio0<=da_data1(12);
										sclk0<='0';
				when x"11d0" =>	sclk0<='1';
				when x"11d8" =>	sdio0<=da_data1(11);
										sclk0<='0';
				when x"11e0" =>	sclk0<='1';
				when x"11e8" =>	sdio0<=da_data1(10);
										sclk0<='0';
				when x"11f0" =>	sclk0<='1';
				when x"11f8" =>	sdio0<=da_data1(9);
										sclk0<='0';
				when x"1200" =>	sclk0<='1';
				when x"1208" =>	sdio0<=da_data1(8);
										sclk0<='0';
				when x"1210" =>	sclk0<='1';	
				when x"1218" =>	sdio0<=da_data1(7);
										sclk0<='0';
				when x"1220" =>	sclk0<='1';
				when x"1228" =>	sdio0<=da_data1(6);
										sclk0<='0';
				when x"1230" =>	sclk0<='1';
				when x"1238" =>	sdio0<=da_data1(5);
										sclk0<='0';
				when x"1240" =>	sclk0<='1';
				when x"1248" =>	sdio0<=da_data1(4);
										sclk0<='0';
				when x"1250" =>	sclk0<='1';
				when x"1258" =>	sdio0<=da_data1(3);
										sclk0<='0';
				when x"1260" =>	sclk0<='1';
				when x"1268" =>	sdio0<=da_data1(2);
										sclk0<='0';
				when x"1270" =>	sclk0<='1';
				when x"1278" =>	sdio0<=da_data1(1);
										sclk0<='0';
				when x"1280" =>	sclk0<='1';
				when x"1288" =>	sdio0<=da_data1(0);
										sclk0<='0';
				when x"1290" =>	sclk0<='1';
							
				when x"1298" =>	sclk0<='0';
				when x"12a0" =>	csb0<='1';

-----------------------------------------------------------------				
				
				when x"1608" =>	csb0<='1';
				when x"1610" =>	csb0<='0';
				
				when x"1618" =>	sdio0<=da_data2(23);--'0';--7
										sclk0<='0';     
				when x"1620" =>	sclk0<='1';     
				when x"1628" =>	sdio0<=da_data2(22);--'0';--6
										sclk0<='0';     
				when x"1630" =>	sclk0<='1';     
				when x"1638" =>	sdio0<=da_data2(21);--'0';--5
										sclk0<='0';     
				when x"1640" =>	sclk0<='1';     
				when x"1648" =>	sdio0<=da_data2(20);--'0';--4
										sclk0<='0';     
				when x"1650" =>	sclk0<='1';     
				when x"1658" =>	sdio0<=da_data2(19);--'1';--3
										sclk0<='0';     
				when x"1660" =>	sclk0<='1';     
				when x"1668" =>	sdio0<=da_data2(18);--'0';--2
										sclk0<='0';     
				when x"1670" =>	sclk0<='1';     
				when x"1678" =>	sdio0<=da_data2(17);--'1';--1
										sclk0<='0';     
				when x"1680" =>	sclk0<='1';     	
				when x"1688" =>	sdio0<=da_data2(16);--'0';--0
										sclk0<='0';     
				when x"1690" =>	sclk0<='1';		 
				when x"1698" =>	sdio0<=da_data2(15);
										sclk0<='0';     
				when x"16a0" =>	sclk0<='1';     
				when x"16a8" =>	sdio0<=da_data2(14);
										sclk0<='0';     
				when x"16b0" =>	sclk0<='1';     
				when x"16b8" =>	sdio0<=da_data2(13);
										sclk0<='0';     
				when x"16c0" =>	sclk0<='1';     
				when x"16c8" =>	sdio0<=da_data2(12);
										sclk0<='0';     
				when x"16d0" =>	sclk0<='1';     
				when x"16d8" =>	sdio0<=da_data2(11);
										sclk0<='0';     
				when x"16e0" =>	sclk0<='1';     
				when x"16e8" =>	sdio0<=da_data2(10);
										sclk0<='0';     
				when x"16f0" =>	sclk0<='1';     
				when x"16f8" =>	sdio0<=da_data2(9);
										sclk0<='0';     
				when x"1700" =>	sclk0<='1';     
				when x"1708" =>	sdio0<=da_data2(8);
										sclk0<='0';     
				when x"1710" =>	sclk0<='1';     
				when x"1718" =>	sdio0<=da_data2(7);
										sclk0<='0';     
				when x"1720" =>	sclk0<='1';     
				when x"1728" =>	sdio0<=da_data2(6);
										sclk0<='0';     
				when x"1730" =>	sclk0<='1';     
				when x"1738" =>	sdio0<=da_data2(5);
										sclk0<='0';     
				when x"1740" =>	sclk0<='1';     
				when x"1748" =>	sdio0<=da_data2(4);
										sclk0<='0';     
				when x"1750" =>	sclk0<='1';     
				when x"1758" =>	sdio0<=da_data2(3);
										sclk0<='0';     
				when x"1760" =>	sclk0<='1';     
				when x"1768" =>	sdio0<=da_data2(2);
										sclk0<='0';     
				when x"1770" =>	sclk0<='1';     
				when x"1778" =>	sdio0<=da_data2(1);
										sclk0<='0';     
				when x"1780" =>	sclk0<='1';     
				when x"1788" =>	sdio0<=da_data2(0);
										sclk0<='0';     
				when x"1790" =>	sclk0<='1';     
				
				when x"1798" =>	sclk0<='0';
				when x"17a0" =>	csb0<='1';	
				
					when others 	  => 
			end case;		
	end process ;
end Behavioral;
