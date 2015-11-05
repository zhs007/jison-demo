# ds-lang
数据建模语言。

主要用于我们自己的工作流。

更新说明
---
> 0.1.0</BR>
> 制定基本的语法规则</BR>
> 解析器

why
---
对于程序员来说，数据建模，最方便的还是写代码，定义一个struct，是最简单直接的了，而写sql语句之类的，甚至操作phpmyadmin，都是一件很麻烦的事情，更何况，操作完phpmyadmin以后，还是要写一遍struct，甚至还要写中间代码，这部分工作几乎是重复劳动。

为什么不能写一个struct，就把数据库建好，然后把各种代码自动生成出来呢？

不管是mysql，还是redis，甚至是既有mysql持久化又有redis缓存，其实数据建模本身几乎是无差异的。

上面就是这个建模语言的初衷。

其实有了建模数据以后，我们还可以用这个数据做很多自动化编码的工作，省时省事而且降低人为编码的错误率。

进一步来说，我们还会有一系列的工具，做更多的自动化可视化流程，可以影响到策划、美术、测试、运营等等。

我们需要的只是一些更好读的中间数据，而ds-lang做的仅仅是更方便的产生这一批好读的中间数据。

语法
---
第一次构建一种语言，非常的没有经验，基本上是按照类C语法做的，部分参考google的protobuf，在使用方面，更多的借鉴动态语言，譬如结构默认值就是直接写在结构里了。

原则上，是**强类型**、**强注释**、**强编码规范**的，语法符合大部分人的编码习惯，不反人类。

> **强类型** - 每个对象或变量都是先给定类型的，也鼓励大家用typedef定义新的类型，譬如把ID和int分开（其实本质上ID也就是int）。

```
typedef int ID;	// 定义ID类型，实际上是int
```

> **强注释** - 必须有注释，否则编译不过。因为这是一个建模语言，基本上每个结构每个属性都应该有注释，一定要让人看明白。

> **强编码规范** - 在语言层面强化编码规范，譬如golang这样的，我个人是认同这个方案的。一些最基本的东西需要遵循一定的规范，遵循规范的同时，其实可以带来一些编码的畅快感（少输入）。

基本语法：

* **typedef** - 类型重定向，也就是C里面的typedef。
* **struct** - 结构体，类似C的struct定义，唯一的差别就是支持默认值，直接在声明里写就可以了。
* **static** - 静态结构体定义，类struct，只是明确的表示，这是一个静态配置表。
* **enum** - 枚举，枚举其实是一组常量的集合，语法上和C有些不同。枚举必须大写，而且枚举内容必须是大写枚举加下划线开头，而且枚举是以分号分隔的，每一行定义必须显示的写好对应int值。枚举的值是可以在后面直接使用的。

```
// 英雄属性枚举
enum HEROATTR{
	HEROATTR_VIT = 0;	// 体力 - vitality
	HEROATTR_STA = 1;	// 耐力 - stamina
	HEROATTR_STR = 2;	// 力量 - strength
	HEROATTR_INT = 3;	// 智力 - intelligence
	HEROATTR_DEX = 4;	// 敏捷 - dexterity
	HEROATTR_CRIT = 5;	// 暴击 - critical		
	HEROATTR_PARR = 6;	// 格挡 - parry
	HEROATTR_HIT = 7;	// 命中 - hit
	HEROATTR_MISS = 8;	// 闪避 - miss
};
```

* **全局变量** - 任何定义在结构体和静态表之外的单独变量都是全局变量。
* **结构属性前缀** - 对于结构体来说，有一组简单的前缀，可以方便后续工作流的更好工作。
* **primary** - 主键，也就是这个结构体的唯一标识，如果最后会选择sql数据库落地的话，这个也就是数据库的主键了。
* **联合主键** - primary0、primary1，也就是多个主键一起构成联合主键。
* **index** - 索引，逻辑上，可能会需要根据该属性做查找工作，在数据库里也就是要为他建索引。
* **枚举展开** - 会有很多时候，我们需要一个特定意义的数组，每个单元是一个特殊含义（也就是有一个枚举做数组下标）。我们可以通过一个简单的前缀做到这点。

```
expand(HEROATTR) int heroattr;		// 英雄属性数组，根据HEROATTR展开
```

* **数组** - 类似protobuf的数组。

```
repeated HeroInfo lsthero;			// 英雄列表
```

基本变量类型：

* **int** - 整数，32位整数，有符号
* **int64** - 64位整数，有符号
* **time** - 时间戳，32位，最大到2038年
* **float** - 浮点数，32位
* **string** - 字符串，一般来说，不建议超过256字符
* **info** - 长字符串

例子：

```

int MAX_LEVEL = 80;			// 最大等级

typedef int HeroExpType;	// 英雄经验类型

// 英雄属性枚举，枚举必须大写，而且枚举内容必须是大写枚举加下划线开头
enum HEROATTR{
	HEROATTR_VIT = 0;	// 体力 - vitality
	HEROATTR_STA = 1;	// 耐力 - stamina
	HEROATTR_STR = 2;	// 力量 - strength
	HEROATTR_INT = 3;	// 智力 - intelligence
	HEROATTR_DEX = 4;	// 敏捷 - dexterity
	HEROATTR_CRIT = 5;	// 暴击 - critical		
	HEROATTR_PARR = 6;	// 格挡 - parry
	HEROATTR_HIT = 7;	// 命中 - hit
	HEROATTR_MISS = 8;	// 闪避 - miss
};

// 英雄技能枚举
enum HEROSKILL{
	HEROSKILL_SKILLID1 = 0;		// 普通技能1
	HEROSKILL_SKILLID2 = 1;		// 普通技能2
	HEROSKILL_SKILLID3 = 2;		// 普通技能3
	
	HEROSKILL_BSKILLID1 = 3;	// 条件技能1
	HEROSKILL_BSKILLID2 = 4;	// 条件技能2
	
	HEROSKILL_MSKILLID1 = 5;	// 主动技能1
};

// 玩家经验表
static PlayerExp{
	primary int playerlevel;	// 玩家等级
	
	index int totalplayerexp;	// 玩家当前等级需要的总经验（不算当前等级需要的经验）
	
	int playerexp;				// 玩家当前等级升级需要的经验
};

// 英雄经验表
static HeroExp{
	primary0 HeroExpType heroexptype;	// 英雄经验类型
	primary1 int herolevel;				// 英雄等级
	
	index int totalheroexp;				// 英雄当前等级需要的总经验（不算当前等级需要的经验）
	
	int heroexp;						// 英雄当前等级升级需要的经验
};

// 英雄基本配置表
static HeroBase{
	primary int heroid;					// 英雄唯一标识
	
	HeroExpType heroexptype;			// 英雄经验类型
	
	expand(HEROATTR) int heroattr;		// 英雄属性数组，根据HEROATTR展开
	expand(HEROSKILL) int heroskill;	// 英雄属性数组，根据HEROSKILL展开
};

// 英雄装备信息
struct HeroEquInfo{
	primary int equid;					// 装备唯一标识
};

// 英雄信息
struct HeroInfo{
	primary int heroid;					// 英雄唯一标识
	
	int herolevel;						// 英雄等级
	int heroexp;						// 英雄当前经验
	
	expand(HEROATTR) int heroattr;		// 英雄属性数组，根据HEROATTR展开
	expand(HEROSKILL) int heroskill;	// 英雄属性数组，根据HEROSKILL展开
	
	repeated HeroEquInfo lstequ;		// 英雄列表
};

// 角色基本信息
struct PlayerInfo{
	primary int pid;					// 角色唯一标识
	
	string name;						// 角色名
	time regtime;						// 注册时间
	time lastlogintime;					// 最后一次登录时间
	
	int playerlevel;					// 角色等级
	int playerexp;						// 角色经验
	
	int gold;							// 金币
	int gem;							// 钻石	
	
	repeated HeroInfo lsthero;			// 英雄列表
};

```


二次开发
---
ds-lang的二次开发有2种方式：

1. ds-lang是用jison生成的建模语言，相关的命令行工具和语法文件都是开源的，可以直接修改工具和语法文件获得新的支持。
2. ds-lang会生成一个json格式文件，这个文件其实是非常好读的，也可以基于这个输出文件做后续的二次开发。

如果你有更好的想法，也可以和我们联系。