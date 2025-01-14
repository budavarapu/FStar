(*
   Copyright 2008-2018 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)

module LL

/// An example of layering exception over PURE, and then a state over it
///
/// See also parsing/FlightsStExn.fst where the underlying effect is HyperStack.ST


(*** Define an exception effect over PURE ***)


/// Type of pre- and postcondition

type epre_t = Type0
type epost_t (a:Type) = option a -> Type0

/// wp has a refinement for monotonicity -- we should handle it more uniformly in the typechecker

type ewp_t0 (a:Type) = epost_t a -> epre_t

unfold
let ewp_monotonic (#a:Type) (wp:ewp_t0 a) : Type0 =
  forall p q. (forall x. p x ==> q x) ==>
         (wp p ==> wp q)

type ewp_t (a:Type) = wp:ewp_t0 a{ewp_monotonic wp}


/// Now the underlying representation of the layered effect
///
/// It's just a thunked option-returning computation

open FStar.Monotonic.Pure

type erepr (a:Type) (wp:ewp_t a) = unit -> PURE (option a) (as_pure_wp wp)


/// Defining the effect combinators
///
/// We require return, bind, subcomp, and if_then_else


inline_for_extraction
let ereturn (a:Type) (x:a)
: erepr a (fun p -> p (Some x))
= fun _ -> Some x

inline_for_extraction
let ebind (a:Type) (b:Type)
  (wp_f:ewp_t a) (wp_g:a -> ewp_t b)
  (f:erepr a wp_f) (g:(x:a -> erepr b (wp_g x)))
: erepr b
  (fun (p:epost_t b) ->
    wp_f (fun (r:option a) ->
      match r with
      | None -> p None
      | Some x -> wp_g x p))
= fun _ ->
  let r = f () in
  match r with
  | None -> None
  | Some x -> g x ()


inline_for_extraction
let esubcomp (a:Type)
  (wp_f:ewp_t a) (wp_g:ewp_t a)
  (f:erepr a wp_f)
: Pure (erepr a wp_g)
  (requires forall p. wp_g p ==> wp_f p)
  (ensures fun _ -> True)
= f


inline_for_extraction
let eif_then_else (a:Type)
  (wp_f:ewp_t a) (wp_g:ewp_t a)
  (f:erepr a wp_f) (g:erepr a wp_g)
  (p:bool)
: Type
= erepr a
  (fun post ->
    (p ==> wp_f post) /\
    ((~ p) ==> wp_g post))


/// The effect definition

total reifiable reflectable
effect {
  EXN (a:Type) (_:ewp_t a)
  with {repr = erepr;
        return = ereturn;
        bind = ebind;
        subcomp = esubcomp;
        if_then_else = eif_then_else}
}


/// Lift from PURE to EXN

unfold
let lift_pure_wp (#a:Type) (wp:pure_wp a) : ewp_t a =
  FStar.Monotonic.Pure.elim_pure_wp_monotonicity wp;
  fun p -> wp (fun x -> p (Some x))

inline_for_extraction
let lift_pure_exn (a:Type) (wp:pure_wp a) (f:unit -> PURE a wp)
: erepr a (lift_pure_wp wp)
= FStar.Monotonic.Pure.elim_pure_wp_monotonicity wp;
  fun _ -> Some (f ())

sub_effect PURE ~> EXN = lift_pure_exn


/// Shorthand for hoare-style specs

effect Exn (a:Type) (pre:Type0) (post:option a -> Type0) =
  EXN a (fun p -> pre /\ (forall r. post r ==> p r))


(*** Some examples using the EXN effect ***)

assume val get_n1
: n:nat ->
  Pure (option (nat * nat))
  (requires n > 0)
  (ensures fun r ->
    match r with
    | None -> True
    | Some (n1, n2) -> n1 == n /\ n2 == n + 1)

type flt = {
  n1 : nat;
  n2 : nat;
  n3 : i:nat{n1 > 0 /\ n2 = n1 + 1 /\ i = n2 + 1}
}


/// This is how the get_flt function would look like in the PURE effect with nested pattern matching

let get_flt (n:nat)
: Pure (option flt)
  (requires n > 0)
  (ensures fun r ->
    match r with
    | None -> True
    | Some flt -> flt.n1 == n)
= let r = get_n1 n in
  match r with
  | None -> None
  | Some (x, n) ->
    let r = get_n1 n in
    match r with
    | None -> None
    | Some (y, n) ->
      let r = get_n1 n in
      match r with
      | None -> None
      | Some (z, _) -> Some ({ n1 = x; n2 = y; n3 = z })


/// Now we implement it in the EXN effect
///
/// First, inject get_n1 into the EXN effect

inline_for_extraction
let get_n1_exn (n:nat)
: Exn (nat * nat)
  (requires n > 0)
  (ensures fun r ->
    match r with
    | None -> True
    | Some (n1, n2) -> n1 == n /\ n2 == n + 1)
= EXN?.reflect (fun _ -> get_n1 n)


/// Now we can implement get_flt in the EXN effect using get_n1_exn


inline_for_extraction
let get_flt_exn (n:nat)
: Exn flt
  (requires n > 0)
  (ensures fun r ->
    match r with
    | None -> True
    | Some flt -> flt.n1 == n)
= let x, n = get_n1_exn n in
  let y, n = get_n1_exn n in
  let z, _ = get_n1_exn n in
  { n1 = x; n2 = y; n3 = z}


/// This is good, but note that there is still some state passing (`n`)
///
/// We can hide that behind an effect too


(*** A state effect layered on top of EXN ***)



type pre_t = nat -> Type0
type post_t (a:Type) = option (a & nat) -> Type0
type wp_t0 (a:Type) = post_t a -> pre_t

unfold
let wpt_monotonic (#a:Type) (wp:wp_t0 a) =
  forall p q. (forall r. p r ==> q r) ==>
         (forall n. wp p n ==> wp q n)

type wp_t (a:Type) = wp:wp_t0 a{wpt_monotonic wp}

type repr (a:Type) (wp:wp_t a) =
  n:nat -> EXN (a & nat) (fun p -> wp p n)

inline_for_extraction
let return (a:Type) (x:a)
: repr a (fun p n -> p (Some (x, n)))
= fun n -> (x, n)

unfold
let post_a (a:Type) (b:Type) (wp_g:a -> wp_t b) (p:post_t b) : post_t a =
  fun r ->
  match r with
  | None -> p None
  | Some r -> wp_g (Mktuple2?._1 r) p (Mktuple2?._2 r)

unfold
let bind_wp (a:Type) (b:Type) (wp_f:wp_t a) (wp_g:a -> wp_t b) : wp_t b
= fun p n0 ->
  wp_f (fun r ->
        match r with
        | None -> p None
        | Some (x, n1) -> (wp_g x) p n1) n0
                             

inline_for_extraction
let bind (a:Type) (b:Type)
  (wp_f:wp_t a) (wp_g:a -> wp_t b)
  (f:repr a wp_f) (g:(x:a -> repr b (wp_g x)))
: repr b (bind_wp a b wp_f wp_g)
= fun n ->
  let r = f n in
  g (fst r) (snd r)

inline_for_extraction
let subcomp (a:Type)
  (wp_f:wp_t a) (wp_g:wp_t a)
  (f:repr a wp_f)
: Pure (repr a wp_g)
  (requires forall p n. wp_g p n ==> wp_f p n)
  (ensures fun _ -> True)
= f

inline_for_extraction
let if_then_else (a:Type)
  (wp_f:wp_t a) (wp_g:wp_t a)
  (f:repr a wp_f) (g:repr a wp_g)
  (p:bool)
: Type
= repr a
  (fun post n ->
    (p ==> wp_f post n) /\
    ((~ p) ==> wp_g post n))

total reifiable reflectable
effect {
  STEXN (a:Type) (wp:wp_t a)
  with {repr; return; bind; subcomp; if_then_else}
}

unfold
let lift_pure_wp_stexn (#a:Type) (wp:pure_wp a) : wp_t a =
  FStar.Monotonic.Pure.elim_pure_wp_monotonicity wp;
  fun p n -> wp (fun x -> p (Some (x, n)))

inline_for_extraction
let lift_pure_stexn (a:Type) (wp:pure_wp a) (f:unit -> PURE a wp)
: repr a (lift_pure_wp_stexn wp)
= FStar.Monotonic.Pure.elim_pure_wp_monotonicity wp;
  fun n -> (f (), n)

sub_effect PURE ~> STEXN = lift_pure_stexn


effect StExn (a:Type) (pre:nat -> Type0) (post:nat -> option (a & nat) -> Type0) =
  STEXN a (fun p n -> pre n /\ (forall r. post n r ==> p r))


(*** Example using the STEXN effect ***)

inline_for_extraction
let get_n1_stexn (_:unit)
: StExn nat
  (requires fun n -> n > 0)
  (ensures fun n r ->
    match r with
    | None -> True
    | Some (n1, n2) -> n1 == n /\ n2 == n + 1)
= STEXN?.reflect (fun n -> get_n1_exn n)


/// get_flt function in the STEXN effect that hides the state also

inline_for_extraction
let get_flt_stexn (_:unit)
: StExn flt
  (requires fun n -> n > 0)
  (ensures fun n r ->
    match r with
    | None -> True
    | Some (flt, _) -> flt.n1 == n)
= let x = get_n1_stexn () in
  let y = get_n1_stexn () in
  let z = get_n1_stexn () in
  { n1 = x; n2 = y; n3 = z}


/// And now we can reify the effect to reveal a spec in terms of PURE

let get_flt_stexn_reified (n:nat)
: Pure (option (flt * nat))
  (requires n > 0)
  (ensures fun r ->
    match r with
    | None -> True
    | Some (flt, _) -> flt.n1 == n)
= reify (reify (get_flt_stexn ()) n) ()


/// An extraction test

let test () : Exn int True (fun _ -> True)
= 4

let test_st () : Pure (option int) True (fun _ -> True)
= reify (test ()) ()
