# Submitting results 

## "The Long and Short of It"

Some quick inferences that can be drawn from these results:
- There is little difference between gcc6 and gcc8 on the Serenities for Coremark and Whetstones, but a more pronounced difference between both of those and gcc4. There is little difference between gcc6/8 and gcc4 with respect to Dhrystone computations.
- Differences between all benchmarks with respect to the two Serenities are within experimental uncertainty.
- We haven't been able to run gcc6 and gcc8 on the Apollo, but hope to soon.

## Key

- Serenity 13/16: __nanoX-BT-E3845-2G__ from https://www.adlinktech.com/Products/Computer_on_Modules/COMExpressType10/nanoX-BT?lang=en#tab-ordering
- Apollo 5: https://www.enclustra.com/en/products/system-on-chip-modules/mercury-zx1/
- __Docker containers:__
  - CC7-base: https://hub.docker.com/r/cern/cc7-base/tags (tags: 20200201-1.x86_64)
  - Shepherd-dev: https://hub.docker.com/r/rknowlton/shepherd-dev/tags (tag: 0.2)

## Benchmarking Results

| Benchmark/Application | Platform/SoC                                             | Result w/ unit (st. dev)        | # Runs | Notes               |
|-----------------------|----------------------------------------------------------|---------------------------------|--------|---------------------|
| CoreMark              | Enclustra Mars PM3 with Mars ZX2 (Zynq Z-7010 processor) | 4961.007 iterations/s           | 10     | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone             | Enclustra Mars PM3 with Mars ZX2 (Zynq Z-7010 processor) | 3077651.5 Dhrystones/s          | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Enclustra Mars PM3 with Mars ZX2 (Zynq Z-7010 processor) | 1462.08 Whetstones/s            | 10     | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 13 (GCC v4.8.5) | 7852.72 (47.00) iterations/s  | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 13 (GCC v4.8.5) | 3358813 (19554) Dhrystones/s  | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 13 (GCC v4.8.5) | 3363442 (3820.3) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 13 (GCC v4.8.5) | 12678 (564) Whetstones/s      | 10 | [Run details](RunningBenchmarks.md#whetstone) |
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 13 (GCC v6.3.1) | 9518.58 (115.77) iterations/s | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 13 (GCC v6.3.1) | 3336698 (10195) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 13 (GCC v6.3.1) | 3348883 (13221) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 13 (GCC v6.3.1) | 18000 (1721) Whetstones/s     | 10 | [Run details](RunningBenchmarks.md#whetstone) |
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 13 (GCC v6.3.1) - CC7-base |  iterations/s  | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 13 (GCC v6.3.1) - CC7-base |  Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 13 (GCC v6.3.1) - CC7-base |  Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 13 (GCC v6.3.1) - CC7-base |  Whetstones/s   | 10 | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 13 (GCC v6.3.1) - Shepherd-dev |  iterations/s  | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 13 (GCC v6.3.1) - Shepherd-dev |  Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 13 (GCC v6.3.1) - Shepherd-dev |  Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 13 (GCC v6.3.1) - Shepherd-dev |  Whetstones/s   | 10 | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 13 (GCC v8.3.1) | 9373.28 (69.61) iterations/s  | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 13 (GCC v8.3.1) | 3404550 (1937) Dhrystones/s   | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 13 (GCC v8.3.1) | 3395433 (1932) Dhrystones/s   | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 13 (GCC v8.3.1) | 21500 (2415) Whetstones/s     | 10 | [Run details](RunningBenchmarks.md#whetstone) |
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 16 (GCC v4.8.5) | 7909.05 (42.45) iterations/s  | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 16 (GCC v4.8.5) | 5653594 (157858) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 16 (GCC v4.8.5) | 5664488 (163398) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 16 (GCC v4.8.5) | 12857.1 (752.9) Whetstones/s  | 10 | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 16 (GCC v6.3.1) | 9621.76 (29.91) iterations/s  | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 16 (GCC v6.3.1) | 5620915 (137789) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 16 (GCC v6.3.1) | 5628177 (144104) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 16 (GCC v6.3.1) | 18333.4 (1756) Whetstones/s   | 10 | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 16 (GCC v6.3.1) - CC7-base | 8895.08 (956.9) iterations/s  | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 16 (GCC v6.3.1) - CC7-base | 3324581  (20372) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 16 (GCC v6.3.1) - CC7-base | 3331561  (17212) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 16 (GCC v6.3.1) - CC7-base | 18000   (1721) Whetstones/s   | 10 | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 16 (GCC v6.3.1) - Shepherd-dev | 9044.26 (910.3) iterations/s  | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 16 (GCC v6.3.1) - Shepherd-dev | 3331740 (16366)  Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 16 (GCC v6.3.1) - Shepherd-dev | 3333575 (11600) Dhrystones/s  | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 16 (GCC v6.3.1) - Shepherd-dev | 18000 (1721) Whetstones/s     | 10 | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                          |                               |    |                                              | 
| CoreMark              | Serenity 16 (GCC v8.3.1) | 9474.24 (23.79) iterations/s  | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 16 (GCC v8.3.1) | 5620915 (137789) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 16 (GCC v8.3.1) | 5591866 (108932) Dhrystones/s | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 16 (GCC v8.3.1) | 21000.0 (2108) Whetstones/s   | 10 | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                          |                               |    |                                              | 
| CoreMark              | Apollo 5 (GCC v4.8.5)    | 3711.91 (9.49) iterations/s   | 10 | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Apollo 5 (GCC v4.8.5)    | 2387029 (32388) Dhrystones/s  | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Apollo 5 (GCC v4.8.5)    | 230952.5 (0) Dhrystones/s     | 10 | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Apollo 5 (GCC v4.8.5)    | 4928.57 (115) Whetstones/s    | 10 | [Run details](RunningBenchmarks.md#whetstone)|

