open Tsd
open List

type state = Zero | One

let process transition xs = 
	let rec process' xs = 
		match xs with 
		| [] -> [] 
		| y :: z :: [] -> [transition (y, z, Zero)]
		| x :: y :: z :: xs -> transition (x, y, z) :: process' (y :: z :: xs)
	in
	match xs with
	| [] -> []
	| [x] -> [transition (Zero, x, Zero)]
	| x :: y :: xs -> transition (Zero, x, y) :: process' (x :: y :: xs)

let create_automata init transition = 
	let process = lift process and transition = lift transition in 
	let all = cell (lift init) in 
	all <~ [%dfg process transition all];
	all 

let rec init_states n total = 
	match n with
	| 0 -> [] 
	| n -> (if n == (total)/2 then One else Zero) :: init_states (n-1) total 

let rule110 = function
	| (One, One, One) -> Zero
	| (One, One, Zero) -> One
	| (One, Zero, One) -> One
	| (One, Zero, Zero) -> Zero
	| (Zero, One, One) -> One
	| (Zero, One, Zero) -> One
	| (Zero, Zero, One) -> One
	| (Zero, Zero, Zero) -> Zero

let rule54 = function 
	| (One, One, One) -> Zero
	| (One, One, Zero) -> Zero
	| (One, Zero, One) -> One
	| (One, Zero, Zero) -> One
	| (Zero, One, One) -> Zero
	| (Zero, One, Zero) -> One
	| (Zero, Zero, One) -> One
	| (Zero, Zero, Zero) -> Zero

let _ =
	let size = 21 in 
	let total_step = 100 in 
	let world = create_automata (init_states size size) rule54 in 
	for i = 1 to total_step do
	    let all = peek world in 
		List.iter (fun x -> print_int (if x == One then 1 else 0)) all;
		print_newline();
		step()
	done
