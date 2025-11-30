### 1. CNV based vs. Passgate based MUX
#### 1) Design for MUX

- CNV based
	- Schematic
		![[MUX_CNV_schematic.png]]
	- Layout
		![[MUX_CNV_layout.png]]
- Passgate based
	- Schematic
		![[MUX_PG_schematic.png]]
	- Layout
		![[MUX_PG_layout.png]]
#### 2) Propagation delay table
- Simulation waveform
	- CNV based
		- Pre layout
			- 0 to 1
				![[MUX_CNV_t_out_0to1_pre_layout.png]]
			- 1 to 0
				![[MUX_CNV_t_out_1to0_pre_layout.png]]
		- Post layout
			- 0 to 1
				![[MUX_CNV_t_out_0to1_post_layout.png]]
			- 1 to 0
				![[MUX_CNV_t_out_1to0_pre_layout.png]]
	- Passgate based
		- Pre layout
			- 0 to 1
				![[MUX_PG_t_out_0to1_pre_layout.png]]
			- 1 to 0
				![[MUX_PG_t_out_1to0_pre_layout.png]]
		- Post layout
			- 0 to 1
				![[MUX_PG_t_out_0to1_post_layout.png]]
			- 1 to 0
				![[MUX_PG_t_out_1to0_post_layout.png]]
- Propagation delay table

| TT, VDD = 1.2 V                          | Propagation delay [ps] |                    |
| ---------------------------------------- | :--------------------: | :----------------: |
| 25 °C, L = 0.13 um                       |     CNV based MUX      | Passgate based MUX |
| $t_{out(0 \rightarrow 1)}$ (Pre-layout)  |        84.7832         |       104.58       |
| $t_{out(1 \rightarrow 0)}$ (Post-layout) |         88.257         |      119.807       |
| $t_{out(0 \rightarrow 1)}$ (Pre-layout)  |         102.86         |       106.77       |
| $t_{out(0 \rightarrow 1)}$ (Post-layout) |         107.86         |      121.743       |

#### 3) Truth table

| CNV based MUX | {S1, S0} |        |        |        |
| :-----------: | :------: | :----: | :----: | :----: |
|               |  {0, 0}  | {0, 1} | {1, 0} | {1, 1} |
|      OUT      |    A     |   B    |   C    |   D    |

| Passgate based MUX | {S1, S0} |        |        |        |
| :----------------: | :------: | :----: | :----: | :----: |
|                    |  {0, 0}  | {0, 1} | {1, 0} | {1, 1} |
|        OUT         |    A     |   B    |   C    |   D    |

#### 4) Analysis

본 실험에서는 A, B, C, D를 각각 High, Low, High, Low로 설정하였습니다. 이에 따라 Propagation delay는 $t_{pLH​}$의 경우, 출력이 B(Low)에서 C(High)로 전이하는 과정($\{S1,S0\}: \{0,1\} → \{1,0\}$)을 통해 측정되었습니다. $t_{pHL}$​는 출력이 C(High)에서 D(Low)로 전이하는 과정($\{S1,S0\}: \{1,0\} → \{1,1\}$)을 통해 측정되었습니다.

측정된 결과에서 두 MUX는 Pre-layout propagation delay의 균형과 Post-layout 성능 저하 측면에서 명확한 차이를 보였습니다.

- Pre-layout
	Pre-layout 시뮬레이션에서 CNV MUX는 $t_{p}$가 불균형적이었으나 Passgate MUX는 매우 균형적인 특성을 보였습니다.
	- Passgate 스위치는 PMOS와 NMOS가 병렬로 연결된 구조입니다. 이 구조는 $V_{in}$이 High일 때는 PMOS가, Low일 때는 NMOS가 주로 동작하며 상호 보완하여, $R_{eq​}$가 큰 차이 없이 유지됩니다. 따라서 $t_{pLH}$와 $t_{pHL}$이 거의 동일한 균형적인 특성을 보입니다.
	- CNV MUX는 2-to-1 MUX 3개를 트리 구조로 구현하였으며, 각 2-to-1 MUX는 PMOS 2개 스택(PUN)과 NMOS 2개 스택(PDN)으로 구성된 인버터 2개로 구현됩니다. 이러한 스택 구조에서는 VDD/VSS에 직접 연결되지 않은 내부 트랜지스터에서 Body Effect가 발생하여 $V_{th}​$가 증가하고, 결과적으로 저항이 커집니다. 일반적으로 공정상 NMOS의 $\gamma$가 PMOS보다 크기 때문에, PDN이 PUN보다 body effect로 인한 성능 감소가 더 크게 나타납니다. 결과적으로 $t_{pHL}$이 $t_{pLH}$보다 길어지는 불균형이 발생한 것으로 분석됩니다.

- Post-layout
	Post-layout 시뮬레이션에서는 두 MUX 모두 Parasitic R과 Parasitic C가 추가되어 $t_p$​가 증가했지만, Passgate MUX의 성능 저하 폭이 CNV MUX보다 훨씬 컸습니다.
	- CNV MUX는 본질적으로 버퍼(인버터)의 트리 구조입니다. 모든 노드가 VDD 또는 VSS에 의해 강하게 dirve되므로, 기생성분이 추가되더라도 지연 시간에 미치는 영향이 비교적 적습니다.
	- Passgate MUX는 1st stage의 Passgate 스위치를 통과한 신호가 2nd stage의 인버터에 도달하는 구조입니다. 이 스위치와 인버터 사이의 중간 노드는 VDD/VSS에 의해 dirve되지 않아 기생 성분에 매우 취약합니다. Pre-layout에서는 이 노드에 기생성분이 없었지만, Post-layout에서 레이아웃으로 인한 기생 성분이 추가되면서 RC delay가 크게 추가되었습니다.

두 MUX 회로는 모두 3개의 2-to-1 MUX를 사용한 트리구조로 설계되었습니다.
1st stage의 MUX 두 개는 S0에 의해 {A, B} 그룹과 {C, D} 그룹에서 각각 하나의 신호를 선택합니다. 2nd stage의 MUX 한 개는 S1에 의해 앞단에서 선택된 두 신호 중 최종 하나를 선택합니다.
두 방식 모두 내부 동작 방식(CNV의 Inverting-Logic, Passgate의 Non-inverting + Inverter로 신호 강도 회복)은 다르지만, 회로 전체적으로는 동일한 논리 기능을 수행하도록 설계되었습니다.
- S0: 0일 경우 2nd stage로 {$\overline A, \overline C$}를, 1일 경우 {$\overline B, \overline D$}를 보냄
- S1: 0일 경우 1st stage에서 보내진 신호 가운데 전자{$A, B$}를, 1일 경우 후자{$C, D$}를 선택함

### 2. Screenshots

- CNV
	- Schematic
		![[CNV_schematic.png]]
	- Symbol
		![[CNV_symbol.png]]
- INV
	- Schematic
		![[INV_schematic.png]]
	- Symbol
		![[INV_symbol.png]]
- CNV based MUX 4x1
	- Schematic
		![[MUX_CNV_schematic.png]]
	- Symbol
		![[MUX_CNV_symbol.png]]
	- Layout
		![[MUX_CNV_layout.png]]
	- DRC
		![[MUX_CNV_DRC.png]]
	- LVS
		![[MUX_CNV_LVS.png]]
	- Calibre
		![[MUX_CNV_calibre.png]]
	- Testbench config
		![[MUX_CNV_TB_config.png]]
	- Testbench Schematic
		![[MUX_CNV_TB_schematic.png]]
- Passgate based MUX 4x1
	- Schematic
		![[MUX_PG_schematic.png]]
	- Symbol
		![[MUX_PG_symbol.png]]
	- Layout
		![[MUX_PG_layout.png]]
	- DRC
		![[MUX_PG_DRC.png]]
	- LVS
		![[MUX_PG_LVS.png]]
	- Calibre
		![[MUX_PG_calibre.png]]
	- Testbench config
		![[MUX_PG_TB_config.png]]
	- Testbench Schematic
		![[MUX_PG_TB_schematic.png]]
- Library manager
	![[libman.png]]