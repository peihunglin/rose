
namespace N
   {
  // static union union_tag { int a; };
     static union union_tag { int a; } union_var;
   }

void foobar()
   {
  // &N::a;
     &N::union_tag::a;
   }

