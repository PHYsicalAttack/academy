--属性值
HP_PER_CON=10 				--每点体质增加hp值
NATT_PER_CON=1 				--每点体质增加普攻值
NDEF_PER_CON =1 			--每点体质增加普防值
MP_PER_SPIR = 5 			--每点精神增加mp值
SATT_PER_SPIR = 2.5  		--每点精神增加技能攻击值
SDEF_PER_SPIR = 1 			--每点精神增加技能防御值
BSPD_PER_AGIL = 4         	--每点敏捷增加战斗速度值
ACCU_PER_AGIL = 1   		--每点敏捷增加命中值，只有闪避时才额外计算
MISS_PER_AGIL = 1 			--每点敏捷增加闪避值
CRIT_PER_AGIL = 1 			--每点敏捷增加的暴击值
BASEEXP_LEVEL_NEED = 10 	--升级需要的基础经验
ADJEXP_LEVEL_NEED = 3 		--升级调整经验(adjexp*level)
BLENGTH = 100				--战斗回合距离值
MAX_ATTR_GAIN = 5   		--基础属性成长之和最大值
MAX_SKILL_NUM = 6 			--能获得的最大技能数
CRIT_MUTI = 2 				--暴击倍数
MAX_LAW = 100				--阵营值范围，目前人物阵营值会超出这个范围，
MIN_LAW = -100				--用来定义客观世界默认的最好和最坏
MAX_GOOD = 100				--同上
MIN_GOOD = -100				--同上



---常量
NATT = "NATT" 
SKILL_NATT_NAME = "普通攻击"
SATT = "SATT"
STORY_RESULT_PASS = "STORY_RESULT_PASS"
STORY_RESULT_FIGHT  = "STORY_RESULT_FIGHT"
FIGHT_RESULT_WIN = "FIGHT_RESULT_WIN"
FIGHT_RESULT_LOSE = "FIGHT_RESULT_LOSE"
SERIAL = {"①","②","③","④","⑤","⑥","⑦","⑧","⑨"}

--字符串颜色
STR_COLOR_FORMAT ="\27[%dm%s\27[0m"
STR_COLOR_BLACK = 30
STR_COLOR_RED = 31
STR_COLOR_GREEN = 32
STR_COLOR_YELLOW = 33
STR_COLOR_BLUE = 34
STR_COLOR_PURPLE = 35
STR_COLOR_DGREEN = 36
STR_COLOR_WHITE = 37

--控制码
ANSI_CLEAR = "\27[2J"
ANSI_CLEARFULL ="\27[2J\27[H"
ANSI_POS = "\27[%d;%dH"

--ASCII
SPACE = 32
UTF8SPACE = 12288




--异常提示
ERROR_MAX_SKILL_NUM = "你已拥有太多技能"
ERROR_DELETE_SKILL_NORM = "你无法删除普通攻击"
ERROR_DELETE_SKILL	="删除技能失败-未拥有改技能或其他未知原因"
ERROR_SAME_SKILL = "你已拥有这个技能"
ERROR_UNKNOW_DMGTYPE = "未知伤害类型"
ERROR_NOT_ENOUGH_MP = "魔法值不足"
ERROR_INVALID_CONFIG = "配置有误"
ERROR_INPUT_OUTOF_RANGE = "你的选择不在范围之中"

--其他字符串
WELCOME = [[
欢迎试玩【RE:学园都市】,嘿嘿嘿!
游戏须知:
1、属性加点和技能选择
2、行为选择尤其重要,有时候可以避免不需要的战斗~
3、同一时间只能获得一个有益和一个负面状态。
]]