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

Case 1
* Read Operation (Fail): $W_{nG}$($2.0\mu m$)가 $W_{nD}$($0.2\mu m$)보다 훨씬 크기다. WL이 활성화되었을 때, $Q, \overline Q$ 노드가 Voltage Divider의 가운데 노드 되었지만, $W_{nD}$의 R이 훨씬 크므로,  $Q, \overline Q$ 전압이 모두 $V_{th}$ 이상으로 유지되었고, $BL, \overline {BL}$  모두 감소하여, 동작은 실패하였다.
* Write Operation (Success): $W_{nG}$($2.0\mu m$)가 $W_{p}$($1.6\mu m$)보다 크기 때문에, Access Transistor가 Pull-up Transistor를 이겨 $Q, \overline Q$를 덮어 쓸 수 있었다. 따라서 쓰기 동작은 성공적이다.

Case 2
* Read Operation (Success): $W_{nD}$($2.0\mu m$)가 $W_{nG}$($0.2\mu m$)보다 충분히 크기 때문에, Read 시 Node $Q, \overline Q$의 전압을 안정적으로 유지하였다.
* Write Operation (Fail): $W_{nG}$($0.2\mu m$)가 $W_{p}$($1.6\mu m$)보다 매우 작아, Access Transistor의 구동력이 Pull-up Transistor보다 약하다. 이로 인해 $Q, \overline Q$를 뒤집지 못하여 쓰기 동작은 실패하였다.

Case 3
* Read & Write (Success): $W_{nD}(2.0) > W_{nG}(1.6) > W_{p}(0.2)$의 크기 조건을 만족한다.
    * Read Stability: $W_{nD} > W_{nG}$ 조건을 통해 $Q, \overline Q$ 노드의 전압을 유지할 수 있었다.
    * Write Ability: $W_{nG} > W_{p}$ 조건을 통해 Access Transistor가 Pull-up을 이기고 값을 덮어쓸 수 있도록 하였다.

Conclusion
SRAM Cell이 정상 동작하기 위해서는 Read Stability와 Write Ability 사이의 Trade-off를 고려해야 한다. Read 시 데이터 파괴를 막기 위해 $W_{nD}$를 키워야 하고, Write 시 값을 쉽게 바꾸기 위해 $W_{p}$를 줄여야 한. 따라서 $W_{nD} > W_{nG} > W_{p}$ 의 사이징 조건이 만족되어야 신뢰성 있는 동작이 가능하다.
### 2. Memory operation

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

| Instance Name | Col 0 | Col 1 |
| ------------- | ----- | ----- |
| Row 0         | I0    | I1    |
| Row 1         | I2    | I3    |
Stimulus Setup
Write 동작 시에는 Target Bitline(BL, BLB)에 쓰고자 하는 데이터를 DC로 인가하고, 해당 Row의 WL에 Rise/Fall time 0.1ns의 EN(1.8V)을 5ns 동안 인가하였다. Read 동작 시에는 모든 BL/BLB를 Floating 상태로 두고 PCH 신호를 이용하여 5ns 동안 $V_{DD}$로 Precharge한 뒤, WL을 활성화하여 전압 변화를 관찰하였다.

Write Operation (Mission 1 & 2)
* Mission 1 (Row 0 Write): BL<0>='1', BL<1>='0'을 인가하고 WL<0>를 활성화하였다. 시뮬레이션 결과, Row 0의 Cell(I0, I1)에 각각 '1', '0'이 정확히 저장됨을 확인하였다. 이때 WL<1>은 비활성 상태이므로 Row 1의 데이터는 영향을 받지 않았다.
* Mission 2 (Row 1 Write): BL<0>='0', BL<1>='1'을 인가하고 WL<1>을 활성화하였다. Row 1의 Cell(I2, I3)의 값이 각각 '0', '1'로 변하는 것을 확인하였으며, 이는 Row 단위의 쓰기 동작이 정상적으로 수행됨을 의미한다.

Read Operation (Mission 3 & 4)
* Precharge Phase: WL 인가 전, PCH 신호를 Low로 하여 BL과 BLB를 모두 $V_{DD}$로 Precharge 하였다.
* Evaluation Phase (Mission 3): WL<0>가 활성화되자, '0'이 저장된 노드와 연결된 Bitline(예: BLB<0>, BL<1>)의 전압이 SRAM 셀에 의해 방전되어 감소하였다. 반면 '1'이 저장된 쪽은 $V_{DD}$를 유지하였다. 이 전압 차이를 통해 Row 0에 저장된 데이터('1', '0')를 판별할 수 있었다.
* Evaluation Phase (Mission 4): 동일한 원리로 WL<1> 활성화 시 Row 1의 데이터에 따라 Bitline 전압 차이가 발생하여 저장된 값('0', '1')을 읽어낼 수 있었다.

Conclusion & Design Consideration
시뮬레이션 결과 SRAM Array의 Read/Write 동작이 Row 단위로 동시에 일어남을 확인하였다. 실제 메모리 구조에서는 미세한 Bitline 전압 차이를 빠르게 증폭하기 위해 Sense Amplifier(SA)가 필수적이다. 또한, 특정 Column에만 선택적으로 쓰기(Write)를 수행하거나 읽기(Read)를 수행하기 위해서는 Column Decoder 및 Write Driver, Mux와 같은 주변 회로가 추가적으로 필요함을 알 수 있다.
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
	