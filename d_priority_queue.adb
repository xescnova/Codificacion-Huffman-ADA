--Francesc Nova Prieto y Francisco José Muñoz Navarro
package body d_priority_queue is

   procedure empty (q : out priority_queue) is
      n : natural renames q.n;
   begin
      n:= 0;
   end empty;
   
   function is_empty (q : in priority_queue) return boolean is
      n : natural renames q.n;
   begin
      return n=0;
   end is_empty;
   
   function get_least (q : in priority_queue) return item is
      a : mem_space renames q.a;
      n : natural renames q.n;
   begin
      if n=0 then raise bad_use; end if ;
      return a(1);
   end get_least;

   procedure put (q : in out priority_queue; x : in item) is
      a : mem_space renames q.a;
      n : natural renames q.n;
      i : natural; -- índice a un nodo en el heap
      pi : natural; -- índice del padre del nodo i
   begin
      if n=size then raise space_overflow; end if ;
      n:= n+1; i:= n; pi:= n/2;
      while pi > 0 and then a(pi) > x loop
         a(i):= a(pi); i:= pi; pi:= i/2;
      end loop;
      a(i):= x;
   end put;
   
   procedure delete_least (q : in out priority_queue) is
      a : mem_space renames q.a;
      n : natural renames q.n;
      i : natural; -- índice a un nodo en el heap
      ci : natural; -- índice al hijo menor de i
      x : item;
   begin
      if n=0 then raise bad_use; end if ;
      x:= a(n); n:= n-1;
      i:= 1; ci:= i*2;
      if ci < n and then a(ci+1) < a(ci) then ci:= ci + 1; end if ;
      while ci <= n and then a(ci) < x loop
         a(i):= a(ci); i:= ci; ci:= i*2;
         if ci < n and then a(ci+1) < a(ci) then ci:= ci + 1; end if ;
      end loop;
      a(i) := x;
   end delete_least;
   
end d_priority_queue;
