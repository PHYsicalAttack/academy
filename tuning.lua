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
MAX_SKILL_NUM = 4 			--能获得的最大技能数
---常量
NATT = "NATT" 
SATT = "SATT"


--异常提示
ERROR_MAX_SKILL_NUM = "你已拥有太多技能"
ERROR_DELETE_SKILL	="删除技能失败"
ERROR_SAME_SKILL = "你已拥有改技能"