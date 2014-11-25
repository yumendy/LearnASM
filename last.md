# 汇编大作业——探究C语言的秘密

### 语言元素探究与对比

1. 数据类型

    + C语言中常用的数据类型有int、unsigned int、float、char等
    + 然而在汇编语言中，通常是以大小来定义数据的。通常有byte、word、dword、sword、qword等。去别在于占用空间不同。在X86架构的计算机上以小尾序存储。
    + int表示一个整形量，在32位程序中通常占用4个字节。作为一个有符号数，在内存中用补码表示，第一个二进制位为符号位。因此，int类型的数据取值为-2147483648~2147483647.
    + unsigned int与int相似但是表示的是无符号的整数，在32位程序中占用的内存也为4byte，只不过相较于int类型的变量，其最高位不再表示符号位，所以一个无符号数的表示范围为0~4294967295.
    + 对于以上两种数据类型，在汇编中通常声明为QWORD类型。
    + 对于C语言中的char类型的数据，通常用于存放字符，其所占用的空间为1byte。所以在汇编中常用BYTE类型存储。
    + 其实探寻本质，CPU在做实际的运算时，是无法区分有符号数与无符号数的，CPU只是根据根据算数运算规则将两个用补码表示的数字进行加减并根据运算结果设置符号位。而对于结果的解读，则需要程序员进行判断。例如在使用cmp指令时，CPU并无法判断源操作数和目的操作数的类型，仅仅能进行一个减法运算并设置符号位，具体的判断及转移工作是有cmp指令之后的jmp、jz、jne、je、ja等等跳转指令决定的。

1. 宏定义的实现

    + 在C语言和汇编语言中宏定义与使用有相似之处。可以使用宏定义的方式将重复使用的代码封装并调用。在汇编或编译时进行代码的展开。这样可以有效的提高开发效率，同时使代码更简洁。
    + 宏定义与函数调用相比好处是显而易见的。速度远快于函数调用，但同时需要占据更大的代码空间。

1. 数学运算的实现

    + 在C语言里，最常用的数学运算有+、-、*、/、%。
    + 相应的在汇编中每种运算都有对应的方式。
    + 在C语言中的整数加法，通过反汇编可知是直接使用`add`指令完成的。
    + 整数的减法则是通过`sub`指令完成。
    + 有符号整数的乘法使用了`imul`指令。
    + 除法和取余则都使用的是`cdq`和`idiv`指令，差异在于除法的商保存在eax寄存器中，而余数则是保存在edx中。
    + 对于乘除法来说，如果是对一个常数进行操作的话将使用更为快捷的移位指令，其中乘法使用`shl`除法是`sar`。

1. 子程序的实现

    + 子程序（函数）的实现在C语言和汇编语言中略有不同，在C语言中主要是通过单一的函数调用实现的。但在汇编语言中可以有多种不同的调用方式。但大都是`call`指令和一些其他指令的封装，为了简化开发过程。
    + 在具体的实现中，汇编编程可以使用寄存器传参，也可以使用堆栈传参，但是在C语言中所有的参数传递被统一为了堆栈传参。返回值的返回方式也是各不相同的，C语言使用累加器（EAX）返回值，但是在汇编中，程序员可以选择通用寄存器返回值，返回的值也不限于一个了。
    
### 深入探究C语言的实现

##### 用一小段C语言的程序并通过反汇编的方式探究C语言的实现

    #define _CRT_SECURE_NO_WARNINGS

    #define N 15
    
    #define MAX(a, b) a > b ? a : b
    
    #include <iostream>
    #include <string.h>
    
    using namespace std;
    
    struct Test
    {
        int s_i;
        char s_c;
    };
    
    int function_MAX(int a, int b)
    {//function_MAX
    	if (a > b)
    	{
    		return a;
    	}
    	else
    	{
    		return b;
    	}
    }
    
    void cout_struct(Test test)
    {//cout_struct
    	printf("%d\t%c\n", test.s_i, test.s_c);
    }
    
    
    
    int global_int = 300;
    
    int main(int argc, char const *argv[])
    {
    	int a, b, c, d;
    	a = 200;
    	b = 100;
    	//宏定义测试
    	c = MAX(a, b);
    	//函数传参、返回值及选择结构的测试
    	d = function_MAX(a, b);
    	//循环结构测试
    	int sum = 0;
    	for (int i = 0; i < 5; i++)
    	{
    		sum += i;
    	}
    	//结构体测试
    	Test test;
    	test.s_i = 10;
    	test.s_c = 'A';
    	cout_struct(test);
    	return 0;
    }
    
以上是一段C语言程序，涵盖了C语言中常用的语法元素。

通过反汇编和在编译时输出汇编文件的方式可以探究其汇编的实现过程。

+ C语言中所有的宏定义在汇编代码中并不作为单独的部分代码出现，而是在编译的时候直接被替换到了相印的位置。因此，从输出的cod文件中可以看出，程序的开始是从全局变量的声明开始的。
+ 全局变量声明为如下形式：

        PUBLIC    ?global_int@@3HA				; global_int
        _DATA	SEGMENT
        ?global_int@@3HA DD 012cH				; global_int
        _DATA	ENDS
可以看出全局变量`global_int`被声明为了dword类型。并赋予了初值012cH（即十进制的300），与之前的C语言语句对应。这就是C语言中的全局变量在汇编中的实现方式。

+ 紧接着是有关函数的定义。在这一段示例C语言程序中一共有两个自定义函数，分别是`function_MAX`和`cout_struct`。第一个函数主要是为了探究C语言的传参和选择判断控制结构。第二个函数主要是为了探究如何给一个函数传递一个复杂的对象作为参数（以结构体为例）。

+ 在主函数中，语句顺序执行。以下是主函数被编译出来的汇编程序。
        
**初始化主函数，标明每一个局部变量相对于ebp的偏移量。**

        _TEXT    SEGMENT
        tv65 = -284						; size = 4
        _test$ = -84						; size = 8
        _i$1 = -68						; size = 4
        _sum$ = -56						; size = 4
        _d$ = -44						; size = 4
        _c$ = -32						; size = 4
        _b$ = -20						; size = 4
        _a$ = -8						; size = 4
        _argc$ = 8						; size = 4
        _argv$ = 12						; size = 4
        _main	PROC						; COMDAT

**在主函数开始的部分进行ebp压栈、预留空间、保存寄存器现场的工作**

        ; 39   : {
            ;
        	push	ebp
        	mov	ebp, esp
        	sub	esp, 284				; 0000011cH
        	push	ebx
        	push	esi
        	push	edi
        	lea	edi, DWORD PTR [ebp-284]
        	mov	ecx, 71					; 00000047H
        	mov	eax, -858993460				; ccccccccH
        	rep stosd

**寄存器间接寻址的方式为变量赋予初值**

        ; 40   : 	int a, b, c, d;
        ; 41   : 	a = 200;
        
        	mov	DWORD PTR _a$[ebp], 200			; 000000c8H
        
        ; 42   : 	b = 100;
        
        	mov	DWORD PTR _b$[ebp], 100			; 00000064H

**宏定义测试**

在C语言中对于宏的实现是一种替换式的实现。将宏定义的代码替换到宏引用的相应位置。在源程序中使用三元运算符来实现宏函数MAX。在此处被替换为判断和条件跳转指令。通过跳转方式将函数的返回值赋予变量。与一般的函数调用的不同之处在于，一般的函数调用需要使用累加器返回函数结果。但是这样的宏函数只是作为代码替换，实际上还是在主函数内执行。所以计算结果可以直接写入相应的位置而无需通过累加器返回。

        ; 43   : 	//宏定义测试
        ; 44   : 	c = MAX(a, b);
        
        	mov	eax, DWORD PTR _a$[ebp]
        	cmp	eax, DWORD PTR _b$[ebp]
        	jle	SHORT $LN6@main
        	mov	ecx, DWORD PTR _a$[ebp]
        	mov	DWORD PTR tv65[ebp], ecx
        	jmp	SHORT $LN7@main
        $LN6@main:
        	mov	edx, DWORD PTR _b$[ebp]
        	mov	DWORD PTR tv65[ebp], edx
        $LN7@main:
        	mov	eax, DWORD PTR tv65[ebp]
        	mov	DWORD PTR _c$[ebp], eax

**函数传参、返回值以及选择控制结构测试**

以下程序用来探究C语言中函数传参、返回值以及选择控制结构的实现方式。在C语言中使用最基础的函数调用的方式实现对变量的赋值。函数function_MAX接受两个参数a与b返回一个整形的数据。在函数被调用之前可以看出汇编的实现方式是将参数从右向左依次压入堆栈。然后使用call指令调用函数。

在调用结束之后使用add指令讲esp加上参数所占用的大小（8byte）以达到平衡堆栈的作用。并将储存在累加器EAX中的返回值赋予相应的变量。由此达到函数的调用过程。

        ; 45   : 	//函数传参、返回值及选择结构的测试
        ; 46   : 	d = function_MAX(a, b);
        
        	mov	eax, DWORD PTR _b$[ebp]
        	push	eax
        	mov	ecx, DWORD PTR _a$[ebp]
        	push	ecx
        	call	?function_MAX@@YAHHH@Z			; function_MAX
        	add	esp, 8
        	mov	DWORD PTR _d$[ebp], eax

以下是function_MAX的实现部分：

        ;函数的初始化部分，列出参数的相对ebp的偏移量。
        _TEXT    SEGMENT
        _a$ = 8							; size = 4
        _b$ = 12						; size = 4
        ?function_MAX@@YAHHH@Z PROC				; function_MAX, COMDAT
        
        ; 18   : {//function_MAX
        ;函数开始，ebp压栈，保存寄存器现场。
        	push	ebp
        	mov	ebp, esp
        	sub	esp, 192				; 000000c0H
        	push	ebx
        	push	esi
        	push	edi
        	lea	edi, DWORD PTR [ebp-192]
        	mov	ecx, 48					; 00000030H
        	mov	eax, -858993460				; ccccccccH
        	rep stosd

汇编中选择控制结构的实现是如下，通过cmp指令和条件跳转指令来执行的，经过对比可以发现，在这个例子中，三元运算符与if结构所构成的汇编代码是一致的，差别在于此处为函数调用，所以返回值最终是交于EAX完成传递的。

        ; 19   : 	if (a > b)
        
        	mov	eax, DWORD PTR _a$[ebp]
        	cmp	eax, DWORD PTR _b$[ebp]
        	jle	SHORT $LN2@function_M
        
        ; 20   : 	{
        ; 21   : 		return a;
        
        	mov	eax, DWORD PTR _a$[ebp]
        	jmp	SHORT $LN3@function_M
        
        ; 22   : 	}
        ; 23   : 	else
        
        	jmp	SHORT $LN3@function_M
        $LN2@function_M:
        
        ; 24   : 	{
        ; 25   : 		return b;
        
        	mov	eax, DWORD PTR _b$[ebp]
        $LN3@function_M:
        
        ; 26   : 	}
        ; 27   : }
        ;恢复寄存器现场并返回主程序。
        	pop	edi
        	pop	esi
        	pop	ebx
        	mov	esp, ebp
        	pop	ebp
        	ret	0
        ?function_MAX@@YAHHH@Z ENDP				; function_MAX
        _TEXT	ENDS


下面是一段对于循环结构的测试程序。通过分析可以看出，C语言中的for循环会被编译器编译为条件跳转语句，其中的循环计数器i并未被储存在寄存器中加快速度。

        ; 47   : 	//循环结构测试
        ; 48   : 	int sum = 0;
        
        	mov	DWORD PTR _sum$[ebp], 0
        
        ; 49   : 	for (int i = 0; i < 5; i++)
        
        	mov	DWORD PTR _i$1[ebp], 0
        	jmp	SHORT $LN3@main
        $LN2@main:
        	mov	eax, DWORD PTR _i$1[ebp]
        	add	eax, 1
        	mov	DWORD PTR _i$1[ebp], eax
        $LN3@main:
        	cmp	DWORD PTR _i$1[ebp], 5
        	jge	SHORT $LN1@main
        
        ; 50   : 	{
        ; 51   : 		sum += i;
        
        	mov	eax, DWORD PTR _sum$[ebp]
        	add	eax, DWORD PTR _i$1[ebp]
        	mov	DWORD PTR _sum$[ebp], eax
        
        ; 52   : 	}
        
        	jmp	SHORT $LN2@main
        $LN1@main:


下面的部分是结构体传参测试结构体在内存里占据一定的空间。作为一个复杂的数据对象，C语言像函数传参的时候传递的是结构体每一项数值的拷贝。可以看出结构体作为主函数的一个局部变量，需要存储在堆栈中，因此会被自动对齐到4字节。

        ; 53   : 	//结构体测试
        ; 54   : 	Test test;
        ; 55   : 	test.s_i = 10;
        
        	mov	DWORD PTR _test$[ebp], 10		; 0000000aH
        
        ; 56   : 	test.s_c = 'A';
        
        	mov	BYTE PTR _test$[ebp+4], 65		; 00000041H
        
        ; 57   : 	cout_struct(test);
        ;
        	mov	eax, DWORD PTR _test$[ebp+4]
        	push	eax
        	mov	ecx, DWORD PTR _test$[ebp]
        	push	ecx
        	call	?cout_struct@@YAXUTest@@@Z		; cout_struct
        	add	esp, 8
        
        ; 58   : 	return 0;
        
        	xor	eax, eax
        
        ; 59   : }

以下部分为主程序结束时返回系统调用的部分代码。

        	push	edx
        	mov	ecx, ebp
        	push	eax
        	lea	edx, DWORD PTR $LN10@main
        	call	@_RTC_CheckStackVars@8
        	pop	eax
        	pop	edx
        	pop	edi
        	pop	esi
        	pop	ebx
        	add	esp, 284				; 0000011cH
        	cmp	ebp, esp
        	call	__RTC_CheckEsp
        	mov	esp, ebp
        	pop	ebp
        	ret	0
        $LN10@main:
        	DD	1
        	DD	$LN9@main
        $LN9@main:
        	DD	-84					; ffffffacH
        	DD	8
        	DD	$LN8@main
        $LN8@main:
        	DB	116					; 00000074H
        	DB	101					; 00000065H
        	DB	115					; 00000073H
        	DB	116					; 00000074H
        	DB	0
        _main	ENDP
        _TEXT	ENDS

**汇编语言的优缺点与C语言的对比**

C语言和汇编语言属于两种完全不同的语言，其实C语言属于高级语言的范畴。

两种语言各有优劣，适用范围也不相同。

其中C语言更适合开发大型的项目及软件，程序编写过程较为简单易懂。但是由于编译器的优化程度等原因，C语言的执行效率相较于汇编慢一些，但是它的语意更贴近自然语言，更方便学习和记忆。C语言同时具有可移植性，与OS无关的代码只需要在新的环境下重新编译即可使用，但是汇编程序的使用范围却较为单一。

汇编语言因为更贴近硬件底层，它与机器指令一一对应，因此它具有高效的特性，除了上述优点之外，汇编最大的优势在于可以方便的调用硬件接口，这一点是高级语言所无法完成的。但汇编语言程序编写难度较大，一般只适合编写规模较小但对效率要求较高的程序，比如系统内核、驱动程序等。

**课程收获**

通过汇编语言程序设计课程的学习，我认为最大的收获不仅仅是汇编语言本身，更为重要的是通过汇编语言的学习，加深了我对计算机底层的认识（内存管理、函数调用等等），这些对于底层的认识可以让我们在后续的开发实践中多一层考虑因素，从根本上优化程序的执行效率。

通过汇编的学习，也同时为后续课程的学习奠定了基础。通过对汇编基础指令的学习，也方便了后期自主学习的理解。可以更深入一步学习较新的SSE指令集等。