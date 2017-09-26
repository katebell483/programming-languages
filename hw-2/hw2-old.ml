(* UTILS *)
(* TODO: rewrite this *)
let slice list i k =
    let rec take n = function
      | [] -> []
      | h :: t -> if n = 0 then [] else h :: take (n-1) t
    in
    let rec drop n = function
      | [] -> []
      | h :: t as l -> if n = 0 then l else drop (n-1) t
    in
    take (k - i + 1) (drop i list);;


type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

(* this builds the function that will be curried into the production function *)
let rec build_grammar_fun rules symbol =

    (* iterate through rules returning list of rules pertaining to the symbol *)
    match rules with
    (a,b)::l when a = symbol -> b::(build_grammar_fun l symbol)
    | (a,b)::l -> (build_grammar_fun l symbol)
    | _ -> []

let rec convert_grammar gram1 = 
   
    (* extract rules and start symbol*) 
    let rules = (fun (x,y) -> y) gram1 in 
    let start = (fun (x,y) -> x) gram1 in

    (* recurse through rules and build production function *)
    let production_function = build_grammar_fun rules in
    
    (* return grammar now in hw2 style *)
    (start, production_function)


(* THIS IS WHERE HARD WORK STARTS *)

(*type fragment = string list*)
(*type acceptor = fragment -> fragment -> (fragment*fragment) option
type matcher = fragment -> acceptor -> fragment option*)

let accept_all derivation suffix = Some (derivation, suffix)

let rec get_derivation gram prefix frag = 
    Some [prefix]

let match_empty derivation frag accept = accept derivation frag
let match_end derivation frag accept = match derivation with 
                                       [] -> None
                                       |_ -> accept derivation frag

let match_prefix gram prefix derivation frag accept =
  match frag with
    [] -> None
    | n::tail -> match (get_derivation gram prefix n) with
                    None -> None
                    | Some x -> (accept (derivation@x) tail)

let append_matchers matcher1 matcher2 derivation frag accept =
    matcher1 derivation frag (fun derivation1 frag1 -> matcher2 derivation1 frag1 accept)

let make_appended_matchers gram prefix =
  let rec mams = function
    [] -> match_empty 
    | head::tail -> append_matchers (match_prefix gram head) (mams tail)
  in mams prefix

let rec make_or_matcher gram prefixes = 
    match prefixes with
    [] -> match_end 
    | head::tail ->
        let head_matcher = make_appended_matchers gram head 
        and tail_matcher = make_or_matcher gram tail in 
        fun derivation frag accept ->
	        let ormatch = head_matcher derivation frag accept in
	        match ormatch with
		    None -> tail_matcher derivation frag accept
	    	| Some (x,y) -> make_or_matcher gram prefixes x y accept 

                    
let parse_prefix gram =
    let start = fst(gram) in
    let gram_fun = snd(gram) in
    let prefixes = gram_fun start in 
    (make_or_matcher gram_fun prefixes [])

(*TODO: 
    - make sure empty cases are handled properly
    - get derivations via dfs
*)



