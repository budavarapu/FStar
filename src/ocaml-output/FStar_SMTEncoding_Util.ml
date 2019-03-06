open Prims
let (mkAssume :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.caption *
    Prims.string) -> FStar_SMTEncoding_Term.decl)
  =
  fun uu____62911  ->
    match uu____62911 with
    | (tm,cap,nm) ->
        let uu____62924 =
          let uu____62925 = FStar_SMTEncoding_Term.escape nm  in
          {
            FStar_SMTEncoding_Term.assumption_term = tm;
            FStar_SMTEncoding_Term.assumption_caption = cap;
            FStar_SMTEncoding_Term.assumption_name = uu____62925;
            FStar_SMTEncoding_Term.assumption_fact_ids = []
          }  in
        FStar_SMTEncoding_Term.Assume uu____62924
  
let norng :
  'Auu____62936 'Auu____62937 .
    ('Auu____62936 -> FStar_Range.range -> 'Auu____62937) ->
      'Auu____62936 -> 'Auu____62937
  = fun f  -> fun x  -> f x FStar_Range.dummyRange 
let (mkTrue : FStar_SMTEncoding_Term.term) =
  FStar_SMTEncoding_Term.mkTrue FStar_Range.dummyRange 
let (mkFalse : FStar_SMTEncoding_Term.term) =
  FStar_SMTEncoding_Term.mkFalse FStar_Range.dummyRange 
let (mkInteger : Prims.string -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mkInteger 
let (mkInteger' : Prims.int -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mkInteger' 
let (mkReal : Prims.string -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mkReal 
let (mkBoundV : Prims.int -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mkBoundV 
let (mkFreeV : FStar_SMTEncoding_Term.fv -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mkFreeV 
let (mkApp' :
  (FStar_SMTEncoding_Term.op * FStar_SMTEncoding_Term.term Prims.list) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkApp' 
let (mkApp :
  (Prims.string * FStar_SMTEncoding_Term.term Prims.list) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkApp 
let (mkNot : FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mkNot 
let (mkMinus : FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mkMinus 
let (mkAnd :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkAnd 
let (mkOr :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkOr 
let (mkImp :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkImp 
let (mkIff :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkIff 
let (mkEq :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkEq 
let (mkLT :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkLT 
let (mkLTE :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkLTE 
let (mkGT :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkGT 
let (mkGTE :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkGTE 
let (mkAdd :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkAdd 
let (mkSub :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkSub 
let (mkDiv :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkDiv 
let (mkRealDiv :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkRealDiv 
let (mkMul :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkMul 
let (mkMod :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkMod 
let (mkNatToBv :
  Prims.int -> FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term) =
  fun sz  -> norng (FStar_SMTEncoding_Term.mkNatToBv sz) 
let (mkBvAnd :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkBvAnd 
let (mkBvXor :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkBvXor 
let (mkBvOr :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkBvOr 
let (mkBvAdd :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkBvAdd 
let (mkBvSub :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkBvSub 
let (mkBvShl :
  Prims.int ->
    (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
      FStar_SMTEncoding_Term.term)
  = fun sz  -> norng (FStar_SMTEncoding_Term.mkBvShl sz) 
let (mkBvShr :
  Prims.int ->
    (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
      FStar_SMTEncoding_Term.term)
  = fun sz  -> norng (FStar_SMTEncoding_Term.mkBvShr sz) 
let (mkBvUdiv :
  Prims.int ->
    (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
      FStar_SMTEncoding_Term.term)
  = fun sz  -> norng (FStar_SMTEncoding_Term.mkBvUdiv sz) 
let (mkBvMod :
  Prims.int ->
    (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
      FStar_SMTEncoding_Term.term)
  = fun sz  -> norng (FStar_SMTEncoding_Term.mkBvMod sz) 
let (mkBvMul :
  Prims.int ->
    (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
      FStar_SMTEncoding_Term.term)
  = fun sz  -> norng (FStar_SMTEncoding_Term.mkBvMul sz) 
let (mkBvUlt :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term) ->
    FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkBvUlt 
let (mkBvUext :
  Prims.int -> FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term) =
  fun sz  -> norng (FStar_SMTEncoding_Term.mkBvUext sz) 
let (mkBvToNat : FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkBvToNat 
let (mkITE :
  (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.term *
    FStar_SMTEncoding_Term.term) -> FStar_SMTEncoding_Term.term)
  = norng FStar_SMTEncoding_Term.mkITE 
let (mkCases :
  FStar_SMTEncoding_Term.term Prims.list -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mkCases 
let norng2 :
  'Auu____63487 'Auu____63488 'Auu____63489 .
    ('Auu____63487 -> 'Auu____63488 -> FStar_Range.range -> 'Auu____63489) ->
      'Auu____63487 -> 'Auu____63488 -> 'Auu____63489
  = fun f  -> fun x  -> fun y  -> f x y FStar_Range.dummyRange 
let norng3 :
  'Auu____63537 'Auu____63538 'Auu____63539 'Auu____63540 .
    ('Auu____63537 ->
       'Auu____63538 -> 'Auu____63539 -> FStar_Range.range -> 'Auu____63540)
      -> 'Auu____63537 -> 'Auu____63538 -> 'Auu____63539 -> 'Auu____63540
  = fun f  -> fun x  -> fun y  -> fun z  -> f x y z FStar_Range.dummyRange 
let norng4 :
  'Auu____63602 'Auu____63603 'Auu____63604 'Auu____63605 'Auu____63606 .
    ('Auu____63602 ->
       'Auu____63603 ->
         'Auu____63604 -> 'Auu____63605 -> FStar_Range.range -> 'Auu____63606)
      ->
      'Auu____63602 ->
        'Auu____63603 -> 'Auu____63604 -> 'Auu____63605 -> 'Auu____63606
  =
  fun f  ->
    fun x  -> fun y  -> fun z  -> fun w  -> f x y z w FStar_Range.dummyRange
  
let (mk_Term_app :
  FStar_SMTEncoding_Term.term ->
    FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term)
  = norng2 FStar_SMTEncoding_Term.mk_Term_app 
let (mk_Term_uvar : Prims.int -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mk_Term_uvar 
let (mk_and_l :
  FStar_SMTEncoding_Term.term Prims.list -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mk_and_l 
let (mk_or_l :
  FStar_SMTEncoding_Term.term Prims.list -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mk_or_l 
let (mk_ApplyTT :
  FStar_SMTEncoding_Term.term ->
    FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term)
  = norng2 FStar_SMTEncoding_Term.mk_ApplyTT 
let (mk_String_const : Prims.int -> FStar_SMTEncoding_Term.term) =
  norng FStar_SMTEncoding_Term.mk_String_const 
let (mk_Precedes :
  FStar_SMTEncoding_Term.term ->
    FStar_SMTEncoding_Term.term ->
      FStar_SMTEncoding_Term.term ->
        FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term)
  = norng4 FStar_SMTEncoding_Term.mk_Precedes 
let (mk_LexCons :
  FStar_SMTEncoding_Term.term ->
    FStar_SMTEncoding_Term.term ->
      FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term)
  = norng3 FStar_SMTEncoding_Term.mk_LexCons 