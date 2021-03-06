// Example translator to generate dot files of virtual, interprocedural control flow graphs
#include "rose.h"
#include "interproceduralCFG.h"
#include <string>
using namespace std;
using namespace Rose;

int main(int argc, char *argv[]) 
{
  // Initialize and check compatibility. See Rose::initialize
  ROSE_INITIALIZE;

  // Build the AST used by ROSE
  SgProject* proj = frontend(argc,argv);
  ROSE_ASSERT (proj != NULL); 

  SgFunctionDeclaration* mainDefDecl = SageInterface::findMain(proj);
  ROSE_ASSERT (mainDefDecl != NULL); 

  SgFunctionDefinition* mainDef = mainDefDecl->get_definition();
  ROSE_ASSERT (mainDef != NULL); 

  string fileName= StringUtility::stripPathFromFileName(mainDef->get_file_info()->get_filenameString());
  string dotFileName1=fileName+"."+ mainDef->get_declaration()->get_name() +".IPCFG.dot";

  StaticCFG::InterproceduralCFG cfg(mainDef);

  // Dump out the full CFG, including bookkeeping nodes
  cfg.cfgToDot(mainDef, dotFileName1);

  return 0;
}
