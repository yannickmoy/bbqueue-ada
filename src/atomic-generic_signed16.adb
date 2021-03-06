with System;

package body Atomic.Generic_Signed16
with SPARK_Mode => Off
is

   Size_Suffix : constant String := "2";
   --  The value of this constant is the only difference between the package
   --  bodies for the different data sizes (8, 16, 32, 64).

   ----------
   -- Load --
   ----------

   function Load
     (This : aliased Instance;
      Order : Mem_Order := Seq_Cst)
      return T
   is
      function Intrinsic
        (Ptr   : System.Address;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_load_" & Size_Suffix);
   begin
      return Intrinsic (This'Address, Order'Enum_Rep);
   end Load;

   -----------
   -- Store --
   -----------

   procedure Store
     (This  : aliased in out Instance;
      Val   : T;
      Order : Mem_Order := Seq_Cst)
   is
      procedure Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer);
      pragma Import (Intrinsic, Intrinsic, "__atomic_store_" & Size_Suffix);
   begin
      Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Store;

   ---------
   -- Add --
   ---------

   procedure Add (This  : aliased in out Instance;
                  Val   : T;
                  Order : Mem_Order := Seq_Cst)
   is
      Unused : T;
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_add_fetch_" & Size_Suffix);
   begin
      Unused := Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Add;

   ---------
   -- Sub --
   ---------

   procedure Sub (This  : aliased in out Instance;
                  Val   : T;
                  Order : Mem_Order := Seq_Cst)
   is
      Unused : T;
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_sub_fetch_" & Size_Suffix);
   begin
      Unused := Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Sub;

   -- SPARK compatible --

   --------------
   -- Exchange --
   --------------

   procedure Exchange (This  : aliased in out Instance;
                       Val   : T;
                       Old   : out T;
                       Order : Mem_Order := Seq_Cst)
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_exchange_" & Size_Suffix);
   begin
      Old := Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Exchange;

   ----------------------
   -- Compare_Exchange --
   ----------------------

   procedure Compare_Exchange (This          : aliased in out Instance;
                               Expected      : T;
                               Desired       : T;
                               Weak          : Boolean;
                               Success       : out Boolean;
                               Success_Order : Mem_Order := Seq_Cst;
                               Failure_Order : Mem_Order := Seq_Cst)
   is
      function Intrinsic
        (Ptr      : System.Address;
         Expected : System.Address;
         Desired  : T;
         Weak     : Boolean;
         Success_Order, Failure_Order : Integer) return Boolean;
      pragma Import (Intrinsic, Intrinsic,
                     "__atomic_compare_exchange_" & Size_Suffix);

      Exp : T := Expected;
   begin
      Success := Intrinsic (This'Address, Exp'Address,
                            Desired,
                            Weak,
                            Success_Order'Enum_Rep,
                            Failure_Order'Enum_Rep);
   end Compare_Exchange;

   ---------------
   -- Add_Fetch --
   ---------------

   procedure Add_Fetch (This  : aliased in out Instance;
                        Val   : T;
                        Result : out T;
                        Order : Mem_Order := Seq_Cst)
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_add_fetch_" & Size_Suffix);
   begin
      Result := Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Add_Fetch;

   ---------------
   -- Sub_Fetch --
   ---------------

   procedure Sub_Fetch (This  : aliased in out Instance;
                       Val   : T;
                        Result : out T;
                        Order : Mem_Order := Seq_Cst)
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_sub_fetch_" & Size_Suffix);
   begin
      Result := Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Sub_Fetch;

   ---------------
   -- Fetch_Add --
   ---------------

   procedure Fetch_Add (This  : aliased in out Instance;
                        Val   : T;
                        Result : out T;
                        Order : Mem_Order := Seq_Cst)
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_fetch_add_" & Size_Suffix);
   begin
      Result := Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Fetch_Add;

   ---------------
   -- Fetch_Sub --
   ---------------

   procedure Fetch_Sub (This  : aliased in out Instance;
                       Val   : T;
                        Result : out T;
                        Order : Mem_Order := Seq_Cst)
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_fetch_sub_" & Size_Suffix);
   begin
      Result := Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Fetch_Sub;

   -- NOT SPARK Compatible --

   --------------
   -- Exchange --
   --------------

   function Exchange
     (This  : aliased in out Instance;
      Val   : T;
      Order : Mem_Order := Seq_Cst)
      return T
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_exchange_" & Size_Suffix);
   begin
      return Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Exchange;

   ----------------------
   -- Compare_Exchange --
   ----------------------

   function Compare_Exchange
     (This          : aliased in out Instance;
      Expected      : T;
      Desired       : T;
      Weak          : Boolean;
      Success_Order : Mem_Order := Seq_Cst;
      Failure_Order : Mem_Order := Seq_Cst)
      return Boolean
   is
      function Intrinsic
        (Ptr      : System.Address;
         Expected : System.Address;
         Desired  : T;
         Weak     : Boolean;
         Success_Order, Failure_Order : Integer) return Boolean;
      pragma Import (Intrinsic, Intrinsic,
                     "__atomic_compare_exchange_" & Size_Suffix);

      Exp : T := Expected;
   begin
      return Intrinsic (This'Address, Exp'Address,
                        Desired,
                        Weak,
                        Success_Order'Enum_Rep,
                        Failure_Order'Enum_Rep);
   end Compare_Exchange;

   ---------------
   -- Add_Fetch --
   ---------------

   function Add_Fetch
     (This : aliased in out Instance; Val : T; Order : Mem_Order := Seq_Cst)
      return T
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_add_fetch_" & Size_Suffix);
   begin
      return Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Add_Fetch;

   ---------------
   -- Sub_Fetch --
   ---------------

   function Sub_Fetch
     (This : aliased in out Instance; Val : T; Order : Mem_Order := Seq_Cst)
      return T
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_sub_fetch_" & Size_Suffix);
   begin
      return Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Sub_Fetch;

   ---------------
   -- Fetch_Add --
   ---------------

   function Fetch_Add
     (This : aliased in out Instance; Val : T; Order : Mem_Order := Seq_Cst)
      return T
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_fetch_add_" & Size_Suffix);
   begin
      return Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Fetch_Add;

   ---------------
   -- Fetch_Sub --
   ---------------

   function Fetch_Sub
     (This : aliased in out Instance; Val : T; Order : Mem_Order := Seq_Cst)
      return T
   is
      function Intrinsic
        (Ptr   : System.Address;
         Val   : T;
         Model : Integer) return T;
      pragma Import (Intrinsic, Intrinsic, "__atomic_fetch_sub_" & Size_Suffix);
   begin
      return Intrinsic (This'Address, Val, Order'Enum_Rep);
   end Fetch_Sub;

end Atomic.Generic_Signed16;
