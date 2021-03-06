--属性值(基础属性三种:体质、精神、敏捷)
INIT_ATTR = 15  			--初始属性
HP_PER_CON=10 				--每点体质增加hp值
NATT_PER_CON=1 				--每点体质增加普攻值
NDEF_PER_CON =1 			--每点体质增加普防值
MP_PER_SPIR = 5 			--每点精神增加mp值
SATT_PER_SPIR = 2 		 	--每点精神增加技能攻击值
SDEF_PER_SPIR = 1 			--每点精神增加技能防御值
BSPD_PER_AGIL = 4         	--每点敏捷增加战斗速度值
ACCU_PER_AGIL = 1   		--每点敏捷增加命中值，只有闪避时才额外计算
MISS_PER_AGIL = 1 			--每点敏捷增加闪避值
CRIT_PER_AGIL = 1 			--每点敏捷增加的暴击值
BLENGTH = 100				--战斗回合距离值
MAX_ATTR_GAIN = 7   		--基础属性成长之和最大值
MAX_SKILL_NUM = 6 			--能获得的最大技能数
CRIT_MUTI = 2 				--暴击倍数
MAX_LAW = 100				--阵营值范围，目前人物阵营值会超出这个范围，
MIN_LAW = -100				--用来定义客观世界默认的最好和最坏
MAX_GOOD = 100				--同上
MIN_GOOD = -100				--同上
LEVEL_TOTAL_EXP = {[1]=5,[2]=8,[3]=17,[4]=30,[5]=53,[6]=90,[7]=151,[8]=250,[9]=400,[10]=99999}  --等级对应的最大经验

---常量
NATT = "NATT"
SKILL_NATT_NAME = "普通攻击"
SATT = "SATT"
COMMONDELAY =1.3
FIRSTLEVEL = 1
STORY_RESULT_PASS = "STORY_RESULT_PASS"
STORY_RESULT_FIGHT  = "STORY_RESULT_FIGHT"
FIGHT_RESULT_WIN = "FIGHT_RESULT_WIN"
FIGHT_RESULT_LOSE = "FIGHT_RESULT_LOSE"
SERIAL = {"①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩","⑪","⑫","⑬","⑭","⑮","⑯"}

--战斗提示
FIGHT_MISS = "\27[33m闪避\27[0m"


--字符串颜色
STR_COLOR_FORMAT ="\27[%dm%s\27[0m"
STR_COLOR_BLACK = 30				--黑色
STR_COLOR_RED = 31 					--红色
STR_COLOR_GREEN = 32  				--深绿色
STR_COLOR_YELLOW = 33 				--橙色
STR_COLOR_BLUE = 34 				--紫蓝色
STR_COLOR_PURPLE = 35 				--紫色
STR_COLOR_DGREEN = 36    			--蓝绿色
STR_COLOR_WHITE = 37 				--白色

--控制码及显示相关
ANSI_CLEAR = "\27[2J"
ANSI_RESET_CLEAR ="\27[2J\27[H"
ANSI_POS = "\27[%d;%dH%s"
ANSI_CLEAR_CURL = "\027[K"
ANSI_MOVE_LEFT = "\027[nD"
SCREEN_WIDTH = 80
SCREEN_HEIGHT = 120

--ASCII
SPACE = 32
UTF8SPACE = 12288

--异常提示
ERROR_MAX_SKILL_NUM = "\27[31m你已拥有太多技能\27[0m"
ERROR_DELETE_SKILL_NORM = "\27[31m你无法删除普通攻击\27[0m"
ERROR_DELETE_SKILL	="\27[31m删除技能失败-未拥有该技能或其他未知原因\27[0m"
ERROR_SAME_SKILL = "\27[31m你已拥有这个技能\27[0m"
ERROR_NULL_SKILL = "\27[31m这个技能还未实现\27[0m"
ERROR_UNKNOW_DMGTYPE = "\27[31m未知伤害类型\27[0m"
ERROR_NOT_ENOUGH_MP = "\27[31m由于魔法值不足,可怜的你并没有放出任何技能……\27[0m"
ERROR_PASSIVE_SKILL = "\27[31m你不能使用一个被动技能\27[0m"
ERROR_INVALID_CONFIG = "\27[31m配置有误\27[0m"
ERROR_INPUT_OUTOF_RANGE = "\27[31m你的选择不在范围之中\27[0m"
ERROR_UNEQUAL_BUFF = "\27[31mbuffs表和bufftime表长度不一致\27[0m"





--其他字符串
WELCOME ="\n\z
\27[3B\27[10C\27[36m欢迎试玩【\27[35mRE:学园都市\27[36m】,嘿嘿嘿!\27[0m\n\n\z
\27[31m小提示:\27[0m\n\z
\27[37m1、属性加点和技能选择能给带来战斗的胜利。\n\z
2、行为选择有时候可以避免不需要的战斗~。\n\z
3、最多能同时拥有5个技能,等级最多10级。\n\z
4、每次失败后的reskill可以重新挑选技能,reborn则是从新建角色开始。\n\z
5、魔法值会在每回合开始时随机恢复。\n\z
6、游戏世界观基于《某科学的超电磁炮》系列，共有10个关卡。\n\z
7、请不要输入太快，有几率接收不到。\n\z
8、游戏环境mac、lua5.3.2。\n\z
9、作者拥有超能力心理测量lvl5。\n\z
\27[0m"

CREATEWORD="\27[32m请分配熟悉点至体质、精神、敏捷:\n\z
\27[37m每一点体质增加%s点生命，%s点普通伤害，%s点普通防御\n\z
每一点精神增加%s点魔法，%s点魔法伤害，%s点魔法防御\n\z
每一点敏捷增加%s点速度，%s点命中，%s点闪避，%s点暴击\27[0m"

MENTALITY={
--{"xxxxxxxxxx",addlaw,addgood}，现实是秩序的，但是不美好的，虚拟是非秩序的美好的
[1] = {"猫是可爱的动物吗?",-5,5},
[2] = {"你是否喜欢学园都市?",-10,10},
[3] = {"魔法是不是可靠的能力?",-10,5},
[4] = {"你是否想成为学园都市的一员?",-35,35},
[5] = {"你是否想成为风纪委员?",4,-4},
[6] = {"在学园都市中生活，你会感到安全吗?",-12,12},
[7] = {"你愿意保护学院都市吗?",-14,12},
[8] = {"幻想御手(levelupper)是否应该开发使用?",-10,-10},
[9] = {"学园都市lvl6研究开发是否应该继续?",-10,-10},
[10] = {"你是否想拥有超能力?",-10,5},
[11] = {"你愿意加入lvl超能力科学研究集团吗?",-10,-10},
[12] = {"你是否愿意将测试结果保密?",10,10}
}
--[[
Level 6 绝对能力者 200点满点 “以非神之躯，抵达神之领域者”，尚无人达到。 
Level 5 超能力者 199~190点 能单独对抗一个军队的程度。仅7人，但不乏其他有可能成为LV.5的人。 
Level 4 大能力者 189~150点 在军队中体现战术价值的程度。 
Level 3 强能力者 149~110点 日常生活中能得到活用、带来方便的程度。 
Level 2 异能力者 109~70点 稍微比Level 1有用的程度。 
Level 1 低能力者 69~30点 能勉强弄弯汤匙的程度，对日常生活基本没有帮助。 
Level 0 无能力者 29~0点 无法测量或效果极其微弱的能力。占全部学生60%
学园都市的大脑生理学专家，专攻领域是大脑生理学和AIM扩散力场，隶属于AIM解析研究所。“幻想御手”的开发者，引发“乱杂开放”的始作俑者。
拥有教师执照，过去曾是枝先绊理等“弃儿（又译抛弃物）”的老师。
性格阴沉，不知道在想些什么[2]  。平常看起来很像睡的样子，下眼睫毛相当浓密[3-4]  。
和本人对自己“缺乏起伏的肢体”认识相反，身材很好，容姿也不差，不过眼神阴暗有点可怕，是个性格令人无法捉摸的“残念美人”。
对在人前脱衣裙毫不在意，都市传说中“脱衣女”的正体。]]
