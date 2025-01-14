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

module DM4F_layered5

(* Same as DM4F, but layered over a layered PURE without monotonicity *)
open ID5
open FStar.Tactics
open DM4F_Utils

unfold
let pure_bind_wp (#a #b : Type) (w1 : ID5.wp a) (w2 : a -> ID5.wp b) : ID5.wp b =
  ID5.bind_wp w1 w2

(* Simulating state effect in DM4F, hopefully doable by a tactic. *)

type post_t st a = a -> st -> Type0

type wp0 (st:Type u#0) (a:Type u#ua) : Type u#(max 1 ua) =
  st -> post_t st a -> Type0

let st_monotonic #st #a (w : wp0 st a) : Type0 =
  //forall s0 p1 p2. (forall r. p1 r ==> p2 r) ==> w s0 p1 ==> w s0 p2
  // ^ this version seems to be less SMT-friendly
  forall s0 p1 p2. (forall x s1. p1 x s1 ==> p2 x s1) ==> w s0 p1 ==> w s0 p2

type wp st a = w:(wp0 st a){st_monotonic w}

open FStar.Monotonic.Pure

type repr (a:Type u#ua) (st:Type0) (wp : wp u#ua st a) : Type u#(max 1 ua) =
  s0:st -> ID (a & st) (as_pure_wp (fun p -> wp s0 (curry p)))

unfold
let return_wp (#a:Type) (#st:Type0) (x:a) : wp st a =
  fun s0 p -> p x s0

let return (a:Type) (x:a) (st:Type0) : repr a st (return_wp x) =
  fun s0 -> (x, s0)

unfold
let bind_wp (#a:Type) (#b:Type) (#st:Type0)
  (w1 : wp st a) (w2 : a -> wp st b) : wp st b =
  fun s0 p -> w1 s0 (fun y s1 -> w2 y s1 p)

[@@ resolve_implicits; refine]
let resolve_tac () : Tac unit =
  compute ();
  explode ();
  ()
  
let bind (a:Type) (b:Type) (st:Type0)
  (wp_c : wp st a)
  (wp_f : a -> wp st b)
  (c : repr a st wp_c)
  (f : (x:a -> repr b st (wp_f x)))
: repr b st (bind_wp wp_c wp_f)
= fun s0 ->
      //let (y, s1) = c s0 in
      //f y s1
      // GM: argh! using the match above introduces noise in the VC, a true precondition
      // that becomes a pain since we don't have monotonicity nor even extensionality
      let r = c s0 in
      f (fst r) (snd r)

let ite_wp #a #st (b:bool) (w1 w2 : wp st a) : wp st a =
  fun s0 p -> (b ==> w1 s0 p) /\ ((~b) ==> w2 s0 p)

let if_then_else
  (a:Type)
  (st:Type0)
  (wpf wpg : wp st a)
  (f : repr a st wpf)
  (g : repr a st wpg)
  (b : bool)
  : Type
  = repr a st (ite_wp b wpf wpg)

let stronger
  (#a:Type) (#st:Type0)
  (w1 w2 : wp st a)
  : Type0
  = forall s0 p. w1 s0 p ==> w2 s0 p

let subcomp
  (a:Type)
  (st:Type0)
  (wpf wpg : wp st a)
  (#[@@@ refine] u : squash (stronger wpg wpf))
  (f : repr a st wpf)
  : repr a st wpg
  = f

total
reifiable
reflectable
effect {
  ST (a:Type) ([@@@ effect_param] st:Type0) (_:wp st a)
  with {repr; return; bind; subcomp; if_then_else}
}

let lift_id_st_wp #a #st (w : ID5.wp a) : wp st a =
  elim_pure_wp_monotonicity_forall ();
  fun s0 p -> w (fun x -> p x s0)

let lift_id_st a wp st (f : ID5.repr a wp)
  : repr a st (lift_id_st_wp wp)
  = fun s0 -> ID5.ID?.reflect (ID5.bind _ _ _ _ f (fun x -> ID5.return _ (x, s0)))

sub_effect ID ~> ST = lift_id_st

let null #st #a : wp st a =
  fun s0 p -> forall x s1. p x s1

let get #st () : ST st st (fun s0 p -> p s0 s0) =
  ST?.reflect (fun s0 -> (s0, s0))

let put #st (s:st) : ST unit st (fun _ p -> p () s) =
  ST?.reflect (fun _ -> ((), s))

// this now works!!!
let test () : ST int int null =
  let x = get () in
  put (x + x);
  get () + get ()

let addx (x:int) : ST unit int (fun s0 p -> p () (s0+x)) =
  let y = get () in
  put (x+y)

let add_via_state (x y : int) : ST int int (fun s0 p -> p (x+y) s0) =
  let o = get () in
  put x;
  addx y;
  let r = get () in
  put o;
  r
