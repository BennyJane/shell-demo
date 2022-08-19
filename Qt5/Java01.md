// ----------------------------------------------------------------------------------
// 【字符串】
// ----------------------------------------------------------------------------------
StringBuilder sb = new StringBuilder;
## 计算长度，ERROR：size()
sb.length();

### 删除指定索引位置的字符
sb.deleteCharAt(index);
sb.charAt(index);

sb.append('c');
sb.toString();

### 正则转义
在java中\\表示一个\，而regex中\\也表示\，所以当\\\\解析成regex的时候为\\
\ -> \\\\
| -> \\|
+ -> \\+
. -> \\.
* -> \\*
expression.split("\\+\\*\-").length
path.split("\\\\");

### replace: 不需要转义，replaceAll 使用正则，需要转义
expression.replace(".", "")
expression.replaceAll("\\.", "")


### 定义、生成字符串
String s= "abc";
String s= new String("abc");

char[] array = {'a', 'b', 'c'};
String s = new String(array);
// 设置偏移量
// public String(char value[], int offset, int count)
String s = new String(array, 1, 2);
String s = String.valueOf(array);


### 常用方法
char[] array = s.toCharArray();

String.join(" ", array);
String.valueOf(10);

s.toLowerCase();
s.toUpperCase()

### 返回第一个出现的索引, indexOf
！！方法名称
s.indexOf("c");
s.lastIndexOf("c");

###注意start end后需要添加s 
！！方法名称
s.startsWith("abc");
s.endsWith("abc");

s.substring(start);
s.substring(start, end);
s.replace(old, newString);

###去除前后空格的新字符串
s = s.trim();
s.split(" ");
s.toCharArray();


###字符串逆序
new StringBuffer("abcde").reverse().toString();

###正则匹配
import java.util.regex.*;

String pattern = ".*runood.*";
// Pattern.matches()
boolean isMatch = Pattern.matches(pattern, content);
System.out.println("result: " + isMatch);



// ----------------------------------------------------------------------------------
// 【整数】
// ----------------------------------------------------------------------------------

### 解析二进制为十进制
Integer.parseInt("10101", 2);


// ----------------------------------------------------------------------------------
// 【数组与集合】
// ----------------------------------------------------------------------------------
char[] array = S.toCharArray();
Arrays.sort(array);

int[] dp = new int[10];
Arrays.fill(dp, -1);

### 数组 -> 列表，ArrayList
List<Integer> list = Arrays.asList(dp);
### 最好拷贝一份，否则会影响原数组内的值
List array = new ArrayList(list);

### 列表转数组
List<String> list = new ArrayList<>();
list.toArray(new String[list.size()]);

### 数组拷贝：不会影响原数组
String[] clone = words.clone();


### 计算长度
array.length; 数据都是使用.length 没有括号
list.size();

### 字符串使用length()
s.length();
sb.length();

### EEROR: 多维数组，需要自定义排序规则，否则会出错
Arrays.sort(startIndex, (a, b) -> a[0] - b[0]);
Arrays.sort(array, fromIndex, toIndex, 比较器)
### 从大到小排序，只排序[0, 3)
Arrays.sort(arr, 0, 3, (o1, o2) -> o2 - o1);  

Arrays.stream(nums).sum();


Arrays.sort(strArray, Collections.reverseOrder());


// ----------------------------------------------------------------------------------
// 【栈】
// ----------------------------------------------------------------------------------

Queue<TreeNode> queue = new LinkLisk<>();
!queue.isEmpty();
int size = queue.size();
### offer poll 从同一端存、取
TreeNode node = queue.poll();
queue.offer(node.left);


### 双端队列，模拟栈 
Deque<Integer> deque = new ArrayDeque<>();
deque.push(10);
deque.pop();
deque.peek();

// ----------------------------------------------------------------------------------
// 【双端队列】 push/pop  offer|offerLast/pollLast peekLast [tail->head] peekFirst|peek offerFirst/pollFirst|poll
// ----------------------------------------------------------------------------------
Deque<Integer> deque = new ArrayDeque<>();

### 获取顶部元素
deque.peek();

### 模拟栈：压入顶部，弹出顶部
deque.push(0);
deque.pop();
deque.poll();

Deque<Integer> deque =new LinkedList<>();
queue.offer(10);
queue.offerLast(10);
queue.pollLast();

queue.offerFirst(10);
queue.poll(10);
queue.pollFirst(10);


// ----------------------------------------------------------------------------------
// 【单端队列】 offer [tail->head] poll  
// ----------------------------------------------------------------------------------
Queue<Integer> queue = new LinkedList<>();
### 从队列末尾添加元素，成功返回true，失败返回false
queue.offer(1);
### 从队列头部取出元素
queue.poll()
### 查看队列头部元素，返回首部元素
queue.peek();
### 检查队列是否为空
queue.isEmpty()
queue.size();



// ----------------------------------------------------------------------------------
// 【优先队列】
// ----------------------------------------------------------------------------------
### 默认小根堆：堆顶为最小值
### 默认大小为11，在当中增加元素会扩容，只是开始指定大小。不是size，是capacity
PriorityQueue<Integer> queue = new PriorityQueue<>(); 
PriorityQueue<Integer> queue = new PriorityQueue<>(100); 
queue.peek();
queue.offer();

### 大根堆
PriorityQueue<Integer> maxHeap = new PriorityQueue<>((a, b) -> (b -a));
maxHeap.offer(10);
maxHeap.poll();
maxHeap.peek();


// ----------------------------------------------------------------------------------
// 【TreeSet: 有序队列】
// ----------------------------------------------------------------------------------
TreeSet<Integer> treeSet = new TreeSet();

# ！！！不能包含重复值
treeSet.add(4);
treeSet.add(0);
treeSet.add(5);
treeSet.add(1);
treeSet.add(7);
treeSet.add(3);
treeSet.add(2);
treeSet.add(6);

int size = treeSet.size();
for (int i = 0; i < size; i++) {
	// FIXME 不能通过索引访问
}
Iterator<Integer> it = treeSet.iterator();
System.out.println(treeSet.first());
System.out.println(treeSet.last());
System.out.println(treeSet.isEmpty());


// ----------------------------------------------------------------------------------
// 【set、map】
// ----------------------------------------------------------------------------------

Set<Integer> set = new HashSet<>();
List<Integer> list = new ArrayList<>....;
Set<Integer> set = new HashSet<>(list);

set.add(1);
set.remove(1);
boolean exist = set.contains(1);
set.isEmpty()
set.size()

### 返回集合里的最大值（若给了比较器从大到小则是返回最小值）
set.last()



Map<Characters, Integer> map = new HashMap<>();
map.get('a');
map.getOrdefault('a', 0);
map.containsKey('a');  map.get('a') == null

### 返回一个Set,这个Set中包含Map中所有的Key --- O(1)
map.keySet();
for (Character key : map.keySet()) {
    // Operate with each key
}
map.values();
for (Integer value : map.values()) {
    // Operate with each values
}

map.isEmpty();
map.size();


// ----------------------------------------------------------------------------------
// 【流程控制】
// ----------------------------------------------------------------------------------

switch (b) {
	case 'c':
		doSomething();
		break;
	case 'b':
		doSomething();
		break;
	case 'c':
		doSomething();
		break;
	default;
		break;
}


// ----------------------------------------------------------------------------------
// 【二进制操作】
b ^ b = 0
a ^ b = b ^ a  


a = a ^ b
b = a ^ b
a = a ^ b


// ----------------------------------------------------------------------------------
// 【二分查找】

# 小于res的最大值
left, right = 0, n - 1
while left < right:	# 不取等号
	# mid 取右侧坐标
	mid = (left + right) / 2 + 1
	if nums[mid] < res:
		left = mid
	else:
		right = mid - 1

int left = startIndex;
int right = nums.length - 1;
while (left < right) {
	int mid = (left + right + 1) / 2;
	if (nums[mid] < target) {
		left = mid;
	} else {
		right = mid - 1;
	}
}


int[] nums = new int[100];

### 查找第一个大于等于 <key>的索引位置
### toIndex 不包含在内
int index = Arrays.binarySearch(nums, <startIndex>, <endIndex>, <target>)


