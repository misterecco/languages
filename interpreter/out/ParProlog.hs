{-# OPTIONS_GHC -w #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParProlog where
import AbsProlog
import LexProlog
import ErrM
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 (String)
	| HappyAbsSyn5 (Integer)
	| HappyAbsSyn6 (Variable)
	| HappyAbsSyn7 (Woord)
	| HappyAbsSyn8 (Program)
	| HappyAbsSyn9 ([Sentence])
	| HappyAbsSyn10 (Sentence)
	| HappyAbsSyn11 (Clause)
	| HappyAbsSyn12 (Rule)
	| HappyAbsSyn13 (Unit_clause)
	| HappyAbsSyn14 (Directive)
	| HappyAbsSyn15 (Query)
	| HappyAbsSyn16 (Head)
	| HappyAbsSyn17 (Body)
	| HappyAbsSyn21 (Goal)
	| HappyAbsSyn22 (Term)
	| HappyAbsSyn36 ([Argument])
	| HappyAbsSyn37 (Argument)
	| HappyAbsSyn38 (List)
	| HappyAbsSyn39 (List_Expr)
	| HappyAbsSyn40 (Constant)
	| HappyAbsSyn41 (Number)
	| HappyAbsSyn42 (Atom)
	| HappyAbsSyn43 (Functoor)
	| HappyAbsSyn44 (Name)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117 :: () => Int -> ({-HappyReduction (Err) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76 :: () => ({-HappyReduction (Err) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

action_0 (45) = happyShift action_37
action_0 (50) = happyShift action_38
action_0 (53) = happyShift action_39
action_0 (62) = happyShift action_40
action_0 (63) = happyShift action_41
action_0 (72) = happyShift action_2
action_0 (73) = happyShift action_42
action_0 (74) = happyShift action_43
action_0 (75) = happyShift action_44
action_0 (4) = happyGoto action_3
action_0 (5) = happyGoto action_4
action_0 (6) = happyGoto action_5
action_0 (7) = happyGoto action_6
action_0 (8) = happyGoto action_7
action_0 (9) = happyGoto action_8
action_0 (10) = happyGoto action_9
action_0 (11) = happyGoto action_10
action_0 (12) = happyGoto action_11
action_0 (13) = happyGoto action_12
action_0 (14) = happyGoto action_13
action_0 (15) = happyGoto action_14
action_0 (16) = happyGoto action_15
action_0 (21) = happyGoto action_16
action_0 (22) = happyGoto action_17
action_0 (23) = happyGoto action_18
action_0 (24) = happyGoto action_19
action_0 (25) = happyGoto action_20
action_0 (26) = happyGoto action_21
action_0 (27) = happyGoto action_22
action_0 (28) = happyGoto action_23
action_0 (29) = happyGoto action_24
action_0 (30) = happyGoto action_25
action_0 (31) = happyGoto action_26
action_0 (32) = happyGoto action_27
action_0 (33) = happyGoto action_28
action_0 (34) = happyGoto action_29
action_0 (35) = happyGoto action_30
action_0 (38) = happyGoto action_31
action_0 (40) = happyGoto action_32
action_0 (41) = happyGoto action_33
action_0 (42) = happyGoto action_34
action_0 (43) = happyGoto action_35
action_0 (44) = happyGoto action_36
action_0 _ = happyFail

action_1 (72) = happyShift action_2
action_1 _ = happyFail

action_2 _ = happyReduce_1

action_3 _ = happyReduce_60

action_4 _ = happyReduce_73

action_5 _ = happyReduce_62

action_6 _ = happyReduce_76

action_7 (76) = happyAccept
action_7 _ = happyFail

action_8 _ = happyReduce_5

action_9 (51) = happyShift action_76
action_9 _ = happyFail

action_10 _ = happyReduce_8

action_11 _ = happyReduce_11

action_12 _ = happyReduce_12

action_13 _ = happyReduce_9

action_14 _ = happyReduce_10

action_15 (53) = happyShift action_75
action_15 _ = happyReduce_14

action_16 _ = happyReduce_17

action_17 _ = happyReduce_26

action_18 _ = happyReduce_27

action_19 _ = happyReduce_28

action_20 _ = happyReduce_29

action_21 _ = happyReduce_30

action_22 _ = happyReduce_31

action_23 _ = happyReduce_32

action_24 (54) = happyShift action_64
action_24 (55) = happyShift action_65
action_24 (56) = happyShift action_66
action_24 (57) = happyShift action_67
action_24 (58) = happyShift action_68
action_24 (59) = happyShift action_69
action_24 (60) = happyShift action_70
action_24 (61) = happyShift action_71
action_24 (65) = happyShift action_72
action_24 (66) = happyShift action_73
action_24 (69) = happyShift action_74
action_24 _ = happyReduce_33

action_25 (48) = happyShift action_62
action_25 (50) = happyShift action_63
action_25 _ = happyReduce_45

action_26 (47) = happyShift action_59
action_26 (52) = happyShift action_60
action_26 (70) = happyShift action_61
action_26 _ = happyReduce_46

action_27 _ = happyReduce_49

action_28 _ = happyReduce_53

action_29 _ = happyReduce_54

action_30 _ = happyReduce_56

action_31 _ = happyReduce_59

action_32 _ = happyReduce_61

action_33 _ = happyReduce_72

action_34 _ = happyReduce_71

action_35 (45) = happyShift action_58
action_35 _ = happyFail

action_36 (46) = happyReduce_74
action_36 (47) = happyReduce_74
action_36 (48) = happyReduce_74
action_36 (49) = happyReduce_74
action_36 (50) = happyReduce_74
action_36 (51) = happyReduce_74
action_36 (52) = happyReduce_74
action_36 (53) = happyReduce_74
action_36 (54) = happyReduce_74
action_36 (55) = happyReduce_74
action_36 (56) = happyReduce_74
action_36 (57) = happyReduce_74
action_36 (58) = happyReduce_74
action_36 (59) = happyReduce_74
action_36 (60) = happyReduce_74
action_36 (61) = happyReduce_74
action_36 (65) = happyReduce_74
action_36 (66) = happyReduce_74
action_36 (67) = happyReduce_74
action_36 (69) = happyReduce_74
action_36 (70) = happyReduce_74
action_36 (71) = happyReduce_74
action_36 _ = happyReduce_75

action_37 (45) = happyShift action_37
action_37 (50) = happyShift action_38
action_37 (63) = happyShift action_41
action_37 (72) = happyShift action_2
action_37 (73) = happyShift action_42
action_37 (74) = happyShift action_43
action_37 (75) = happyShift action_44
action_37 (4) = happyGoto action_3
action_37 (5) = happyGoto action_4
action_37 (6) = happyGoto action_5
action_37 (7) = happyGoto action_6
action_37 (23) = happyGoto action_57
action_37 (24) = happyGoto action_19
action_37 (25) = happyGoto action_20
action_37 (26) = happyGoto action_21
action_37 (27) = happyGoto action_22
action_37 (28) = happyGoto action_23
action_37 (29) = happyGoto action_24
action_37 (30) = happyGoto action_25
action_37 (31) = happyGoto action_26
action_37 (32) = happyGoto action_27
action_37 (33) = happyGoto action_28
action_37 (34) = happyGoto action_29
action_37 (35) = happyGoto action_30
action_37 (38) = happyGoto action_31
action_37 (40) = happyGoto action_32
action_37 (41) = happyGoto action_33
action_37 (42) = happyGoto action_34
action_37 (43) = happyGoto action_35
action_37 (44) = happyGoto action_36
action_37 _ = happyFail

action_38 (45) = happyShift action_37
action_38 (50) = happyShift action_38
action_38 (63) = happyShift action_41
action_38 (72) = happyShift action_2
action_38 (73) = happyShift action_42
action_38 (74) = happyShift action_43
action_38 (75) = happyShift action_44
action_38 (4) = happyGoto action_3
action_38 (5) = happyGoto action_4
action_38 (6) = happyGoto action_5
action_38 (7) = happyGoto action_6
action_38 (33) = happyGoto action_56
action_38 (34) = happyGoto action_29
action_38 (35) = happyGoto action_30
action_38 (38) = happyGoto action_31
action_38 (40) = happyGoto action_32
action_38 (41) = happyGoto action_33
action_38 (42) = happyGoto action_34
action_38 (43) = happyGoto action_35
action_38 (44) = happyGoto action_36
action_38 _ = happyFail

action_39 (45) = happyShift action_37
action_39 (50) = happyShift action_38
action_39 (63) = happyShift action_41
action_39 (64) = happyShift action_53
action_39 (68) = happyShift action_54
action_39 (72) = happyShift action_2
action_39 (73) = happyShift action_42
action_39 (74) = happyShift action_43
action_39 (75) = happyShift action_44
action_39 (4) = happyGoto action_3
action_39 (5) = happyGoto action_4
action_39 (6) = happyGoto action_5
action_39 (7) = happyGoto action_6
action_39 (17) = happyGoto action_55
action_39 (18) = happyGoto action_49
action_39 (19) = happyGoto action_50
action_39 (20) = happyGoto action_51
action_39 (21) = happyGoto action_52
action_39 (22) = happyGoto action_17
action_39 (23) = happyGoto action_18
action_39 (24) = happyGoto action_19
action_39 (25) = happyGoto action_20
action_39 (26) = happyGoto action_21
action_39 (27) = happyGoto action_22
action_39 (28) = happyGoto action_23
action_39 (29) = happyGoto action_24
action_39 (30) = happyGoto action_25
action_39 (31) = happyGoto action_26
action_39 (32) = happyGoto action_27
action_39 (33) = happyGoto action_28
action_39 (34) = happyGoto action_29
action_39 (35) = happyGoto action_30
action_39 (38) = happyGoto action_31
action_39 (40) = happyGoto action_32
action_39 (41) = happyGoto action_33
action_39 (42) = happyGoto action_34
action_39 (43) = happyGoto action_35
action_39 (44) = happyGoto action_36
action_39 _ = happyReduce_18

action_40 (45) = happyShift action_37
action_40 (50) = happyShift action_38
action_40 (63) = happyShift action_41
action_40 (64) = happyShift action_53
action_40 (68) = happyShift action_54
action_40 (72) = happyShift action_2
action_40 (73) = happyShift action_42
action_40 (74) = happyShift action_43
action_40 (75) = happyShift action_44
action_40 (4) = happyGoto action_3
action_40 (5) = happyGoto action_4
action_40 (6) = happyGoto action_5
action_40 (7) = happyGoto action_6
action_40 (17) = happyGoto action_48
action_40 (18) = happyGoto action_49
action_40 (19) = happyGoto action_50
action_40 (20) = happyGoto action_51
action_40 (21) = happyGoto action_52
action_40 (22) = happyGoto action_17
action_40 (23) = happyGoto action_18
action_40 (24) = happyGoto action_19
action_40 (25) = happyGoto action_20
action_40 (26) = happyGoto action_21
action_40 (27) = happyGoto action_22
action_40 (28) = happyGoto action_23
action_40 (29) = happyGoto action_24
action_40 (30) = happyGoto action_25
action_40 (31) = happyGoto action_26
action_40 (32) = happyGoto action_27
action_40 (33) = happyGoto action_28
action_40 (34) = happyGoto action_29
action_40 (35) = happyGoto action_30
action_40 (38) = happyGoto action_31
action_40 (40) = happyGoto action_32
action_40 (41) = happyGoto action_33
action_40 (42) = happyGoto action_34
action_40 (43) = happyGoto action_35
action_40 (44) = happyGoto action_36
action_40 _ = happyReduce_18

action_41 (45) = happyShift action_37
action_41 (50) = happyShift action_38
action_41 (63) = happyShift action_41
action_41 (67) = happyShift action_47
action_41 (72) = happyShift action_2
action_41 (73) = happyShift action_42
action_41 (74) = happyShift action_43
action_41 (75) = happyShift action_44
action_41 (4) = happyGoto action_3
action_41 (5) = happyGoto action_4
action_41 (6) = happyGoto action_5
action_41 (7) = happyGoto action_6
action_41 (26) = happyGoto action_45
action_41 (27) = happyGoto action_22
action_41 (28) = happyGoto action_23
action_41 (29) = happyGoto action_24
action_41 (30) = happyGoto action_25
action_41 (31) = happyGoto action_26
action_41 (32) = happyGoto action_27
action_41 (33) = happyGoto action_28
action_41 (34) = happyGoto action_29
action_41 (35) = happyGoto action_30
action_41 (38) = happyGoto action_31
action_41 (39) = happyGoto action_46
action_41 (40) = happyGoto action_32
action_41 (41) = happyGoto action_33
action_41 (42) = happyGoto action_34
action_41 (43) = happyGoto action_35
action_41 (44) = happyGoto action_36
action_41 _ = happyFail

action_42 _ = happyReduce_2

action_43 _ = happyReduce_3

action_44 _ = happyReduce_4

action_45 (49) = happyShift action_104
action_45 (71) = happyShift action_105
action_45 _ = happyReduce_68

action_46 (67) = happyShift action_103
action_46 _ = happyFail

action_47 _ = happyReduce_66

action_48 _ = happyReduce_16

action_49 _ = happyReduce_22

action_50 (49) = happyShift action_102
action_50 _ = happyReduce_23

action_51 _ = happyReduce_24

action_52 _ = happyReduce_25

action_53 (45) = happyShift action_37
action_53 (50) = happyShift action_38
action_53 (63) = happyShift action_41
action_53 (72) = happyShift action_2
action_53 (73) = happyShift action_42
action_53 (74) = happyShift action_43
action_53 (75) = happyShift action_44
action_53 (4) = happyGoto action_3
action_53 (5) = happyGoto action_4
action_53 (6) = happyGoto action_5
action_53 (7) = happyGoto action_6
action_53 (18) = happyGoto action_100
action_53 (19) = happyGoto action_101
action_53 (20) = happyGoto action_51
action_53 (21) = happyGoto action_52
action_53 (22) = happyGoto action_17
action_53 (23) = happyGoto action_18
action_53 (24) = happyGoto action_19
action_53 (25) = happyGoto action_20
action_53 (26) = happyGoto action_21
action_53 (27) = happyGoto action_22
action_53 (28) = happyGoto action_23
action_53 (29) = happyGoto action_24
action_53 (30) = happyGoto action_25
action_53 (31) = happyGoto action_26
action_53 (32) = happyGoto action_27
action_53 (33) = happyGoto action_28
action_53 (34) = happyGoto action_29
action_53 (35) = happyGoto action_30
action_53 (38) = happyGoto action_31
action_53 (40) = happyGoto action_32
action_53 (41) = happyGoto action_33
action_53 (42) = happyGoto action_34
action_53 (43) = happyGoto action_35
action_53 (44) = happyGoto action_36
action_53 _ = happyFail

action_54 (45) = happyShift action_99
action_54 _ = happyFail

action_55 _ = happyReduce_15

action_56 _ = happyReduce_55

action_57 (46) = happyShift action_98
action_57 _ = happyFail

action_58 (45) = happyShift action_37
action_58 (50) = happyShift action_38
action_58 (63) = happyShift action_41
action_58 (72) = happyShift action_2
action_58 (73) = happyShift action_42
action_58 (74) = happyShift action_43
action_58 (75) = happyShift action_44
action_58 (4) = happyGoto action_3
action_58 (5) = happyGoto action_4
action_58 (6) = happyGoto action_5
action_58 (7) = happyGoto action_6
action_58 (26) = happyGoto action_95
action_58 (27) = happyGoto action_22
action_58 (28) = happyGoto action_23
action_58 (29) = happyGoto action_24
action_58 (30) = happyGoto action_25
action_58 (31) = happyGoto action_26
action_58 (32) = happyGoto action_27
action_58 (33) = happyGoto action_28
action_58 (34) = happyGoto action_29
action_58 (35) = happyGoto action_30
action_58 (36) = happyGoto action_96
action_58 (37) = happyGoto action_97
action_58 (38) = happyGoto action_31
action_58 (40) = happyGoto action_32
action_58 (41) = happyGoto action_33
action_58 (42) = happyGoto action_34
action_58 (43) = happyGoto action_35
action_58 (44) = happyGoto action_36
action_58 _ = happyFail

action_59 (45) = happyShift action_37
action_59 (50) = happyShift action_38
action_59 (63) = happyShift action_41
action_59 (72) = happyShift action_2
action_59 (73) = happyShift action_42
action_59 (74) = happyShift action_43
action_59 (75) = happyShift action_44
action_59 (4) = happyGoto action_3
action_59 (5) = happyGoto action_4
action_59 (6) = happyGoto action_5
action_59 (7) = happyGoto action_6
action_59 (32) = happyGoto action_94
action_59 (33) = happyGoto action_28
action_59 (34) = happyGoto action_29
action_59 (35) = happyGoto action_30
action_59 (38) = happyGoto action_31
action_59 (40) = happyGoto action_32
action_59 (41) = happyGoto action_33
action_59 (42) = happyGoto action_34
action_59 (43) = happyGoto action_35
action_59 (44) = happyGoto action_36
action_59 _ = happyFail

action_60 (45) = happyShift action_37
action_60 (50) = happyShift action_38
action_60 (63) = happyShift action_41
action_60 (72) = happyShift action_2
action_60 (73) = happyShift action_42
action_60 (74) = happyShift action_43
action_60 (75) = happyShift action_44
action_60 (4) = happyGoto action_3
action_60 (5) = happyGoto action_4
action_60 (6) = happyGoto action_5
action_60 (7) = happyGoto action_6
action_60 (32) = happyGoto action_93
action_60 (33) = happyGoto action_28
action_60 (34) = happyGoto action_29
action_60 (35) = happyGoto action_30
action_60 (38) = happyGoto action_31
action_60 (40) = happyGoto action_32
action_60 (41) = happyGoto action_33
action_60 (42) = happyGoto action_34
action_60 (43) = happyGoto action_35
action_60 (44) = happyGoto action_36
action_60 _ = happyFail

action_61 (45) = happyShift action_37
action_61 (50) = happyShift action_38
action_61 (63) = happyShift action_41
action_61 (72) = happyShift action_2
action_61 (73) = happyShift action_42
action_61 (74) = happyShift action_43
action_61 (75) = happyShift action_44
action_61 (4) = happyGoto action_3
action_61 (5) = happyGoto action_4
action_61 (6) = happyGoto action_5
action_61 (7) = happyGoto action_6
action_61 (32) = happyGoto action_92
action_61 (33) = happyGoto action_28
action_61 (34) = happyGoto action_29
action_61 (35) = happyGoto action_30
action_61 (38) = happyGoto action_31
action_61 (40) = happyGoto action_32
action_61 (41) = happyGoto action_33
action_61 (42) = happyGoto action_34
action_61 (43) = happyGoto action_35
action_61 (44) = happyGoto action_36
action_61 _ = happyFail

action_62 (45) = happyShift action_37
action_62 (50) = happyShift action_38
action_62 (63) = happyShift action_41
action_62 (72) = happyShift action_2
action_62 (73) = happyShift action_42
action_62 (74) = happyShift action_43
action_62 (75) = happyShift action_44
action_62 (4) = happyGoto action_3
action_62 (5) = happyGoto action_4
action_62 (6) = happyGoto action_5
action_62 (7) = happyGoto action_6
action_62 (31) = happyGoto action_91
action_62 (32) = happyGoto action_27
action_62 (33) = happyGoto action_28
action_62 (34) = happyGoto action_29
action_62 (35) = happyGoto action_30
action_62 (38) = happyGoto action_31
action_62 (40) = happyGoto action_32
action_62 (41) = happyGoto action_33
action_62 (42) = happyGoto action_34
action_62 (43) = happyGoto action_35
action_62 (44) = happyGoto action_36
action_62 _ = happyFail

action_63 (45) = happyShift action_37
action_63 (50) = happyShift action_38
action_63 (63) = happyShift action_41
action_63 (72) = happyShift action_2
action_63 (73) = happyShift action_42
action_63 (74) = happyShift action_43
action_63 (75) = happyShift action_44
action_63 (4) = happyGoto action_3
action_63 (5) = happyGoto action_4
action_63 (6) = happyGoto action_5
action_63 (7) = happyGoto action_6
action_63 (31) = happyGoto action_90
action_63 (32) = happyGoto action_27
action_63 (33) = happyGoto action_28
action_63 (34) = happyGoto action_29
action_63 (35) = happyGoto action_30
action_63 (38) = happyGoto action_31
action_63 (40) = happyGoto action_32
action_63 (41) = happyGoto action_33
action_63 (42) = happyGoto action_34
action_63 (43) = happyGoto action_35
action_63 (44) = happyGoto action_36
action_63 _ = happyFail

action_64 (45) = happyShift action_37
action_64 (50) = happyShift action_38
action_64 (63) = happyShift action_41
action_64 (72) = happyShift action_2
action_64 (73) = happyShift action_42
action_64 (74) = happyShift action_43
action_64 (75) = happyShift action_44
action_64 (4) = happyGoto action_3
action_64 (5) = happyGoto action_4
action_64 (6) = happyGoto action_5
action_64 (7) = happyGoto action_6
action_64 (29) = happyGoto action_89
action_64 (30) = happyGoto action_25
action_64 (31) = happyGoto action_26
action_64 (32) = happyGoto action_27
action_64 (33) = happyGoto action_28
action_64 (34) = happyGoto action_29
action_64 (35) = happyGoto action_30
action_64 (38) = happyGoto action_31
action_64 (40) = happyGoto action_32
action_64 (41) = happyGoto action_33
action_64 (42) = happyGoto action_34
action_64 (43) = happyGoto action_35
action_64 (44) = happyGoto action_36
action_64 _ = happyFail

action_65 (45) = happyShift action_37
action_65 (50) = happyShift action_38
action_65 (63) = happyShift action_41
action_65 (72) = happyShift action_2
action_65 (73) = happyShift action_42
action_65 (74) = happyShift action_43
action_65 (75) = happyShift action_44
action_65 (4) = happyGoto action_3
action_65 (5) = happyGoto action_4
action_65 (6) = happyGoto action_5
action_65 (7) = happyGoto action_6
action_65 (29) = happyGoto action_88
action_65 (30) = happyGoto action_25
action_65 (31) = happyGoto action_26
action_65 (32) = happyGoto action_27
action_65 (33) = happyGoto action_28
action_65 (34) = happyGoto action_29
action_65 (35) = happyGoto action_30
action_65 (38) = happyGoto action_31
action_65 (40) = happyGoto action_32
action_65 (41) = happyGoto action_33
action_65 (42) = happyGoto action_34
action_65 (43) = happyGoto action_35
action_65 (44) = happyGoto action_36
action_65 _ = happyFail

action_66 (45) = happyShift action_37
action_66 (50) = happyShift action_38
action_66 (63) = happyShift action_41
action_66 (72) = happyShift action_2
action_66 (73) = happyShift action_42
action_66 (74) = happyShift action_43
action_66 (75) = happyShift action_44
action_66 (4) = happyGoto action_3
action_66 (5) = happyGoto action_4
action_66 (6) = happyGoto action_5
action_66 (7) = happyGoto action_6
action_66 (29) = happyGoto action_87
action_66 (30) = happyGoto action_25
action_66 (31) = happyGoto action_26
action_66 (32) = happyGoto action_27
action_66 (33) = happyGoto action_28
action_66 (34) = happyGoto action_29
action_66 (35) = happyGoto action_30
action_66 (38) = happyGoto action_31
action_66 (40) = happyGoto action_32
action_66 (41) = happyGoto action_33
action_66 (42) = happyGoto action_34
action_66 (43) = happyGoto action_35
action_66 (44) = happyGoto action_36
action_66 _ = happyFail

action_67 (45) = happyShift action_37
action_67 (50) = happyShift action_38
action_67 (63) = happyShift action_41
action_67 (72) = happyShift action_2
action_67 (73) = happyShift action_42
action_67 (74) = happyShift action_43
action_67 (75) = happyShift action_44
action_67 (4) = happyGoto action_3
action_67 (5) = happyGoto action_4
action_67 (6) = happyGoto action_5
action_67 (7) = happyGoto action_6
action_67 (29) = happyGoto action_86
action_67 (30) = happyGoto action_25
action_67 (31) = happyGoto action_26
action_67 (32) = happyGoto action_27
action_67 (33) = happyGoto action_28
action_67 (34) = happyGoto action_29
action_67 (35) = happyGoto action_30
action_67 (38) = happyGoto action_31
action_67 (40) = happyGoto action_32
action_67 (41) = happyGoto action_33
action_67 (42) = happyGoto action_34
action_67 (43) = happyGoto action_35
action_67 (44) = happyGoto action_36
action_67 _ = happyFail

action_68 (45) = happyShift action_37
action_68 (50) = happyShift action_38
action_68 (63) = happyShift action_41
action_68 (72) = happyShift action_2
action_68 (73) = happyShift action_42
action_68 (74) = happyShift action_43
action_68 (75) = happyShift action_44
action_68 (4) = happyGoto action_3
action_68 (5) = happyGoto action_4
action_68 (6) = happyGoto action_5
action_68 (7) = happyGoto action_6
action_68 (29) = happyGoto action_85
action_68 (30) = happyGoto action_25
action_68 (31) = happyGoto action_26
action_68 (32) = happyGoto action_27
action_68 (33) = happyGoto action_28
action_68 (34) = happyGoto action_29
action_68 (35) = happyGoto action_30
action_68 (38) = happyGoto action_31
action_68 (40) = happyGoto action_32
action_68 (41) = happyGoto action_33
action_68 (42) = happyGoto action_34
action_68 (43) = happyGoto action_35
action_68 (44) = happyGoto action_36
action_68 _ = happyFail

action_69 (45) = happyShift action_37
action_69 (50) = happyShift action_38
action_69 (63) = happyShift action_41
action_69 (72) = happyShift action_2
action_69 (73) = happyShift action_42
action_69 (74) = happyShift action_43
action_69 (75) = happyShift action_44
action_69 (4) = happyGoto action_3
action_69 (5) = happyGoto action_4
action_69 (6) = happyGoto action_5
action_69 (7) = happyGoto action_6
action_69 (29) = happyGoto action_84
action_69 (30) = happyGoto action_25
action_69 (31) = happyGoto action_26
action_69 (32) = happyGoto action_27
action_69 (33) = happyGoto action_28
action_69 (34) = happyGoto action_29
action_69 (35) = happyGoto action_30
action_69 (38) = happyGoto action_31
action_69 (40) = happyGoto action_32
action_69 (41) = happyGoto action_33
action_69 (42) = happyGoto action_34
action_69 (43) = happyGoto action_35
action_69 (44) = happyGoto action_36
action_69 _ = happyFail

action_70 (45) = happyShift action_37
action_70 (50) = happyShift action_38
action_70 (63) = happyShift action_41
action_70 (72) = happyShift action_2
action_70 (73) = happyShift action_42
action_70 (74) = happyShift action_43
action_70 (75) = happyShift action_44
action_70 (4) = happyGoto action_3
action_70 (5) = happyGoto action_4
action_70 (6) = happyGoto action_5
action_70 (7) = happyGoto action_6
action_70 (29) = happyGoto action_83
action_70 (30) = happyGoto action_25
action_70 (31) = happyGoto action_26
action_70 (32) = happyGoto action_27
action_70 (33) = happyGoto action_28
action_70 (34) = happyGoto action_29
action_70 (35) = happyGoto action_30
action_70 (38) = happyGoto action_31
action_70 (40) = happyGoto action_32
action_70 (41) = happyGoto action_33
action_70 (42) = happyGoto action_34
action_70 (43) = happyGoto action_35
action_70 (44) = happyGoto action_36
action_70 _ = happyFail

action_71 (45) = happyShift action_37
action_71 (50) = happyShift action_38
action_71 (63) = happyShift action_41
action_71 (72) = happyShift action_2
action_71 (73) = happyShift action_42
action_71 (74) = happyShift action_43
action_71 (75) = happyShift action_44
action_71 (4) = happyGoto action_3
action_71 (5) = happyGoto action_4
action_71 (6) = happyGoto action_5
action_71 (7) = happyGoto action_6
action_71 (29) = happyGoto action_82
action_71 (30) = happyGoto action_25
action_71 (31) = happyGoto action_26
action_71 (32) = happyGoto action_27
action_71 (33) = happyGoto action_28
action_71 (34) = happyGoto action_29
action_71 (35) = happyGoto action_30
action_71 (38) = happyGoto action_31
action_71 (40) = happyGoto action_32
action_71 (41) = happyGoto action_33
action_71 (42) = happyGoto action_34
action_71 (43) = happyGoto action_35
action_71 (44) = happyGoto action_36
action_71 _ = happyFail

action_72 (45) = happyShift action_37
action_72 (50) = happyShift action_38
action_72 (63) = happyShift action_41
action_72 (72) = happyShift action_2
action_72 (73) = happyShift action_42
action_72 (74) = happyShift action_43
action_72 (75) = happyShift action_44
action_72 (4) = happyGoto action_3
action_72 (5) = happyGoto action_4
action_72 (6) = happyGoto action_5
action_72 (7) = happyGoto action_6
action_72 (29) = happyGoto action_81
action_72 (30) = happyGoto action_25
action_72 (31) = happyGoto action_26
action_72 (32) = happyGoto action_27
action_72 (33) = happyGoto action_28
action_72 (34) = happyGoto action_29
action_72 (35) = happyGoto action_30
action_72 (38) = happyGoto action_31
action_72 (40) = happyGoto action_32
action_72 (41) = happyGoto action_33
action_72 (42) = happyGoto action_34
action_72 (43) = happyGoto action_35
action_72 (44) = happyGoto action_36
action_72 _ = happyFail

action_73 (45) = happyShift action_37
action_73 (50) = happyShift action_38
action_73 (63) = happyShift action_41
action_73 (72) = happyShift action_2
action_73 (73) = happyShift action_42
action_73 (74) = happyShift action_43
action_73 (75) = happyShift action_44
action_73 (4) = happyGoto action_3
action_73 (5) = happyGoto action_4
action_73 (6) = happyGoto action_5
action_73 (7) = happyGoto action_6
action_73 (29) = happyGoto action_80
action_73 (30) = happyGoto action_25
action_73 (31) = happyGoto action_26
action_73 (32) = happyGoto action_27
action_73 (33) = happyGoto action_28
action_73 (34) = happyGoto action_29
action_73 (35) = happyGoto action_30
action_73 (38) = happyGoto action_31
action_73 (40) = happyGoto action_32
action_73 (41) = happyGoto action_33
action_73 (42) = happyGoto action_34
action_73 (43) = happyGoto action_35
action_73 (44) = happyGoto action_36
action_73 _ = happyFail

action_74 (45) = happyShift action_37
action_74 (50) = happyShift action_38
action_74 (63) = happyShift action_41
action_74 (72) = happyShift action_2
action_74 (73) = happyShift action_42
action_74 (74) = happyShift action_43
action_74 (75) = happyShift action_44
action_74 (4) = happyGoto action_3
action_74 (5) = happyGoto action_4
action_74 (6) = happyGoto action_5
action_74 (7) = happyGoto action_6
action_74 (29) = happyGoto action_79
action_74 (30) = happyGoto action_25
action_74 (31) = happyGoto action_26
action_74 (32) = happyGoto action_27
action_74 (33) = happyGoto action_28
action_74 (34) = happyGoto action_29
action_74 (35) = happyGoto action_30
action_74 (38) = happyGoto action_31
action_74 (40) = happyGoto action_32
action_74 (41) = happyGoto action_33
action_74 (42) = happyGoto action_34
action_74 (43) = happyGoto action_35
action_74 (44) = happyGoto action_36
action_74 _ = happyFail

action_75 (45) = happyShift action_37
action_75 (50) = happyShift action_38
action_75 (63) = happyShift action_41
action_75 (64) = happyShift action_53
action_75 (68) = happyShift action_54
action_75 (72) = happyShift action_2
action_75 (73) = happyShift action_42
action_75 (74) = happyShift action_43
action_75 (75) = happyShift action_44
action_75 (4) = happyGoto action_3
action_75 (5) = happyGoto action_4
action_75 (6) = happyGoto action_5
action_75 (7) = happyGoto action_6
action_75 (17) = happyGoto action_78
action_75 (18) = happyGoto action_49
action_75 (19) = happyGoto action_50
action_75 (20) = happyGoto action_51
action_75 (21) = happyGoto action_52
action_75 (22) = happyGoto action_17
action_75 (23) = happyGoto action_18
action_75 (24) = happyGoto action_19
action_75 (25) = happyGoto action_20
action_75 (26) = happyGoto action_21
action_75 (27) = happyGoto action_22
action_75 (28) = happyGoto action_23
action_75 (29) = happyGoto action_24
action_75 (30) = happyGoto action_25
action_75 (31) = happyGoto action_26
action_75 (32) = happyGoto action_27
action_75 (33) = happyGoto action_28
action_75 (34) = happyGoto action_29
action_75 (35) = happyGoto action_30
action_75 (38) = happyGoto action_31
action_75 (40) = happyGoto action_32
action_75 (41) = happyGoto action_33
action_75 (42) = happyGoto action_34
action_75 (43) = happyGoto action_35
action_75 (44) = happyGoto action_36
action_75 _ = happyReduce_18

action_76 (45) = happyShift action_37
action_76 (50) = happyShift action_38
action_76 (53) = happyShift action_39
action_76 (62) = happyShift action_40
action_76 (63) = happyShift action_41
action_76 (72) = happyShift action_2
action_76 (73) = happyShift action_42
action_76 (74) = happyShift action_43
action_76 (75) = happyShift action_44
action_76 (4) = happyGoto action_3
action_76 (5) = happyGoto action_4
action_76 (6) = happyGoto action_5
action_76 (7) = happyGoto action_6
action_76 (9) = happyGoto action_77
action_76 (10) = happyGoto action_9
action_76 (11) = happyGoto action_10
action_76 (12) = happyGoto action_11
action_76 (13) = happyGoto action_12
action_76 (14) = happyGoto action_13
action_76 (15) = happyGoto action_14
action_76 (16) = happyGoto action_15
action_76 (21) = happyGoto action_16
action_76 (22) = happyGoto action_17
action_76 (23) = happyGoto action_18
action_76 (24) = happyGoto action_19
action_76 (25) = happyGoto action_20
action_76 (26) = happyGoto action_21
action_76 (27) = happyGoto action_22
action_76 (28) = happyGoto action_23
action_76 (29) = happyGoto action_24
action_76 (30) = happyGoto action_25
action_76 (31) = happyGoto action_26
action_76 (32) = happyGoto action_27
action_76 (33) = happyGoto action_28
action_76 (34) = happyGoto action_29
action_76 (35) = happyGoto action_30
action_76 (38) = happyGoto action_31
action_76 (40) = happyGoto action_32
action_76 (41) = happyGoto action_33
action_76 (42) = happyGoto action_34
action_76 (43) = happyGoto action_35
action_76 (44) = happyGoto action_36
action_76 _ = happyReduce_6

action_77 _ = happyReduce_7

action_78 _ = happyReduce_13

action_79 _ = happyReduce_38

action_80 _ = happyReduce_37

action_81 _ = happyReduce_35

action_82 _ = happyReduce_44

action_83 _ = happyReduce_42

action_84 _ = happyReduce_40

action_85 _ = happyReduce_36

action_86 _ = happyReduce_43

action_87 _ = happyReduce_39

action_88 _ = happyReduce_34

action_89 _ = happyReduce_41

action_90 (47) = happyShift action_59
action_90 (52) = happyShift action_60
action_90 (70) = happyShift action_61
action_90 _ = happyReduce_48

action_91 (47) = happyShift action_59
action_91 (52) = happyShift action_60
action_91 (70) = happyShift action_61
action_91 _ = happyReduce_47

action_92 _ = happyReduce_52

action_93 _ = happyReduce_51

action_94 _ = happyReduce_50

action_95 _ = happyReduce_65

action_96 (46) = happyShift action_111
action_96 _ = happyFail

action_97 (49) = happyShift action_110
action_97 _ = happyReduce_63

action_98 _ = happyReduce_58

action_99 (45) = happyShift action_37
action_99 (50) = happyShift action_38
action_99 (63) = happyShift action_41
action_99 (72) = happyShift action_2
action_99 (73) = happyShift action_42
action_99 (74) = happyShift action_43
action_99 (75) = happyShift action_44
action_99 (4) = happyGoto action_3
action_99 (5) = happyGoto action_4
action_99 (6) = happyGoto action_5
action_99 (7) = happyGoto action_6
action_99 (19) = happyGoto action_109
action_99 (20) = happyGoto action_51
action_99 (21) = happyGoto action_52
action_99 (22) = happyGoto action_17
action_99 (23) = happyGoto action_18
action_99 (24) = happyGoto action_19
action_99 (25) = happyGoto action_20
action_99 (26) = happyGoto action_21
action_99 (27) = happyGoto action_22
action_99 (28) = happyGoto action_23
action_99 (29) = happyGoto action_24
action_99 (30) = happyGoto action_25
action_99 (31) = happyGoto action_26
action_99 (32) = happyGoto action_27
action_99 (33) = happyGoto action_28
action_99 (34) = happyGoto action_29
action_99 (35) = happyGoto action_30
action_99 (38) = happyGoto action_31
action_99 (40) = happyGoto action_32
action_99 (41) = happyGoto action_33
action_99 (42) = happyGoto action_34
action_99 (43) = happyGoto action_35
action_99 (44) = happyGoto action_36
action_99 _ = happyFail

action_100 _ = happyReduce_19

action_101 _ = happyReduce_23

action_102 (45) = happyShift action_37
action_102 (50) = happyShift action_38
action_102 (63) = happyShift action_41
action_102 (64) = happyShift action_53
action_102 (68) = happyShift action_54
action_102 (72) = happyShift action_2
action_102 (73) = happyShift action_42
action_102 (74) = happyShift action_43
action_102 (75) = happyShift action_44
action_102 (4) = happyGoto action_3
action_102 (5) = happyGoto action_4
action_102 (6) = happyGoto action_5
action_102 (7) = happyGoto action_6
action_102 (17) = happyGoto action_108
action_102 (18) = happyGoto action_49
action_102 (19) = happyGoto action_50
action_102 (20) = happyGoto action_51
action_102 (21) = happyGoto action_52
action_102 (22) = happyGoto action_17
action_102 (23) = happyGoto action_18
action_102 (24) = happyGoto action_19
action_102 (25) = happyGoto action_20
action_102 (26) = happyGoto action_21
action_102 (27) = happyGoto action_22
action_102 (28) = happyGoto action_23
action_102 (29) = happyGoto action_24
action_102 (30) = happyGoto action_25
action_102 (31) = happyGoto action_26
action_102 (32) = happyGoto action_27
action_102 (33) = happyGoto action_28
action_102 (34) = happyGoto action_29
action_102 (35) = happyGoto action_30
action_102 (38) = happyGoto action_31
action_102 (40) = happyGoto action_32
action_102 (41) = happyGoto action_33
action_102 (42) = happyGoto action_34
action_102 (43) = happyGoto action_35
action_102 (44) = happyGoto action_36
action_102 _ = happyReduce_18

action_103 _ = happyReduce_67

action_104 (45) = happyShift action_37
action_104 (50) = happyShift action_38
action_104 (63) = happyShift action_41
action_104 (72) = happyShift action_2
action_104 (73) = happyShift action_42
action_104 (74) = happyShift action_43
action_104 (75) = happyShift action_44
action_104 (4) = happyGoto action_3
action_104 (5) = happyGoto action_4
action_104 (6) = happyGoto action_5
action_104 (7) = happyGoto action_6
action_104 (26) = happyGoto action_45
action_104 (27) = happyGoto action_22
action_104 (28) = happyGoto action_23
action_104 (29) = happyGoto action_24
action_104 (30) = happyGoto action_25
action_104 (31) = happyGoto action_26
action_104 (32) = happyGoto action_27
action_104 (33) = happyGoto action_28
action_104 (34) = happyGoto action_29
action_104 (35) = happyGoto action_30
action_104 (38) = happyGoto action_31
action_104 (39) = happyGoto action_107
action_104 (40) = happyGoto action_32
action_104 (41) = happyGoto action_33
action_104 (42) = happyGoto action_34
action_104 (43) = happyGoto action_35
action_104 (44) = happyGoto action_36
action_104 _ = happyFail

action_105 (45) = happyShift action_37
action_105 (50) = happyShift action_38
action_105 (63) = happyShift action_41
action_105 (72) = happyShift action_2
action_105 (73) = happyShift action_42
action_105 (74) = happyShift action_43
action_105 (75) = happyShift action_44
action_105 (4) = happyGoto action_3
action_105 (5) = happyGoto action_4
action_105 (6) = happyGoto action_5
action_105 (7) = happyGoto action_6
action_105 (26) = happyGoto action_106
action_105 (27) = happyGoto action_22
action_105 (28) = happyGoto action_23
action_105 (29) = happyGoto action_24
action_105 (30) = happyGoto action_25
action_105 (31) = happyGoto action_26
action_105 (32) = happyGoto action_27
action_105 (33) = happyGoto action_28
action_105 (34) = happyGoto action_29
action_105 (35) = happyGoto action_30
action_105 (38) = happyGoto action_31
action_105 (40) = happyGoto action_32
action_105 (41) = happyGoto action_33
action_105 (42) = happyGoto action_34
action_105 (43) = happyGoto action_35
action_105 (44) = happyGoto action_36
action_105 _ = happyFail

action_106 _ = happyReduce_70

action_107 _ = happyReduce_69

action_108 _ = happyReduce_20

action_109 (49) = happyShift action_113
action_109 _ = happyFail

action_110 (45) = happyShift action_37
action_110 (50) = happyShift action_38
action_110 (63) = happyShift action_41
action_110 (72) = happyShift action_2
action_110 (73) = happyShift action_42
action_110 (74) = happyShift action_43
action_110 (75) = happyShift action_44
action_110 (4) = happyGoto action_3
action_110 (5) = happyGoto action_4
action_110 (6) = happyGoto action_5
action_110 (7) = happyGoto action_6
action_110 (26) = happyGoto action_95
action_110 (27) = happyGoto action_22
action_110 (28) = happyGoto action_23
action_110 (29) = happyGoto action_24
action_110 (30) = happyGoto action_25
action_110 (31) = happyGoto action_26
action_110 (32) = happyGoto action_27
action_110 (33) = happyGoto action_28
action_110 (34) = happyGoto action_29
action_110 (35) = happyGoto action_30
action_110 (36) = happyGoto action_112
action_110 (37) = happyGoto action_97
action_110 (38) = happyGoto action_31
action_110 (40) = happyGoto action_32
action_110 (41) = happyGoto action_33
action_110 (42) = happyGoto action_34
action_110 (43) = happyGoto action_35
action_110 (44) = happyGoto action_36
action_110 _ = happyFail

action_111 _ = happyReduce_57

action_112 _ = happyReduce_64

action_113 (45) = happyShift action_37
action_113 (50) = happyShift action_38
action_113 (63) = happyShift action_41
action_113 (72) = happyShift action_2
action_113 (73) = happyShift action_42
action_113 (74) = happyShift action_43
action_113 (75) = happyShift action_44
action_113 (4) = happyGoto action_3
action_113 (5) = happyGoto action_4
action_113 (6) = happyGoto action_5
action_113 (7) = happyGoto action_6
action_113 (19) = happyGoto action_114
action_113 (20) = happyGoto action_51
action_113 (21) = happyGoto action_52
action_113 (22) = happyGoto action_17
action_113 (23) = happyGoto action_18
action_113 (24) = happyGoto action_19
action_113 (25) = happyGoto action_20
action_113 (26) = happyGoto action_21
action_113 (27) = happyGoto action_22
action_113 (28) = happyGoto action_23
action_113 (29) = happyGoto action_24
action_113 (30) = happyGoto action_25
action_113 (31) = happyGoto action_26
action_113 (32) = happyGoto action_27
action_113 (33) = happyGoto action_28
action_113 (34) = happyGoto action_29
action_113 (35) = happyGoto action_30
action_113 (38) = happyGoto action_31
action_113 (40) = happyGoto action_32
action_113 (41) = happyGoto action_33
action_113 (42) = happyGoto action_34
action_113 (43) = happyGoto action_35
action_113 (44) = happyGoto action_36
action_113 _ = happyFail

action_114 (49) = happyShift action_115
action_114 _ = happyFail

action_115 (45) = happyShift action_37
action_115 (50) = happyShift action_38
action_115 (63) = happyShift action_41
action_115 (72) = happyShift action_2
action_115 (73) = happyShift action_42
action_115 (74) = happyShift action_43
action_115 (75) = happyShift action_44
action_115 (4) = happyGoto action_3
action_115 (5) = happyGoto action_4
action_115 (6) = happyGoto action_5
action_115 (7) = happyGoto action_6
action_115 (19) = happyGoto action_116
action_115 (20) = happyGoto action_51
action_115 (21) = happyGoto action_52
action_115 (22) = happyGoto action_17
action_115 (23) = happyGoto action_18
action_115 (24) = happyGoto action_19
action_115 (25) = happyGoto action_20
action_115 (26) = happyGoto action_21
action_115 (27) = happyGoto action_22
action_115 (28) = happyGoto action_23
action_115 (29) = happyGoto action_24
action_115 (30) = happyGoto action_25
action_115 (31) = happyGoto action_26
action_115 (32) = happyGoto action_27
action_115 (33) = happyGoto action_28
action_115 (34) = happyGoto action_29
action_115 (35) = happyGoto action_30
action_115 (38) = happyGoto action_31
action_115 (40) = happyGoto action_32
action_115 (41) = happyGoto action_33
action_115 (42) = happyGoto action_34
action_115 (43) = happyGoto action_35
action_115 (44) = happyGoto action_36
action_115 _ = happyFail

action_116 (46) = happyShift action_117
action_116 _ = happyFail

action_117 _ = happyReduce_21

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyTerminal (PT _ (TL happy_var_1)))
	 =  HappyAbsSyn4
		 (happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyTerminal (PT _ (TI happy_var_1)))
	 =  HappyAbsSyn5
		 ((read ( happy_var_1)) :: Integer
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  6 happyReduction_3
happyReduction_3 (HappyTerminal (PT _ (T_Variable happy_var_1)))
	 =  HappyAbsSyn6
		 (Variable (happy_var_1)
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  7 happyReduction_4
happyReduction_4 (HappyTerminal (PT _ (T_Woord happy_var_1)))
	 =  HappyAbsSyn7
		 (Woord (happy_var_1)
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_1  8 happyReduction_5
happyReduction_5 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (AbsProlog.Program1 happy_var_1
	)
happyReduction_5 _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  9 happyReduction_6
happyReduction_6 _
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 ((:[]) happy_var_1
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  9 happyReduction_7
happyReduction_7 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_1  10 happyReduction_8
happyReduction_8 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 (AbsProlog.SentenceClause happy_var_1
	)
happyReduction_8 _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  10 happyReduction_9
happyReduction_9 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn10
		 (AbsProlog.SentenceDirective happy_var_1
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  10 happyReduction_10
happyReduction_10 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn10
		 (AbsProlog.SentenceQuery happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  11 happyReduction_11
happyReduction_11 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn11
		 (AbsProlog.ClauseRule happy_var_1
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  11 happyReduction_12
happyReduction_12 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn11
		 (AbsProlog.ClauseUnit_clause happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  12 happyReduction_13
happyReduction_13 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn12
		 (AbsProlog.Rule1 happy_var_1 happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  13 happyReduction_14
happyReduction_14 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn13
		 (AbsProlog.Unit_clauseHead happy_var_1
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_2  14 happyReduction_15
happyReduction_15 (HappyAbsSyn17  happy_var_2)
	_
	 =  HappyAbsSyn14
		 (AbsProlog.Directive1 happy_var_2
	)
happyReduction_15 _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_2  15 happyReduction_16
happyReduction_16 (HappyAbsSyn17  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (AbsProlog.Query1 happy_var_2
	)
happyReduction_16 _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  16 happyReduction_17
happyReduction_17 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn16
		 (AbsProlog.HeadGoal happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_0  17 happyReduction_18
happyReduction_18  =  HappyAbsSyn17
		 (AbsProlog.Body1
	)

happyReduce_19 = happySpecReduce_2  17 happyReduction_19
happyReduction_19 (HappyAbsSyn17  happy_var_2)
	_
	 =  HappyAbsSyn17
		 (AbsProlog.Body2 happy_var_2
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  17 happyReduction_20
happyReduction_20 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (AbsProlog.Body3 happy_var_1 happy_var_3
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happyReduce 8 17 happyReduction_21
happyReduction_21 (_ `HappyStk`
	(HappyAbsSyn17  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (AbsProlog.Body4 happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_22 = happySpecReduce_1  17 happyReduction_22
happyReduction_22 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  18 happyReduction_23
happyReduction_23 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  19 happyReduction_24
happyReduction_24 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  20 happyReduction_25
happyReduction_25 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn17
		 (AbsProlog.Body0Goal happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  21 happyReduction_26
happyReduction_26 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn21
		 (AbsProlog.GoalTerm happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  22 happyReduction_27
happyReduction_27 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  23 happyReduction_28
happyReduction_28 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  24 happyReduction_29
happyReduction_29 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  25 happyReduction_30
happyReduction_30 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  26 happyReduction_31
happyReduction_31 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  27 happyReduction_32
happyReduction_32 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  28 happyReduction_33
happyReduction_33 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  28 happyReduction_34
happyReduction_34 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term71 happy_var_1 happy_var_3
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  28 happyReduction_35
happyReduction_35 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term72 happy_var_1 happy_var_3
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_3  28 happyReduction_36
happyReduction_36 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term73 happy_var_1 happy_var_3
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  28 happyReduction_37
happyReduction_37 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term74 happy_var_1 happy_var_3
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  28 happyReduction_38
happyReduction_38 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term75 happy_var_1 happy_var_3
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  28 happyReduction_39
happyReduction_39 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term76 happy_var_1 happy_var_3
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_3  28 happyReduction_40
happyReduction_40 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term77 happy_var_1 happy_var_3
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  28 happyReduction_41
happyReduction_41 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term78 happy_var_1 happy_var_3
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  28 happyReduction_42
happyReduction_42 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term79 happy_var_1 happy_var_3
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  28 happyReduction_43
happyReduction_43 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term710 happy_var_1 happy_var_3
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  28 happyReduction_44
happyReduction_44 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term711 happy_var_1 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_1  29 happyReduction_45
happyReduction_45 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_45 _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_1  30 happyReduction_46
happyReduction_46 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  30 happyReduction_47
happyReduction_47 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term51 happy_var_1 happy_var_3
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  30 happyReduction_48
happyReduction_48 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term52 happy_var_1 happy_var_3
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  31 happyReduction_49
happyReduction_49 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  31 happyReduction_50
happyReduction_50 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term41 happy_var_1 happy_var_3
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  31 happyReduction_51
happyReduction_51 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term42 happy_var_1 happy_var_3
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  31 happyReduction_52
happyReduction_52 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term43 happy_var_1 happy_var_3
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  32 happyReduction_53
happyReduction_53 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_1  33 happyReduction_54
happyReduction_54 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_2  33 happyReduction_55
happyReduction_55 (HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn22
		 (AbsProlog.Term21 happy_var_2
	)
happyReduction_55 _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_1  34 happyReduction_56
happyReduction_56 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happyReduce 4 35 happyReduction_57
happyReduction_57 (_ `HappyStk`
	(HappyAbsSyn36  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn43  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 (AbsProlog.Term01 happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_58 = happySpecReduce_3  35 happyReduction_58
happyReduction_58 _
	(HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn22
		 (AbsProlog.Term02 happy_var_2
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  35 happyReduction_59
happyReduction_59 (HappyAbsSyn38  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term0List happy_var_1
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  35 happyReduction_60
happyReduction_60 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term0String happy_var_1
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_1  35 happyReduction_61
happyReduction_61 (HappyAbsSyn40  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term0Constant happy_var_1
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_1  35 happyReduction_62
happyReduction_62 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn22
		 (AbsProlog.Term0Variable happy_var_1
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_1  36 happyReduction_63
happyReduction_63 (HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn36
		 ((:[]) happy_var_1
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  36 happyReduction_64
happyReduction_64 (HappyAbsSyn36  happy_var_3)
	_
	(HappyAbsSyn37  happy_var_1)
	 =  HappyAbsSyn36
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_1  37 happyReduction_65
happyReduction_65 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn37
		 (AbsProlog.ArgumentTerm9 happy_var_1
	)
happyReduction_65 _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_2  38 happyReduction_66
happyReduction_66 _
	_
	 =  HappyAbsSyn38
		 (AbsProlog.List1
	)

happyReduce_67 = happySpecReduce_3  38 happyReduction_67
happyReduction_67 _
	(HappyAbsSyn39  happy_var_2)
	_
	 =  HappyAbsSyn38
		 (AbsProlog.List2 happy_var_2
	)
happyReduction_67 _ _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_1  39 happyReduction_68
happyReduction_68 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn39
		 (AbsProlog.List_ExprTerm9 happy_var_1
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_3  39 happyReduction_69
happyReduction_69 (HappyAbsSyn39  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn39
		 (AbsProlog.List_Expr1 happy_var_1 happy_var_3
	)
happyReduction_69 _ _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_3  39 happyReduction_70
happyReduction_70 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn39
		 (AbsProlog.List_Expr2 happy_var_1 happy_var_3
	)
happyReduction_70 _ _ _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  40 happyReduction_71
happyReduction_71 (HappyAbsSyn42  happy_var_1)
	 =  HappyAbsSyn40
		 (AbsProlog.ConstantAtom happy_var_1
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_1  40 happyReduction_72
happyReduction_72 (HappyAbsSyn41  happy_var_1)
	 =  HappyAbsSyn40
		 (AbsProlog.ConstantNumber happy_var_1
	)
happyReduction_72 _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  41 happyReduction_73
happyReduction_73 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn41
		 (AbsProlog.NumberInteger happy_var_1
	)
happyReduction_73 _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_1  42 happyReduction_74
happyReduction_74 (HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn42
		 (AbsProlog.AtomName happy_var_1
	)
happyReduction_74 _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_1  43 happyReduction_75
happyReduction_75 (HappyAbsSyn44  happy_var_1)
	 =  HappyAbsSyn43
		 (AbsProlog.FunctoorName happy_var_1
	)
happyReduction_75 _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_1  44 happyReduction_76
happyReduction_76 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn44
		 (AbsProlog.NameWoord happy_var_1
	)
happyReduction_76 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 76 76 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 45;
	PT _ (TS _ 2) -> cont 46;
	PT _ (TS _ 3) -> cont 47;
	PT _ (TS _ 4) -> cont 48;
	PT _ (TS _ 5) -> cont 49;
	PT _ (TS _ 6) -> cont 50;
	PT _ (TS _ 7) -> cont 51;
	PT _ (TS _ 8) -> cont 52;
	PT _ (TS _ 9) -> cont 53;
	PT _ (TS _ 10) -> cont 54;
	PT _ (TS _ 11) -> cont 55;
	PT _ (TS _ 12) -> cont 56;
	PT _ (TS _ 13) -> cont 57;
	PT _ (TS _ 14) -> cont 58;
	PT _ (TS _ 15) -> cont 59;
	PT _ (TS _ 16) -> cont 60;
	PT _ (TS _ 17) -> cont 61;
	PT _ (TS _ 18) -> cont 62;
	PT _ (TS _ 19) -> cont 63;
	PT _ (TS _ 20) -> cont 64;
	PT _ (TS _ 21) -> cont 65;
	PT _ (TS _ 22) -> cont 66;
	PT _ (TS _ 23) -> cont 67;
	PT _ (TS _ 24) -> cont 68;
	PT _ (TS _ 25) -> cont 69;
	PT _ (TS _ 26) -> cont 70;
	PT _ (TS _ 27) -> cont 71;
	PT _ (TL happy_dollar_dollar) -> cont 72;
	PT _ (TI happy_dollar_dollar) -> cont 73;
	PT _ (T_Variable happy_dollar_dollar) -> cont 74;
	PT _ (T_Woord happy_dollar_dollar) -> cont 75;
	_ -> happyError' (tk:tks)
	}

happyError_ 76 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

happyThen :: () => Err a -> (a -> Err b) -> Err b
happyThen = (thenM)
happyReturn :: () => a -> Err a
happyReturn = (returnM)
happyThen1 m k tks = (thenM) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Err a
happyReturn1 = \a tks -> (returnM) a
happyError' :: () => [(Token)] -> Err a
happyError' = happyError

pProgram tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn8 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    _ -> " before " ++ unwords (map (id . prToken) (take 4 ts))

myLexer = tokens
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 8 "<command-line>" #-}
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4











































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/usr/lib/ghc-8.0.1/include/ghcversion.h" #-}

















{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/tmp/ghc640_0/ghc_2.h" #-}


































































































































































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 13 "templates/GenericTemplate.hs" #-}

{-# LINE 46 "templates/GenericTemplate.hs" #-}








{-# LINE 67 "templates/GenericTemplate.hs" #-}

{-# LINE 77 "templates/GenericTemplate.hs" #-}

{-# LINE 86 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 155 "templates/GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 256 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 322 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
