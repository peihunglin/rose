with Ada.Exceptions;
with Ada.Text_IO;
-- For int."+":
with Interfaces.C;

with a_nodes_h.Support;

package body A_Nodes is

   Package_Name : constant String := "A_Nodes";

   package AEX renames Ada.Exceptions;
   package ATI renames Ada.Text_IO;

   -- Checks to be sure no node with this ID has already been pushed.  Raises
   -- Usage_Error if so.
   procedure Check_Context_Node
     (This : access Class;
      Node : in a_nodes_h.Context_Struct)
   is
      Name : constant String := Package_Name & ".Check_Context_Node";
   begin
      If This.Has_Context then
         raise Usage_Error with Name &
           ": Tried to push second Context";
      else
         This.Has_Context := True;
      end if;
   end Check_Context_Node;

   -- Checks to be sure no node with this ID has already been pushed.  Raises
   -- Usage_Error if so.
   procedure Check_Unit_Node
     (This : access Class;
      Unit : in a_nodes_h.Unit_Struct)
   is
      Name : constant String := Package_Name & ".Check_Unit_Node";
      ID   : constant a_nodes_h.Unit_ID := Unit.ID;
   begin
      if This.Unit_IDs.Contains (ID) then
         raise Usage_Error with Name &
           ": Tried to push second Unit with ID => " & ID'Image;
      else
         This.Unit_IDs.Insert (ID);
      end if;
   end Check_Unit_Node;

   -- Checks to be sure no node with this ID has already been pushed.  Raises
   -- Usage_Error if so.
   procedure Check_Element_Node
     (This : access Class;
      Element : in a_nodes_h.Element_Struct)
   is
      Name : constant String := Package_Name & ".Check_Element_Node";
      ID   : constant a_nodes_h.Element_ID := Element.ID;
   begin
      if This.Element_IDs.Contains (ID) then
         raise Usage_Error with Name &
           ": Tried to push second Element with ID => " & ID'Image;
      else
         This.Element_IDs.Insert (ID);
      end if;
   end Check_Element_Node;

   -- Checks to be sure no node with this ID has already been pushed.  Raises
   -- Usage_Error if so.
   procedure Check_Node
     (This : access Class;
      Node : in a_nodes_h.Node_Struct)
   is
      Name : constant String := Package_Name & ".Check_Node";
      use all type a_nodes_h.Node_Kinds;
   begin
      case Node.Node_Kind is
         when Not_A_Node =>
            raise Usage_Error with Name &
              ": Tried to push Node with Node_Kind => " & Node.Node_Kind'Image;
         when  A_Context_Node =>
            Check_Context_Node (This, Node.The_Union.Context);
         when A_Unit_Node =>
            Check_Unit_Node (This, Node.The_Union.Unit);
         when An_Element_Node =>
            Check_Element_Node (This, Node.The_Union.Element);
      end case;
   end Check_Node;


   procedure Print_Exception_Info
     (Module_Name : in String;
      X           : in AEX.Exception_Occurrence) is
   begin
      ATI.Put_Line ((1 .. 40 => '#'));
      ATI.Put_Line (Module_Name & ": EXCEPTION: " & Aex.Exception_Name (X) &
                  " (" & Aex.Exception_Information (X) & ")");
      ATI.Put_Line ((1 .. 40 => '#'));
   end Print_Exception_Info;


   ------------
   -- EXPORTED:
   ------------
   procedure Push
     (This : access Class;
      Node : in     a_nodes_h.Node_Struct)
   is
      Module_Name : constant String := Package_Name & ".Push";
      List_Node : a_nodes_h.List_Node_Struct :=
        a_nodes_h.Support.Default_List_Node_Struct;
      use type Interfaces.C.int;
   begin
      begin
         Check_Node (This, Node);
      exception
         when X : Usage_Error =>
            Print_Exception_Info (Module_Name, X);
            ATI.Put_Line ("Continuing...");
      end;
      List_Node.node := Node;
      if This.Is_Empty then
         List_Node.next := null;
         List_Node.next_count := 0;
      else
         List_Node.next := This.Head;
         List_Node.next_count := This.Head.next_count + 1;
      end if;
      This.Head := new a_nodes_h.List_Node_Struct'(List_Node);
   end Push;

   ------------
   -- EXPORTED:
   ------------
   function Get_Head
     (This : access Class)
      return a_nodes_h.Node_List_Ptr is
   begin
      return This.Head;
   end Get_Head;

   ------------
   -- EXPORTED:
   ------------
   function Is_Empty
     (This : access Class)
      return Boolean
   is
      use type a_nodes_h.Node_List_Ptr;
   begin
      return This.Head = null;
   end Is_Empty;

end A_Nodes;
