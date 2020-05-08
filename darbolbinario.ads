--Francesc Nova Prieto y Francisco José Muñoz Navarro
generic
   type elem is private ;
   with procedure visitar(x: in elem);
package darbolbinario is
   
   type arbol is limited private ;

   mal_uso : exception ;
   espacio_desbordado : exception ;

   procedure avacio ( t : out arbol ) ;
   function esta_vacio ( t : in arbol ) return boolean ;
   procedure graft ( t : out arbol ; lt , rt : in arbol ; x : in elem ) ;
   procedure raiz ( t : in arbol ; x : out elem ) ;
   procedure izq ( t : in arbol ; lt : out arbol ) ;
   procedure der ( t : in arbol ; rt : out arbol ) ;
   procedure amplitud(t: in arbol);
  -- procedure preorden( x: in arbol );
   function ex_izq( t: in arbol ) return boolean;
   function ex_der( t: in arbol ) return boolean;
private
   -- depende implementación
   type node;
   type pnode is access node;
   
   type node is record
      x: elem;
      l, r: pnode;
   end record;
   
   type arbol is record
      raiz: pnode;
   end record;
   
end darbolbinario ;
