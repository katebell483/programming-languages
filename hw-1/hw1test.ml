
(* MY TESTS BELOW *)
let my_subset_test0 = subset [] []
let my_subset_test1 = subset [1;1;1] [1]

let my_equal_sets_test0 = equal_sets [4;4;4;3] [4;3]
let my_equal_sets_test1 = not (equal_sets [1] [1;2;3;3])

let my_set_union_test0 = equal_sets (set_union [] [1;2;3]) [1;2;3]

let my_set_intersection_test0 =
  equal_sets (set_intersection [] []) []

let my_set_intersection_test1 =
  equal_sets (set_intersection [1;1;1;7] [1]) [1]

let my_set_diff_test0 = equal_sets (set_diff [1;3] [3;3;1]) []
let my_set_diff_test1 = equal_sets (set_diff [9] [1;5]) [9]
let my_set_diff_test3 = equal_sets (set_diff [9] []) [9]

let my_computed_fixed_point_test0 =
  computed_fixed_point (=) (fun x -> 0.) 1. = 0.

let my_computed_periodic_point_test0 =
  computed_periodic_point (=) (fun x -> x * -1) 2 (1) = 1

let my_while_away_test0 = 
    equal_sets (while_away (fun x -> x * 2) ((>) 6) 1) [1;2;4]

let my_rle_decode_test0 = 
    equal_sets (rle_decode [0,2; 1,6]) [6]
let my_rle_decode_test1 = 
    equal_sets (rle_decode []) []
let my_rle_decode_test2 = 
    equal_sets (rle_decode [3,4;0,5;2,6]) [4;4;4;6;6]

type zoo_nonterminals = | Farm | Enclosure | Zoo | Cow | Duck | Cat | Sound | Silent

let zoo_rules = 
    [Enclosure, [N Farm; N Zoo]; 
    Farm, [N Cow; N Cat; T "chicken"];
    Zoo, [N Cow; N Duck; N Cat]; 
    Zoo, [T "dog"]; 
    Cow, [N Sound]; 
    Duck, [N Sound];
    Cat, [N Sound];
    Sound, [N Silent];
    Sound, [T "moo"];
    Sound, [T "quack"];
    Sound, [T "meow"];
    Silent, []]

let zoo_grammar = Enclosure, zoo_rules

let my_filter_blind_alleys_testt0 =
  filter_blind_alleys zoo_grammar = zoo_grammar

let my_filter_blind_alleys_test1 = 
    filter_blind_alleys (Enclosure, List.tl (List.tl (List.tl (List.tl (List.tl (snd zoo_grammar)))))) =
    (Enclosure, [(Duck, [N Sound]); (Cat, [N Sound]); (Sound, [N Silent]); (Sound, [T "moo"]); (Sound, [T "quack"]); (Sound, [T "meow"]); (Silent, [])]);;

(* EGGERT'S TESTS *)

let subset_test0 = subset [] [1;2;3]
let subset_test1 = subset [3;1;3] [1;2;3]
let subset_test2 = not (subset [1;3;7] [4;1;3])

let equal_sets_test0 = equal_sets [1;3] [3;1;3]
let equal_sets_test1 = not (equal_sets [1;3;4] [3;1;3])

let set_union_test0 = equal_sets (set_union [] [1;2;3]) [1;2;3]
let set_union_test1 = equal_sets (set_union [3;1;3] [1;2;3]) [1;2;3]
let set_union_test2 = equal_sets (set_union [] []) []

let set_intersection_test0 =
  equal_sets (set_intersection [] [1;2;3]) []
let set_intersection_test1 =
  equal_sets (set_intersection [3;1;3] [1;2;3]) [1;3]
let set_intersection_test2 =
  equal_sets (set_intersection [1;2;3;4] [3;1;2;4]) [4;3;2;1]

let set_diff_test0 = equal_sets (set_diff [1;3] [1;4;3;1]) []
let set_diff_test1 = equal_sets (set_diff [4;3;1;1;3] [1;3]) [4]
let set_diff_test2 = equal_sets (set_diff [4;3;1] []) [1;3;4]
let set_diff_test3 = equal_sets (set_diff [] [4;3;1]) []

let computed_fixed_point_test0 =
  computed_fixed_point (=) (fun x -> x / 2) 1000000000 = 0
let computed_fixed_point_test1 =
  computed_fixed_point (=) (fun x -> x *. 2.) 1. = infinity
let computed_fixed_point_test2 =
  computed_fixed_point (=) sqrt 10. = 1.
let computed_fixed_point_test3 =
  ((computed_fixed_point (fun x y -> abs_float (x -. y) < 1.)
			 (fun x -> x /. 2.)
			 10.)
   = 1.25)

let computed_periodic_point_test0 =
  computed_periodic_point (=) (fun x -> x / 2) 0 (-1) = -1
let computed_periodic_point_test1 =
  computed_periodic_point (=) (fun x -> x *. x -. 1.) 2 0.5 = -1.

(* An example grammar for a small subset of Awk, derived from but not
   identical to the grammar in
   <http://web.cs.ucla.edu/classes/winter06/cs132/hw/hw1.html>.  *)

type awksub_nonterminals =
  | Expr | Lvalue | Incrop | Binop | Num

let awksub_rules =
   [Expr, [T"("; N Expr; T")"];
    Expr, [N Num];
    Expr, [N Expr; N Binop; N Expr];
    Expr, [N Lvalue];
    Expr, [N Incrop; N Lvalue];
    Expr, [N Lvalue; N Incrop];
    Lvalue, [T"$"; N Expr];
    Incrop, [T"++"];
    Incrop, [T"--"];
    Binop, [T"+"];
    Binop, [T"-"];
    Num, [T"0"];
    Num, [T"1"];
    Num, [T"2"];
    Num, [T"3"];
    Num, [T"4"];
    Num, [T"5"];
    Num, [T"6"];
    Num, [T"7"];
    Num, [T"8"];
    Num, [T"9"]]

let awksub_grammar = Expr, awksub_rules

let awksub_test0 =
  filter_blind_alleys awksub_grammar = awksub_grammar

let awksub_test1 =
  filter_blind_alleys (Expr, List.tl awksub_rules) = (Expr, List.tl awksub_rules)

let awksub_test2 =
  filter_blind_alleys (Expr,
      [Expr, [N Num];
       Expr, [N Lvalue];
       Expr, [N Expr; N Lvalue];
       Expr, [N Lvalue; N Expr];
       Expr, [N Expr; N Binop; N Expr];
       Lvalue, [N Lvalue; N Expr];
       Lvalue, [N Expr; N Lvalue];
       Lvalue, [N Incrop; N Lvalue];
       Lvalue, [N Lvalue; N Incrop];
       Incrop, [T"++"]; Incrop, [T"--"];
       Binop, [T"+"]; Binop, [T"-"];
       Num, [T"0"]; Num, [T"1"]; Num, [T"2"]; Num, [T"3"]; Num, [T"4"];
       Num, [T"5"]; Num, [T"6"]; Num, [T"7"]; Num, [T"8"]; Num, [T"9"]])
  = (Expr,
     [Expr, [N Num];
      Expr, [N Expr; N Binop; N Expr];
      Incrop, [T"++"]; Incrop, [T"--"];
      Binop, [T "+"]; Binop, [T "-"];
      Num, [T "0"]; Num, [T "1"]; Num, [T "2"]; Num, [T "3"]; Num, [T "4"];
      Num, [T "5"]; Num, [T "6"]; Num, [T "7"]; Num, [T "8"]; Num, [T "9"]])

let awksub_test3 =
  filter_blind_alleys (Expr, List.tl (List.tl (List.tl awksub_rules))) =
    filter_blind_alleys (Expr, List.tl (List.tl awksub_rules))

type giant_nonterminals =
  | Conversation | Sentence | Grunt | Snore | Shout | Quiet

let giant_grammar =
  Conversation,
  [Snore, [T"ZZZ"];
   Quiet, [];
   Grunt, [T"khrgh"];
   Shout, [T"aooogah!"];
   Sentence, [N Quiet];
   Sentence, [N Grunt];
   Sentence, [N Shout];
   Conversation, [N Snore];
   Conversation, [N Sentence; T","; N Conversation]]

let giant_test0 =
  filter_blind_alleys giant_grammar = giant_grammar

let giant_test1 =
  filter_blind_alleys (Sentence, List.tl (snd giant_grammar)) =
    (Sentence,
     [Quiet, []; Grunt, [T "khrgh"]; Shout, [T "aooogah!"];
      Sentence, [N Quiet]; Sentence, [N Grunt]; Sentence, [N Shout]])

let giant_test2 =
  filter_blind_alleys (Sentence, List.tl (List.tl (snd giant_grammar))) =
    (Sentence,
     [Grunt, [T "khrgh"]; Shout, [T "aooogah!"];
      Sentence, [N Grunt]; Sentence, [N Shout]])
