## Altera Video Direct Memory Access ## <sup>no avalon bus</sup>
-----
**简单说明：**
    Altera VDMA 非avalon 总线设计
    工程代码，已经通过实际项目测试

**mem_if_stream_and_vhf**：vdma顶层模块

+ WR_MODE:  
    写模式选择，stream还是 标准 video 行场
+ RD_MODE:  
    读模式选择，stream还是 标准 video 行场
+ READ_PORTS:

    读端口使能
+ WRITE_PORTS:

    写端口使能
+ W0_SIZE:

    写第一端口时间位宽
+ R0_SIZE:

    读第一端口时间位宽

+ W0_DELTA

    写，每一行的地址步进 2**W0_DELTA，只能用于标准 video 行场模式

+ R0_DELTA

    写读，每一行的地址步进 2**R0_DELTA，只能用于标准 video 行场模式

+ W0_FLIPPING

    写反转，从高位地址写到地位，用于图像上下反转，只能用于标准 video 行场模式

 
**--@--Young--@--**
