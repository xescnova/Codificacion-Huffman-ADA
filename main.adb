--Francesc Nova Prieto y Francisco José Muñoz Navarro
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with Text_IO;
use Text_IO;
with dconjunto;
with darbolbinario;
with d_priority_queue;
procedure Main is
   subtype alfabet is Character range ' ' .. 'z';
   package d_taula_frequencies is new dconjunto(key => alfabet,item =>Integer);
   use d_taula_frequencies;
   F_Entrada , F_Sortida ,F_Sortida_Codi : File_Type;

   --nodo(caracter,frecuencia) Segunda entrega
   type nodo is record
      caracter : Character ;
      frequencia : Integer ;
   end record ;

      --funcion imprimir elementos en dcola
   procedure imprimir(x: in nodo) is
   begin
      Put(x.caracter & ": ");
      Put_Line(Integer'Image(x.frequencia));
   end imprimir ;

   package darbre is new darbolbinario ( elem => nodo , visitar => imprimir) ;
   use darbre ;
   type parbol is access arbol ;

   --funciones genéricas ordenadas por frecuencias
   function major(x1,x2 : in parbol) return boolean is
      nodo1: nodo;
      nodo2: nodo;
   begin
      raiz(x1.all,nodo1);
      raiz(x2.all,nodo2);
      return nodo1.frequencia > nodo2.frequencia;

   end major;

   function menor(x1,x2 : in parbol) return boolean is
      nodo1: nodo;
      nodo2: nodo;
   begin
      raiz(x1.all,nodo1);
      raiz(x2.all,nodo2);
      return nodo1.frequencia < nodo2.frequencia;

   end menor;

   package d_priority_queue_integer is new d_priority_queue ( size => 20 , item => parbol , "<" => menor, ">" => major) ;
   use d_priority_queue_integer;


   --Semana 4
   -- codi es troba format per :
   -- c: array de caracters (0 , 1)
   -- l: natural que indica la longitud del codi
   type arrayCodigo is array(1..10) of Character;
   type tcodi is record
      c: arrayCodigo;
      l : natural ;
   end record ;


   --recorre el conjunto y escribe en el fichero "entrada_freq.txt" el caracter
   --junto a su frecuencia
   procedure recorrido(s: in conjunto) is
      it: iterador;
      k: Character; --caracter
      x:Integer; --frecuencia del caracter
   begin
      Create(F_Sortida, Mode => Out_File ,Name => "entrada_freq.txt");
      primero(s, it);
      while es_valido(it) loop
         obtener(s, it, k, x);
         Put(F_Sortida,k);
         Put(F_Sortida,":");
         Put(F_Sortida,x);
         Put_Line(F_Sortida,"");
         siguiente(s, it);
      end loop;
      Close(F_Sortida);
   end recorrido;

   --busca el carácter pasado por parámetro en el conjunto y aumenta su frecuencia
   --en 1 y si no lo encuentra lo crea con frecuencia 1
   procedure busqueda(c: in Character ;s: in out conjunto ) is
      k: Character;
      x:Integer;
      encontrado        : boolean;
      it                : iterador;
   begin
      primero(s, it); encontrado:= false;
      while es_valido(it) and not encontrado loop
         obtener(s, it, k, x);
         if k=c then encontrado:= true;
         else siguiente(s, it);
         end if ;
      end loop;
      if encontrado then actualiza(s,k,x+1);--aumentamos en 1 la frecuencia
      else
         poner(s,c,1); --creamos el caracter con frecuencia 1
      end if ;
   end busqueda;

   --recorre el conjunto mediante un iterador , creamos un arbol para cada pareja
   --de llave-valor mediante la funcion graft y lo insertamos en la cola de prioridad
   --con put(cola,elemento)
   procedure recorridoInsercion(s: in out conjunto ; cola: in out priority_queue) is
      it: iterador;
      k: Character; --caracter
      x:Integer; --frecuencia del caracter
      a:parbol;
      arbolVacio:parbol;
      n:nodo; --caracter/frecuencia (main)
   begin
      primero(s, it);
      while es_valido(it) loop
         obtener(s, it, k, x);
         n.caracter := k; --nodo info
         n.frequencia := x; --nodo info
         a := new arbol;
         arbolVacio:= new arbol;
         avacio(arbolVacio.all);
         avacio(a.all);
         graft(a.all,arbolVacio.all,arbolVacio.all,n);
         put(cola,a);
         siguiente(s, it);
      end loop;

   end recorridoInsercion;

   --recorremos la cola de prioridad , cogemos el elemento mas pequeño,
   --imprimimos por pantalla su llave y frecuencia y lo eliminamos de la cola
   --de prioridad
   procedure imprimirCola(cola: in out priority_queue) is
      a:parbol;
      n: nodo;
   begin
      a:= get_least(cola);
      raiz(a.all,n);
      Put(n.caracter);
      Put(":   ");
      Put(n.frequencia);
      Put_Line("");
      delete_least(cola);
      while not is_empty(cola) loop
         a:= get_least(cola);
         raiz(a.all,n);
         Put(n.caracter);
          Put(":   ");
         Put(n.frequencia);
         Put_Line("");
         delete_least(cola);
      end loop;
   end imprimirCola;

   --funcion que crea el arbol de huffman haciendo la unión de los dos elementos
   --más pequeños de la cola siendo la raíz de este la suma de la frecuencia de
   -- sus hijos y caracter '-' y los vuelve a instertar en la cola de prioridad.
   --Acaba cuando solo queda un elemento en la cola : el arbol de huffman.
   procedure arbolHuffman(t1: in out parbol;cola : in out priority_queue) is
      t2:parbol;
      a:parbol;
      n1:nodo;
      n2:nodo;
      nArbol:nodo;
   begin
         --t1:= new arbol;
      while not is_empty(cola) loop
         -- Extreure l'element amb menys  frequencia
         t1:= get_least(cola);
         delete_least(cola);
         if not is_empty(cola) then
            --Contenia almenys dos elements
            a:= new arbol;
            t2:= get_least(cola);
            delete_least(cola);
            nArbol.caracter:='-';
            raiz(t1.all,n1);
            raiz(t2.all,n2);
            nArbol.frequencia:=n1.frequencia+n2.frequencia;
            graft(a.all,t1.all,t2.all,nArbol);
            put(cola,a);
         end if;
         end loop;
   end arbolHuffman;

   --función que hace un recorrido recursivo en forma de preorden y genera la codificación
   -- del carácter que consistirá en un array de 1's y 0's según el recorrido
   --hasta encontrar el carácter. Se añadirá un 0 si es hijo izq y 1 si es hijo der.
   procedure genera_codi ( x : in arbol ; c : in character ; trobat :
                           in out boolean ; idx : in integer ; codi : in out tcodi ) is
      l , r : arbol ;
      n:nodo;
   begin
      if not trobat  then
         raiz(x,n);
         if n.caracter/= c then
            if not ex_izq(x) then
               -- visitar node consisteix en:
               -- comprovar si l' arrel de l' arbre conte el caracter
               -- Si no hem trobat el caracter :
               -- Baixar cap al fill esquerra i afegir un '0'
               codi.c ( idx ) := '0';
               codi.l := idx ;
               izq (x,l) ;
               genera_codi (l , c , trobat , idx +1 , codi ) ;
            end if;
            -- Si no hem trobat el caracter :
            -- Baixar cap al fill dret i afegir un '1'
            if not trobat then
               if not ex_der(x) then
                  codi.c(idx) := '1';
                  codi.l := idx ;
                  der(x ,r) ;
                  genera_codi (r,c,trobat,idx +1,codi) ;
               end if;
            end if;
         else
            trobat:= True;
         end if;
      end if;
   end genera_codi ;


   --función que hace un recorrido al conjunto que en este caso es el alfabeto
   --y con la función recursiva generar-codi genera el código para cada carácater
   --del conjunto que se encuentre en el texto
   procedure generarCodificacion(s: in out conjunto;t1: in out parbol) is
      it: iterador;
      k: Character; --caracter
      x:Integer; --frecuencia del caracter
      codi: tcodi;
      trobat:Boolean;
   begin
      Create(F_Sortida_Codi, Mode => Out_File ,Name => "entrada_codi.txt");
      primero(s, it);
      trobat:= False;
      while es_valido(it) loop
         obtener(s, it, k, x);
         genera_codi(t1.all,k,trobat,1,codi);
         Put(F_Sortida_Codi,k);
         Put(F_Sortida_Codi,":");
         for i in 1..codi.l loop
          Put(F_Sortida_Codi,codi.c(i));
         end loop;
         siguiente(s, it);
         Put_Line(F_Sortida_Codi,"");
         trobat:=false;
      end loop;
      Close(F_Sortida_Codi);
   end generarCodificacion;

   car: Character;
   s: conjunto;

     --creamos la cola de prioridad
   cola: priority_queue;

   --Tercera entrega
   --Arbol de Huffman
   t1:parbol;
begin

   Open(F_Entrada, Mode => In_File , Name => "entrada.txt");
   cvacio(s); --inicializamos el conjunto
   empty(cola); --inicializamos la cola
   while not End_Of_File(F_Entrada) loop
      get(F_Entrada,car);
      busqueda(car,s);
   end loop;
   recorrido(s);
   recorridoInsercion(s,cola);
   --imprimirCola(cola);
   arbolHuffman(t1,cola);
   --amplitud(t1.all);
   generarCodificacion(s,t1);
   Close(F_Entrada);
   null;
end Main;
