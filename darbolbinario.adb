--Francesc Nova Prieto y Francisco José Muñoz Navarro
with dcola;
package body darbolbinario is

   procedure avacio(t: out arbol) is
      p: pnode renames t.raiz;
   begin
      p:= null;
   end avacio;

   function esta_vacio(t: in arbol) return boolean is
      p: pnode renames t.raiz;
   begin
      return p=null;
   end esta_vacio;
 
   procedure graft(t: out arbol; lt, rt: in arbol; x: in elem) is
      p: pnode renames t.raiz;
      pl: pnode renames lt.raiz;
      pr: pnode renames rt.raiz;
   begin
      p:= new node;
      p.all:= (x, pl, pr);
   exception
      when storage_error => raise espacio_desbordado;
   end graft;

   procedure raiz(t: in arbol; x: out elem) is
      p: pnode renames t.raiz;
   begin
      x:= p.x;
   exception
      when constraint_error => raise mal_uso;
   end raiz;
 
   procedure izq(t: in arbol; lt: out arbol) is
      p: pnode renames t.raiz;
      pl: pnode renames lt.raiz;
   begin
      pl:= p.l;
   exception
      when constraint_error => raise mal_uso;
   end izq;

   procedure der(t: in arbol; rt: out arbol) is
      p: pnode renames t.raiz;
      pr: pnode renames rt.raiz;
   begin
      pr:= p.r;
   exception
      when constraint_error => raise mal_uso;
   end der;
   
   procedure amplitud ( t : in arbol ) is
      package dcola_nodo is new dcola (pnode) ;
      use dcola_nodo;
      q                   : cola; 
      p                   : pnode ;
   begin
      -- Si l'arbre no es buid
      if not esta_vacio(t) then
         -- Inicialitzar la cua
         cvacia(q);
         -- Afegir l'arrel de l'arbre
         poner(q,t.raiz);
         while not esta_vacia(q) loop
            p :=coger_primero(q);
            visitar(p.x);
            if p.l/=null then
                  poner(q,p.l);
               end if;
               if p.r/=null then
                     poner(q,p.r);
                  end if;
                  borrar_primero(q);
               end loop;
            end if;
   end amplitud ;
   
   
function ex_izq( t: in arbol ) return boolean is
      l:arbol;
   begin
       izq(t,l);
      return esta_vacio(l);
   end ex_izq;

   function ex_der( t: in arbol ) return boolean is
    r:arbol;
   begin

      der(t,r);
      return esta_vacio(r);
   end ex_der;

      end darbolbinario;
