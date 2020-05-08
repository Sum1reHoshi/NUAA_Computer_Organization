# NUAA_Computer_Organization

本项目是2019年NUAA计算机组成原理的课设作业，含有实现了36条指令的单周期CPU和36条指令的五级流水线CPU

各CPU对应的36条指令可在 `XXCPU / Information / XXCPU Instruction.xlsx`中看到

### 文件结构

* CPU36 Code & Info ---->单周期CPU
  * 36 CPU Code
  * Information
* PCPU36 Code & Info ---->流水线CPU
  * 36 PCPU Code
  * Information
* 测试代码详细说明

### 注意事项

1. 使用Modelism创建Project时，**请将Project目录设为36 CPU Code（36 PCPU Code）否则读取code.txt可能出错**
2. 请注意，测试代码可能不能在MARS或其他软件内运行，除非该软件对寄存器取用不加限制。或在仅限制$zero = 0的模拟软件内运行
3. 没有通过使用Xlinx烧入龙芯开发板的测试

