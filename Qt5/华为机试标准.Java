

// 需要引入包文件，处理输入、输出
import java.util.*;
public class Main {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		
		// 判断是否有没有下一行
		while (sc.hasNextLine()) {
			// 获取整行字符串
			String line = sc.nextLine();
			
			// 字符串切分
			String[] array = line.split(" ");
			// 转义符号：
			String[] array2 = line.split("\\\\");
			
			// 字符串转数值
			int[] nums = new int[array.length];
			for (int i = 0; i< array.length; i++) {
				nums[i] = Integer.parseInt(array[i]);
			}
			
			// 接受输入的数值类型
			int n = sc.nextInt();
			while (n > 0) {
				int M = sc.nextInt();
				n--;
			}
		}
		
		
		// 打印输出
		System.out.println("result...");
		// 不换行
		System.out.print("result...");
		
		sc.close();
		
	}
}


Scanner sc = new Scanner(System.in);
while (sc.hasNext()) {
	int n = sc.nextInt();
	while (n > 0) {
		
		n--;
	}
}

// 切割整行字符串
String[] strs = sc.nextLine().split(" ");

// 拼接
Arrays.sort(strs);
00.【方案01】
String res = String.join(" ", strs);
00.【方案02】
String res = "";
for (String s: strs) {
	res += s + " ";
}
// 清除两侧空格
res = res.trim();





// next() 与 nextLine() 区别
next():
1、一定要读取到有效字符后才可以结束输入。
2、对输入有效字符之前遇到的空白，next() 方法会自动将其去掉。
3、只有输入有效字符后才将其后面输入的空白作为分隔符或者结束符。
next() 不能得到带有空格的字符串。

nextLine()：
1、以Enter为结束符,也就是说 nextLine()方法返回的是输入回车之前的所有字符。
2、可以获得空白。


public static void main(String[] args) {
    // TODO Auto-generated method stub
    // 1.将字符数组转为字符串
    // 方法一
    char[] data = { 'a', 'b', 'c' };// 字符数组
    String str = new String(data);
    System.out.println(str);
    // 方法二
    String str1 = String.valueOf(data);
    System.out.println(str1);
    
	//字符串转为字符数组
    // 方法一
    String string1 = "abcdefghijk";
    char[] strArr1 = string1.toCharArray();
    for (int i = 0; i < strArr1.length; i++) {
        System.out.println(strArr1[i]);
    }
    // 将字符串 字符串数组互转
    // 方法一
    String string = "abc,def,ghi";
    String[] strArr = string.split(",");//注意分隔符是需要转译
    for (int i = 0; i < strArr.length; i++) {
        System.out.println(strArr[i]);
    }
    
	//方法二
	String[] arr ={"0123","sb","12f"};

　　StringBuffer sb = new StringBuffer();
　　for(int i = 0;i<arr.length;i++){
　　	sb.append(arr[i]);        //append String并不拥有该方法，所以借助StringBuffer
　　}

　　String sb1 = sb.toString();

　　System.out.println(sb1);    //0123sb12f
	
	//字符串逆序
	String s="123abc";

　　System.out.println(new StringBuilder(s).reverse().toString());
}

00.int -> String
int a = 33;

String a1 = String.valueOf(a);
String a2 = Integer.toString(a);
String a3 = a1 + "";				  


String b = "101";
String bb = "123";

int b1 = Integer.parseInt(b+bb);				//101123	
int b2_1 = Integer.parseInt(bb, 10);  		//123
int b2_2 = Integer.parseInt(b, 2); 			//5 解析几进制 的字符串  
int b3 =  Integer.valueOf(b+bb).intValue();  //101123
int b4 = Integer.valueOf(b + bb); //101123


00.排序
// sorted
import java.util.Comparator;
import java.util.stream.Collectors;
List<VolumInfo> sortedVolumInfos =
volumInfos.stream()
	.sorted(Comparator.comparing(VolumInfo::getValue))
	.collect(Collectors.toList());