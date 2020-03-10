# Submitting results 

## "The Long and Short of It"

Some quick inferences that can be drawn from these results:
- [Will include later]

## Key

- Serenity 13/16: __nanoX-BT-E3845-2G__ from https://www.adlinktech.com/Products/Computer_on_Modules/COMExpressType10/nanoX-BT?lang=en#tab-ordering
- Apollo 5: https://www.enclustra.com/en/products/system-on-chip-modules/mercury-zx1/

## Benchmarking Results

| Benchmark/Application | Platform/SoC                                             | Result w/ unit (st. dev)        | # Runs | Notes               |
|-----------------------|----------------------------------------------------------|---------------------------------|--------|---------------------|
| CoreMark              | Enclustra Mars PM3 with Mars ZX2 (Zynq Z-7010 processor) | 4961.007 iterations/s           | 10     | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone             | Enclustra Mars PM3 with Mars ZX2 (Zynq Z-7010 processor) | 3077651.5 Dhrystones/s          | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Enclustra Mars PM3 with Mars ZX2 (Zynq Z-7010 processor) | 1462.08 Whetstones/s            | 10     | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                               |                                 |        |                                              | 
| CoreMark              | Serenity 16 (GCC v4.8.5)      | 7909.05 (42.45) iterations/s    | 10     | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 16 (GCC v4.8.5)      | 5653594 (157858) Dhrystones/s   | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 16 (GCC v4.8.5)      | 5664488 (163398) Dhrystones/s   | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 16 (GCC v4.8.5)      | 12857.1 (752.9) Whetstones/s    | 10     | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                               |                                 |        |                                              | 
| CoreMark              | Serenity 16 (GCC v6.3.1)      | 9621.76 (29.91) iterations/s    | 10     | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 16 (GCC v6.3.1)      | 5620915 (137789) Dhrystones/s   | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 16 (GCC v6.3.1)      | 5628177 (144104) Dhrystones/s   | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 16 (GCC v6.3.1)      | 18333.4 (1756) Whetstones/s     | 10     | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                               |                                 |        |                                              | 
| CoreMark              | Serenity 16 (GCC v8.3.1)      | 9474.24 (23.79) iterations/s    | 10     | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Serenity 16 (GCC v8.3.1)      | 5620915 (137789) Dhrystones/s   | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Serenity 16 (GCC v8.3.1)      | 5591866 (108932) Dhrystones/s   | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Serenity 16 (GCC v8.3.1)      | 21000.0 (2108) Whetstones/s     | 10     | [Run details](RunningBenchmarks.md#whetstone)|
|                       |                               |                                 |        |                                              | 
| CoreMark              | Apollo 5 (GCC v4.8.5)         | 3711.91 (9.49) iterations/s     | 10     | [Run details](RunningBenchmarks.md#coremark) |
| Dhrystone (registers) | Apollo 5 (GCC v4.8.5)         | 2387029 (32388) Dhrystones/s    | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Dhrystone (no regs)   | Apollo 5 (GCC v4.8.5)         | 230952.5 (0) Dhrystones/s       | 10     | [Run details](RunningBenchmarks.md#dhrystone-21) |
| Whetstone             | Apollo 5 (GCC v4.8.5)         | 4928.57 (115) Whetstones/s      | 10     | [Run details](RunningBenchmarks.md#whetstone)|



