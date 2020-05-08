--Francesc Nova Prieto y Francisco José Muñoz Navarro
package body dconjunto is
   procedure cvacio(s    : out conjunto) is --O(n)
      e                  : existencia renames s.e;
   begin
      for k in key loop e(k):= false; end loop;
   end cvacio;
   procedure poner(s     : in out conjunto; k: in key; x: in item) is
      e                  : existencia renames s.e;
      c                  : contenido renames s.c;
   begin
      if e(k) then raise ya_existe; end if ;
      e(k):= true; c(k):= x;
   end poner;

   procedure actualiza(s : in out conjunto; k: in key; x: in item)
   is
      e                  : existencia renames s.e;
      c                  : contenido renames s.c;
   begin
      if not e(k) then raise no_existe; end if ;
      c(k):= x;
   end actualiza;
   procedure consultar(s : in conjunto; k: in key; x: out item)
   is
      e                  : existencia renames s.e;
      c                  : contenido renames s.c;
   begin
      if not e(k) then raise no_existe; end if ;
      x:= c(k);
   end consultar;

   procedure borrar(s    : in out conjunto; k: in key) is
      e                  : existencia renames s.e;
   begin
      if not e(k) then raise no_existe; end if ;
      e(k):= false;
   end borrar;
   
   procedure primero(s   : in conjunto; it : out iterador) is
      e                  : existencia renames s.e;
      k                  : key renames it.k;
      valid              : boolean renames it.valid;
   begin
      k:=key'first;
      while not e(k) and k < key'last loop k:= key'succ(k); end loop;
      
      valid:= e(k); -- puede pasar que el conjunto esté vacío y si sucede el iterador no es válido
   end primero;
   procedure siguiente(s : in conjunto; it : in out iterador) is
      e                  : existencia renames s.e;
      k                  : key renames it.k;
      valid              : boolean renames it.valid;
   begin
      if not valid then raise mal_uso; end if ;
      if k < key'last then -- descartamos que no esté sobre el último elemento
         k:= key'succ(k);
         while not e(k) and k < key'last loop k := key'succ(k); end loop;
         valid:= e(k);
      else valid:= false;
      end if ;
   end siguiente; 
   --Arrays indexados por
   -- claves
   function es_valido(it : in iterador) return boolean is
   begin
      return it.valid;
   end es_valido;
   procedure obtener(s   : in conjunto; it :in iterador; k: out key; x: out
                       item) is
      c                  : contenido renames s.c;
      valid              : boolean renames it.valid;
   begin
      if not valid then raise mal_uso; end if ;
      k:= it.k;
      x:= c(k);
   end obtener; 
   
--     procedure recorrido(s : in conjunto) is
--        it: iterador;
--       -- dniAct:d_dni;
--        --notaAct: d_nota;
--     begin
--        primero(s, it);
--        while es_valido(it) loop
--           --obtener(s, it, dniAct, notaAct);
--           siguiente(s, it);
--        end loop;
--     end recorrido;
--     
--     
--     procedure busqueda(s : in conjunto;k: in key ; x: out item) is
--        encontrado        : boolean;
--        it                : iterador;
--     begin
--        primero(s, it); encontrado:= false;
--        while es_valido(it) and not encontrado loop
--           obtener(s, it, k, x);
--           if p(k, x) then encontrado:= true; -- p es cualquier operación que
--              --necesitemos
--           else siguiente(s, it);
--           end if ;
--        end loop;
--        if encontrado then success(k, x);-- succes es cualquier operación
--        else failure;
--        end if ;
--     end busqueda;

   
end dconjunto;
