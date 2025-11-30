### 1. Gate Sizing
#### 1) Simulation waveform
- Fanout = 1
	![[1_gate_sizing_prop_delay_fo1.png]]
- Fanout = 2
	![[1_gate_sizing_prop_delay_fo2.png]]
- Fanout = 3
	![[1_gate_sizing_prop_delay_fo3.png]]
- Fanout = 4
	![[1_gate_sizing_prop_delay_fo4.png]]
#### 2) Delay table & Optimum fanout
- Delay table

|       TT, VDD = 1.2 V, 25 ℃        |     Propagation delay [ps]      |
| :--------------------------------: | :-----------------------------: |
| Wp = 1.4 u, Wn = 0.7 u, L = 0.13 u | tp (rising-edge to rising-edge) |
|             Fanout = 1             |             254.46              |
|             Fanout = 2             |             155.354             |
|             Fanout = 3             |             151.062             |
|             Fanout = 4             |             161.558             |

- Optimum fanout

| TT, VDD = 1.2 V, 25 ℃ | Fanout  |
| :-------------------: | :-----: |
|                       | min. tp |
|      Gate sizing      |    3    |

#### 3) Analysis
$t_p$는 트랜지스터의 `Drive Strength`와 `Load Capacitance` 사이의 trade-off 관계에 의해 결정됩니다.

Fanout을 키우면 트랜지스터의 크기가 커져 Drive Strength가 증가하므로 딜레이가 줄어드는 긍정적 효과가 있습니다. 하지만 동시에, 해당 트랜지스터의 $C_{in}$(이전 stage에서의 Load)이 증가하여 이전 stage의 딜레이가 늘어나는 부정적 효과도 발생합니다.

- **Fanout = 1 ~ 3:** Drive Strength 증가로 인한 딜레이 감소 효과가 Load 증가 효과보다 우세하여, $t_p$가 지속적으로 개선됩니다. (151.062 ps @ fo=3)
- **Fanout = 4:** Load Capacitance 증가로 인한 딜레이 증가 효과가 더 커지기 시작하면서, $t_p$가 다시 악화됩니다. (161.558 ps)

따라서 주어진 환경에서 전체 체인의 딜레이를 최소화하는 최적의 Fanout은 3입니다.

### 2. Inverter Chain

#### 1) Layout view
![[2_inv_chain_layout.png]]
#### 2) Post-layout simulation waveform
![[2_inv_chain_prop_delay.png]]
#### 3) Delay table

|       TT, VDD = 1.2 V, 25 ℃        |     Propagation delay [ps]     |
| :--------------------------------: | :----------------------------: |
| Wp = 1.4 u, Wn = 0.7 u, L = 0.13 u | tp (rising-edge to rising-deg) |
|          Post-layout sim.          |             161.84             |

#### 4) Analysis

주어진 Schemtiac의 DUT(Inverter Chain)를 구성하는 각 인버터의 크기는 Wp=1.4u, Wn=0.7u를 기본 크기 1로 설정할 때, 다음과 같이 계산됩니다.
- iv0: (Wp=1.4u, Wn=0.7u) $\rightarrow$ 1
- iv1: (Wp=4.2u, Wn=2.1u) $\rightarrow$ 3
- iv2: (Wp=3.15u \* 4, Wn=1.575u \* 4) $\rightarrow$ 9
- iv3: (Wp=3.5u \* 8, Wn=1.75u \* 8) $\rightarrow$ 20

이는 실험 1(Gate Sizing)의 `fo=3` 환경(`1 -> 3 -> 9 -> 20` 체인)과 동일한 Schematic구성임을 다시 확인할 수 있고, 이를 통해 최적의 schematic을 얻어내고, layout을 그리는 흐름을 실습할 수 있었습니다.

두 실험 결과를 비교하면 다음과 같습니다.
- Pre-layout $t_p$ (실험 1 @ fo=3): 151.062 ps
- Post-layout $t_p$ (실험 2): 161.84 ps
- Delay 증가량: 161.84 - 151.062 = 10.78 ps

이 딜레이 차이(10.78 ps)는 Layout 작업 및 PEX 과정을 거치면서 배선과 소자 간에 추가된 Parasitic resistance와 Parasistic capacitance 때문에 발생한 것입니다. 이는 $t_p \propto RC$ 관계식에 따라, R과 C 성분이 모두 증가하여 총 딜레이($t_p$)가 증가한다는 이론과 일치하는 결과입니다.
### 3. Screenshots of Cell-views and Library manager
- Gate Sizing
	- Schematic
		![[1_gate_sizing_schematic.png]]
- Inverter Chain (DUT)
	- Schematic
		![[2_inv_chain_schematic.png]]
	- Symbol
		![[2_inv_chain_symbol.png]]
	- Layout
		![[2_inv_chain_layout.png]]
	- Calibre
		![[2_inv_chain_calibre_2.png]]
		![[2_inv_chain_calibre_1.png]]
-  Inverter Chain (TB)
	- Config
		![[2_inv_chain_config.png]]
	- Schematic
		![[2_inv_chain_testbench_schematic.png]]
- Library Manager
	![[3_libman.png]]