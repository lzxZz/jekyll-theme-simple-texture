---
layout: post
title: "java字符串构造"
description: "The first 'Hello world' post for Simple Texture theme."
category: ["java", "面试题"]
tags: ['string', '==', '构造']
---


> 介绍, 本文内容详细讲解了一道面试题

下面程序的运行结果是? 为什么?
String str1 = “hello”;
String str2 = “he”+new String(“llo”);
String str3 = “he”+”llo”;
System.err.println(str1== str2);
System.err.println(str1 == str3);


这段代码涉及到的知识点为java中string的构造操作., 以及`==`运算符.

首先介绍一下简单的`==`吧, 
对于基本数据类型(int, double, char)等判断的是值相等
对于引用数据类型(所有java.object)的子类,判断的都是地址相等.

众所周知, java有一个字符串的常量池, 其中存储着一些字符串常量. 那么什么时候会使用字符串常量呢?

使用字符串字面量的时候会使用到字符串常量池, 而使用new的时候则会在堆中创建一个对象.

显然,str1引用了字符串常量池, 而str2引用的是堆中的对象. 即便str2是由一个字面量和一个对象组装出来的.

那么str3也应该是引用的字符串常量池.

在C++中, 不论多少个字符串字面量相加(使用`+`连接), 编译器都会优化成一个字符串字面量. 那么Java呢?

首先我们来测试下面这段代码:
```java
public class Test1{
    public static void main(String[] args) {
        String str1 = "hello";
    }
}
```
下面是这段代码的反编译的代码
```
Compiled from "Test1.java"
public class Test1 {
  public Test1();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static void main(java.lang.String[]);
    Code:
       0: ldc           #2                  // String hello
       2: astore_1
       3: return
}
```
可以看到这个类中有两个方法, 第一个是构造哦函数, 这里我们不管. 第二个则是我们编写的测试代码.

其中涉及到了两个jvm指令,`ldc`和`astore_1`.
`ldc`用于将常量入栈
`astore_1`在索引为1的位置将第一个操作数出栈. 并入本地变量.
上面的两条指令就是构造了一个常量然后存到第一个本地变量中.

这里`ldc`将`hello`压入栈中, 可以看到没有调用任何的方法.
下面给出一个使用new构造字符串的例子.代码如下
```java
public class Test2{
    public static void main(String[] args) {
        String str1 = new String("hello");
    }
}
```
字节码代码如下(删去了构造函数等无关代码):
```
public static void main(java.lang.String[]);
  Code:
     0: new           #2                  // class java/lang/String
     3: dup
     4: ldc           #3                  // String hello
     6: invokespecial #4                  // Method java/langString."<init>":(Ljava/lang/String;)V
     9: astore_1
    10: return
```

这里多了好几条指令
`new`与编程语言中的 new 运算符类似，它根据传入的操作数所指定类型来创建对象

`dup`会复制顶部操作数的栈值，
`invokespecial` 调用方法, `invoke`系列还有好几条指令.

可以看到, 首先还是先将`hello`放到了常量池中. 然后在构造了一个对象. 
下面使用代码打印一些地址来看看是否是一个在常量池, 一个在堆中., 代码如下:
```java
public class Test3{
    public static void main(String[] args) {
        String str1 = "hello";
        String str2 = new String("hello");
        String str3 = "hello";

        System.out.println(System.identityHashCode(str1));
        System.out.println(System.identityHashCode(str2));
        System.out.println(System.identityHashCode(str3));
    }
}
```
java中输出对象的地址可以使用`hashCode()`方法, 但是String重写了这个方法, 因此使用`System.identityHashCode(obj)`来输出地址.
程序的输出如下:
```
705927765
366712642
705927765
```
可以看到字面量的两个对象引用的是一个地址, 而new出来的对象引用的则是另一个地址.
反编译出来的字节码如下:

```
  public static void main(java.lang.String[]);
    Code:
       0: ldc           #2                  // String hello
       2: astore_1
       3: new           #3                  // class java/lang/String
       6: dup
       7: ldc           #2                  // String hello
       9: invokespecial #4                  // Method java/lang/String."<init>":(Ljava/lang/String;)V
      12: astore_2
      13: ldc           #2                  // String hello
      15: astore_3
      16: getstatic     #5                  // Field java/lang/System.out:Ljava/io/PrintStream;
      19: aload_1
      20: invokestatic  #6                  // Method java/lang/System.identityHashCode:(Ljava/lang/Object;)I
      23: invokevirtual #7                  // Method java/io/PrintStream.println:(I)V
      26: getstatic     #5                  // Field java/lang/System.out:Ljava/io/PrintStream;
      29: aload_2
      30: invokestatic  #6                  // Method java/lang/System.identityHashCode:(Ljava/lang/Object;)I
      33: invokevirtual #7                  // Method java/io/PrintStream.println:(I)V
      36: getstatic     #5                  // Field java/lang/System.out:Ljava/io/PrintStream;
      39: aload_3
      40: invokestatic  #6                  // Method java/lang/System.identityHashCode:(Ljava/lang/Object;)I
      43: invokevirtual #7                  // Method java/io/PrintStream.println:(I)V
      46: return
```

可以看到`0-2`的代码和`13-15`的代码完全一样, 这是两个`String str3 = "hello";`的构造, 而`3-12`的代码则是和Test2中的字节码一致.

前面序号0-15都是构造对象的代码, 后面的都是打印地址的代码. 

这说明`str1`和`str3`都是引用了常量区的字符串. 而`str2`则是构造了新对象.


但是面试题中的`str3`是使用`+`构造的, 他会在常量区中构造`he`和`llo`两个对象吗? 下面我们进行一下测试:
```java
public class Test4{
    public static void main(String[] args) {
        String str1 = "he" + "llo";
    }
}
```
字节码如下:
```
  public static void main(java.lang.String[]);
    Code:
       0: ldc           #2                  // String hello
       2: astore_1
       3: return
```
这里面的代码和Test1中的代码是一样的. 
这说明编译器也作了优化, 将两个字符串常量合并成了一个字符串常量.

到这里为止, 整个面试题的原因就彻底讲清楚了. 理由如下:
**java中`==`操作的比较在面对引用对象`String`的时候, 比较的是地址, 而str1和str3引用的都是同一个字符串常量区的对象,str2引用的是堆中的对象, 因此`str1==str3`而`str1!=str2`. 由于java编译器会将多个使用`+`连接起来的字符串字面量优化为一个字符串字面量, 所以在class文件中, `str1`的构造其实是和`str3`的构造一样的.**


## 延伸内容.

下面还有一点点关于`String str2 = “he”+new String(“llo”);`的内容.
```java
public class Test5{
    public static void main(String[] args) {
        String str2 = "he" + new String("llo");
    }
}
```
这段代码的字节码如下:
```
  public static void main(java.lang.String[]);
    Code:
       0: new           #2                  // class java/lang/StringBuilder
       3: dup
       4: invokespecial #3                  // Method java/lang/StringBuilder."<init>":()V
       7: ldc           #4                  // String he
       9: invokevirtual #5                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      12: new           #6                  // class java/lang/String
      15: dup
      16: ldc           #7                  // String llo
      18: invokespecial #8                  // Method java/lang/String."<init>":(Ljava/lang/String;)V
      21: invokevirtual #5                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      24: invokevirtual #9                  // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      27: astore_1
      28: return
```

首先构造了一个`StringBuilder`对象, 调用了`append`方法, 将`he`追加进去, 然后使用`llo`构造了一个`String`对象, 再次调用`append`方法将`String`对象追加进去. 最后调用`toString`方法, 生成最终的字符串. 最后使用`astore_1`赋值给本地变量.




这里我们猜测,String中的`+`都是使用`StringBuilder`的`append`来完成的, 下面用代码来验证我们的猜想.
```java
public class Test6{
    public static void main(String[] args) {
        String str2 = new String("he") + new String("llo");
    }
}
```
字节码如下:
```
  public static void main(java.lang.String[]);
    Code:
       0: new           #2                  // class java/lang/StringBuilder
       3: dup
       4: invokespecial #3                  // Method java/lang/StringBuilder."<init>":()V
       7: new           #4                  // class java/lang/String
      10: dup
      11: ldc           #5                  // String he
      13: invokespecial #6                  // Method java/lang/String."<init>":(Ljava/lang/String;)V
      16: invokevirtual #7                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      19: new           #4                  // class java/lang/String
      22: dup
      23: ldc           #8                  // String llo
      25: invokespecial #6                  // Method java/lang/String."<init>":(Ljava/lang/String;)V
      28: invokevirtual #7                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      31: invokevirtual #9                  // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      34: astore_1
      35: return
```
果然是使用`StringBuilder`来完成的.


另外还需要注意的是对象创建的问题, 使用字面量作为String的构造会构造出来两个对象, 一个是new出来的堆中对象. 另一个则是会存储到字符串常量区中的字面量.


## 线程安全问题
但是`StringBuilder`是一个线程不安全的类,  那么就有一个问题, 在多线程的环境下字符串的`+`操作会隐式调用`StringBuilder`的操作是否是线程安全的呢?


答案是线程安全的, `StringBuilder`操作的对象是`String`,是一个不可变的对象, 只能读不能修改, 而多线程的环境下字符串的`+`操作也是单线程的, 不会出现跨线程现象, 没有线程A和线程B共同使用一个`StringBuilder`. 多个线程同时访问`String`是安全的.

到了这里, 线程安全的问题基本上已经回答完了. 但是还有一个东西是否会涉及到线程安全问题.

那就是字符串常量池的问题, 多个线程, 同时构造一个字符串常量, 想要放到字符串常量池中. 如果不做控制的话, 肯定就是线程不安全的. 至于jvm内部是否做了控制, 我不得而知.

同时字符串常量池还有一个问题,  由于多个变量同时引用一个对象, 那么一个线程如果对字符串字面量持有一个锁, 那么其他的线程对应的字符串变量都无法访问.