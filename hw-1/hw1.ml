(* prob 1 *)
let rec contains e l =
    match l with 
    [] -> false
    | h::t -> if h = e then true else (contains e t)

let rec contains_type tp l =
    match l with 
    [] -> false
    | h::t -> if h = tp then true else (contains_type tp t)

(* prob 2 *)
let rec subset a b = 
    match a with
    [] -> true
    | h::t -> (contains h  b) && (subset t b)

(* prob 3 *)
let rec equal_sets a b =
    match a with
    [] -> if b == [] then true else false
    | h::t -> if subset a b && subset b a then true else false

(* prob 4 *)
let rec set_union a b = 
    match a with
    [] -> b 
    | h::t -> h::(set_union t b)

(* prob 5 *)
let rec set_intersection a b = 
    match a with
    [] -> []
    | h::t -> if (contains h b) then h::(set_intersection t b) else (set_intersection t b)    

(* prob 6 *)
let rec set_diff a b = 
    match a with
    [] -> []
    | h::t -> if (contains h b) then (set_diff t b) else h::(set_diff t b);;

(* prob 7 *)
let rec computed_fixed_point eq f x =
    match x with
    j when eq j (f x) -> x
    | _ -> (computed_fixed_point eq f (f x))

(* prob 8 *)
let rec get_periodic_function f p x = 
    match p with 
    0 -> x
    | _ -> get_periodic_function f (p - 1) (f x)

let rec computed_periodic_point eq f p x = 
    match x with
    j when eq j (get_periodic_function f p x) -> x
    | _ -> (computed_periodic_point eq f p (f x))

(* prob 9 *)
let rec  while_away s p x =
   match p x with
    false -> []
    | _ ->  x::(while_away s p (s x));;

(* prob 10 - create repeated list *)
let rec create_repeat_list l v =
    match l with 
    0 -> []
    | _ -> v::create_repeat_list (l-1) v

let rec rle_decode lp =
    match lp with
    [] -> []
    |(l, v)::t -> (create_repeat_list l v)@rle_decode(t)

(* here begins last prob *)
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

(* wrapper for equal_sets function *)
let equal_terms_sets (orig_rulesa, termsa) (orig_rulesb, termsb) =
    equal_sets termsa termsb

let rec is_terminal term ok_terms = 
    (* check if terminal on its own or that it already has terminal path aka in ok_terms *)
    match term with
    N(term) -> (contains term ok_terms)
    | T(term) -> true

let rec check_rule l ok_terms =
    (* iterate through all terms in a rule checking that each one is terminal or not *)
    match l with

    (* empty lists are always terminal *)
    [] -> true

    (* check each term of list, if even one is non-terminal return false *)
    | h::t -> if (is_terminal h ok_terms) then (check_rule t ok_terms) else false

let rec get_ok_terms rules ok_terms =

    (* iterate through each rule, compiling all rules that have terminal endings into list ok_terms *)
    match rules with

    [] -> ok_terms

    (* rules are a pair which includes a term and a list of symbols each of which are terminal or non-terminal *)
    | (term, sym_list)::t -> if(check_rule sym_list ok_terms) then 

        (* now check if we already have term in list and only include if we don't *)
        begin if (contains term ok_terms) then get_ok_terms t ok_terms else get_ok_terms t (term::ok_terms) end 

    (* term is not terminal so don't add and check other rules *)
    else (get_ok_terms t ok_terms) 

(* wrapper so we input pair and output pair with get_ok_terms *)
let get_ok_terms_wrapper (rules, ok_terms) = 
    (rules, (get_ok_terms rules ok_terms))


let rec get_final_rules rules terminal_terms =

    (* iterate through each rule, removing rules that contain non-terminal terms*)
    match rules with
    [] -> []

    (* check each rule to ensure that it contains terms that terminate *)
    | (term, sym_list)::t -> if (check_rule sym_list terminal_terms) then 
            
        (* if the rule is ok'd then we add it to our final list *)
        begin
        (term, sym_list)::(get_final_rules t terminal_terms) 
        end

        (* otherwise, we exclude it and move on *)
        else (get_final_rules t terminal_terms)

(* takes a grammar, removes blind-alleys and reconstructs that grammar in same order *)
let rec filter_blind_alleys g = 

    (* parse the rules and the start symbol from grammar *)
    let rules = (fun (x,y) -> y) g in 
    let start = (fun (x,y) -> x) g in

    (* iterate through each rule and iteratively compile a list of terms that have full alleys *)
    (* since get_ok_terms return pair of orig rule and and terminal terms only take second part of pair *)
    let terminal_terms = (snd(computed_fixed_point (equal_terms_sets) (get_ok_terms_wrapper)  (rules, []))) in

    (* not that we have the terminal terms, we can go through rules and throw out the ones that contain additional terms *)
    let final_rules = (get_final_rules rules terminal_terms) in

    (* reconstruct grammar *)
    (start, final_rules)

     
