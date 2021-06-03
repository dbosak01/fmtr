#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
CharacterVector lookup(CharacterVector x, CharacterVector lkp) {
  
  CharacterVector ret = clone(x); 
  
  for (int i = 0; i < x.length(); i++) {
    if (lkp.containsElementNamed(x[i])) {
      ret[i] = lkp[lkp.findName(Rcpp::as<std::string>(x[i]))];
    }
  }
  
  return ret;
}




