### 1. SRAM cell P/N ratio
#### 1) Simulation waveform
- Case 1
	- Read
		![[SRAM_CELL_1_READ.png]]
	- Write
		![[SRAM_CELL_1_WRITE.png]]
- Case 2
	- Read
		![[SRAM_CELL_2_READ.png]]
	- Write
		![[SRAM_CELL_2_WRITE.png]]
- Case 3
	- Read
		![[SRAM_CELL_3_READ.png]]
	- Write
		![[SRAM_CELL_3_WRITE.png]]
#### 2) Operation table

| TT, VDD = 1.2V    | Success of Failure |         |         |
| ----------------- | ------------------ | ------- | ------- |
| 25 ºC, L = 0.13 u | Case 1             | Case 2  | Case 3  |
| Read operation    | Failure            | Success | Success |
| Write operation   | Success            | Failure | Success |
#### 3) Analysis

### 2. Memory operation

#### Stimuli

- Mission 1
- Mission 2
- Mission 3
- Mission 4
#### Simulation Waveform

- Mission 1
	![[SRAM_WRITE_MISSION_1.png]]
- Mission 2
	![[SRAM_WRITE_MISSION_2.png]]
- Mission 3
	![[SRAM_READ_MISSION_3.png]]
- Mission 4
	![[SRAM_READ_MISSION_4.png]]
#### 3) Analysis

### 3. Screenshots

- Schematics
	- Case 1
		![[SRAM_CELL_1_schematic.png]]
	- Case 2
		![[SRAM_CELL_2_schematic.png]]
	- Case 3
		![[SRAM_CELL_3_schematic.png]]
	- Case 3 without capacitor
		![[SRAM_CELL_3_wo_cap_schematic.png]]
	- Write mission
		![[SRAM_WRITE.png]]
	- Read mission
		![[SRAM_READ.png]]
- Symbols
	- Case 3
		![[SRAM_CELL_3_symbol.png]]
	- Case 3 without capacitor
		![[SRAM_CELL_3_wo_cap_symbol.png]]
- Library manager
	![[Libman.png]]
	