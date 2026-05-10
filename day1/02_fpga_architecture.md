FPGA的组成结构
A：由可编程IO口，可编程逻辑单元，硬核，底层嵌入功能，嵌入式块RAM，布线资源
LUT的原理
A：LUT的本质其实是由RAM构成，他是能过实现任意组合函数，将组合函数的可能结果输入存储器，通过输入查找表来来输出结果。
CLB、Slice、LUT、FF之间的层级关系
A：ZYNQ7020来说，总共由6550个CLB，一个CLB有两个slice，一个slice有4个LUT和8个FF
分布式RAM和BLOCK RAM的区别
A：分布式的RAM主要是分散在不同区域和不同资源之间的LUT构成，BLOCK RAM主要是直接嵌入的一大块RAM。分别用于不同需求的资源量来决定。