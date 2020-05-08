--Francesc Nova Prieto y Francisco José Muñoz Navarro
generic
   size : Positive;
   type item is private;
   with function "<" (x1,x2 : in item) return boolean;
   with function ">" (x1,x2 : in item) return boolean;
package d_priority_queue is
   type priority_queue is limited private;
   space_overflow: exception;
   bad_use: exception;
   procedure empty (q : out priority_queue);
   procedure put (q : in out priority_queue; x : in item);
   procedure delete_least (q : in out priority_queue);
   function get_least (q : in priority_queue) return item;
   function is_empty (q: in priority_queue) return boolean;
   
private
   type mem_space is array (1..size) of item;
   type priority_queue is record
      a: mem_space;
      n: natural;
   end record;
   
end d_priority_queue;
