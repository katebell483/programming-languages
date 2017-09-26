

(* question 7 *)
let rec interleave_list C S L1 L2 F = 
    match L1 with 
    [] -> (S, F::L2)
    | h::t -> match L2 with
            [] -> (S, F::L1) 
            |_ -> choose_next C S L1 L2 F

and choose_next C S L1 L2 F = 
    match L1 with 
    h1::t1 -> match L2 with
            h2::t2 -> match (C S h1 h2) with
                    (S1, h) -> if h = h1 then (interleave_list C S1 t1 L2 F::h) else (interleave_list C S1 L1 t1 t2 F::h)

let interleave C S L1 L2 = 
(interleave_list C S L1 L2 [])




