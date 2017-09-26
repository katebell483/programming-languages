
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal


let rec contains e l =
    match l with 
    [] -> false
    | h::t -> if h = e then true else (contains e t)

type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

let awkish_grammar =
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr];
          [N Term]]
     | Term ->
	 [[N Num];
	  [N Lvalue];
	  [N Incrop; N Lvalue];
	  [N Lvalue; N Incrop];
	  [T"("; N Expr; T")"]]
     | Lvalue ->
	 [[T"$"; N Expr]]
     | Incrop ->
	 [[T"++"];
	  [T"--"]]
     | Binop ->
	 [[T"+"];
	  [T"-"]]
     | Num ->
	 [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

let gram = snd(awkish_grammar);;

type ('a,'b) dict = ('a -> 'b option)

(* returns adds (k,v) to top of dictionary *)
let rec put_dict_value k v l = 
    (k,v)::l

(* return get *)
let rec get_dict_value k l =
    match l with
    | [] -> None
    | (a,b)::t -> if a=k then 
                    Some b
                  else
                    get_dict_value k t


let rec get_path start map =
    match (get_dict_value start map) with
    None -> []
    | Some x -> (get_path x map)@[x]


(* performs depth first search of the grammar starting at start and searching for target. if target hits returns Some(path to target) else returns none *)
(* keep track of parent child relationships so to traverse back along path *)
(* make sure its matching on all of the nodes in term, Expr ++ example*)
let dfs gram start target =

    let parent_map = [] and
        branches = (gram start) in

    let rec explore_branches ls target visited =
        match ls with
        |h::t -> if(explore_nodes h target visited) then true else explore_branches t target visited
        | [] -> false 

    and explore_nodes nodes target visited = 
        match nodes with
            T(x)::t -> if (x = target) then true else explore_nodes t target visited
            | N(x)::t -> if not(contains x visited) then explore_branches (gram x) (target) (x::visited) else explore_nodes t target visited
            | [] -> false

    in

    (explore_branches branches target [])

    (*
    let rec explore_nodes nodes_to_explore target visited =
        match nodes_to_explore with
            |[] -> None
            |h::t -> if (contains visited h) then (explore_nodes t target visited) 
                     else (explore_nodes ((gram h)::nodes_to_explore) (target) (visited::h))
    in (explore_nodes first_nodes_to_eplore target visited)
    *)


(*
                    else if(h = target) then Some(get_path parent_map target) else (explore_nodes (gram h)@(nodes_to_expore) target visited::h)
*) 




(*explore_nodes h target visited *)

    (*if(explore_nodes h target visited) then true else false*)
    (*
    and explore_nodes nodes target visited =
        match nodes with
       (* [] -> false*)
        | (N x)::t -> (explore_nodes t target visited::x)
            (*
        | N(x)::t -> if(contains x visited) then explore_nodes t target visited else explore_branches (gram x) target visited
        |_-> true*)
    (*explore_nodes t target
        | (T x)::t -> if(x = target) then target else (explore_nodes t target) 
        in 
    *)*)
        

